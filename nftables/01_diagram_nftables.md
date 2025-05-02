A diagram representing the flow of *incoming* traffic through the example `nftables` ruleset provided earlier. This focuses primarily on the `input` chain, as that's where protection for services running on the machine itself is handled.

```mermaid
graph LR
    subgraph "External Network"
        direction LR
        PacketIn("Packet Arrives")
    end

    subgraph "System Network Interface (e.g., eth0)"
        direction LR
        NIC("NIC")
    end

    subgraph "Nftables Processing (inet table 'filter')"
        direction TB
        InputHook["Input Chain Hook"]

        subgraph "Input Chain (policy DROP)"
            direction TB
            R1{"ct state<br/>established,related?"} -- Yes --> Accept1["ACCEPT / To Local Process"]
            R1 -- No --> R2{"ct state<br/>invalid?"}
            R2 -- Yes --> Drop1["DROP"]
            R2 -- No --> R3{"iifname lo?"}
            R3 -- Yes --> Accept2["ACCEPT / To Local Process"]
            R3 -- No --> R4{"Allowed ICMP<br/>(rate limited)?"}
            R4 -- Yes --> Accept3["ACCEPT / To Local Process"]
            R4 -- No --> R5{"TCP dport 22<br/>(SSH)?"}
            R5 -- Yes --> Accept4["ACCEPT / To SSH Service"]
            R5 -- No --> R6{"TCP dport 80<br/>(HTTP)?"}
            R6 -- Yes --> Accept5["ACCEPT / To Web Service"]
            R6 -- No --> R7{"TCP dport 443<br/>(HTTPS)?"}
            R7 -- Yes --> Accept6["ACCEPT / To Web Service"]
            R7 -- No --> PolicyDrop["Default Policy: DROP"]
        end

        ForwardHook["Forward Chain Hook (policy DROP)"] -- "Not locally destined" --> FwdDrop["DROP (No rules match)"]
        OutputHook["Output Chain Hook (policy ACCEPT)"] <-- LocalProcessGen["Packet from Local Process"]

    end

    subgraph "Local System"
        direction TB
        LocalProcess["Local Services<br/>(SSH, Web, etc.)"]
        Loopback["Loopback 'lo'"]
    end


    PacketIn --> NIC
    NIC --> InputHook

    %% Input Chain Flow
    InputHook --> R1

    %% Connections for other chains (simplified)
    NIC -- "Routing Decision" --> ForwardHook
    LocalProcess --> OutputHook

    %% Connections back to local system
    Accept1 --> LocalProcess
    Accept2 --> Loopback --> LocalProcess
    Accept3 --> LocalProcess
    Accept4 --> LocalProcess
    Accept5 --> LocalProcess
    Accept6 --> LocalProcess

    %% Output Chain (Simplified)
    OutputHook --> NIC --> "External Network"


    %% Styling (Optional, basic mermaid styling)
    classDef default fill:#f9f,stroke:#333,stroke-width:2px;
    classDef accept fill:#ccffcc,stroke:#333,stroke-width:2px;
    classDef drop fill:#ffcccc,stroke:#333,stroke-width:2px;
    classDef process fill:#lightblue,stroke:#333,stroke-width:2px;

    class PacketIn,NIC,InputHook,ForwardHook,OutputHook default;
    class LocalProcess,Loopback,LocalProcessGen process;
    class Accept1,Accept2,Accept3,Accept4,Accept5,Accept6 accept;
    class Drop1,PolicyDrop,FwdDrop drop;
```

**Explanation of the Diagram:**

1.  **Packet Arrival:** A packet arrives from the External Network at the system's Network Interface Card (NIC).
2.  **Input Hook:** If the packet is destined for the machine itself, it enters the `input` chain of the `inet filter` table.
3.  **Input Chain Processing:** The packet is evaluated against the rules sequentially:
    * **Established/Related:** Checks if the packet belongs to an existing connection initiated by the server or is related (like ICMP errors). If yes, it's accepted immediately (stateful firewall core).
    * **Invalid:** Checks for malformed or invalid connection tracking states. If yes, it's dropped.
    * **Loopback:** Checks if it came from the local loopback interface (`lo`). If yes, it's accepted (necessary for internal communication).
    * **ICMP:** Checks if it's an allowed ICMP type (like ping requests) and within the rate limit. If yes, accepted.
    * **SSH (Port 22):** Checks if it's TCP traffic for port 22. If yes, accepted.
    * **HTTP (Port 80):** Checks if it's TCP traffic for port 80. If yes, accepted.
    * **HTTPS (Port 443):** Checks if it's TCP traffic for port 443. If yes, accepted.
4.  **Default Policy:** If the packet doesn't match *any* of the `accept` rules above, it hits the chain's default policy, which is `DROP`. The packet is discarded silently.
5.  **Forward Chain:** If the packet was *not* destined for the local machine but was being routed *through* it, it would hit the `forward` chain. In our example, this chain also has a `DROP` policy and no explicit `accept` rules, so such packets would be dropped.
6.  **Output Chain:** Packets generated *by* local processes go through the `output` chain. Our example has a default `ACCEPT` policy here, allowing outgoing connections.

This diagram visualizes how the `nftables` ruleset acts as a gatekeeper, specifically inspecting incoming traffic and dropping anything not explicitly allowed or part of an established conversation.
