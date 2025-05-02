A diagram representing the flow of *incoming* traffic through the example `nftables` ruleset provided earlier. This focuses primarily on the `input` chain, as that's where protection for services running on the machine itself is handled.

```mermaid
graph LR
    subgraph ExtNet [External Network]
        PacketIn[Packet Arrives]
    end

    subgraph SysNIC [System Network Interface]
        NIC[NIC]
    end

    subgraph Nftables [Nftables Processing - inet filter]
        direction TB
        InputHook[Input Chain Hook]

        subgraph InputChain [Input Chain - policy DROP]
            direction TB
            R1{"ct state<br/>established,related?"} -- Yes --> Acc1[ACCEPT<br/>To Local Process]
            R1 -- No --> R2{"ct state<br/>invalid?"}
            R2 -- Yes --> Drop1[DROP]
            R2 -- No --> R3{"iifname lo?"}
            R3 -- Yes --> Acc2[ACCEPT<br/>To Local Process]
            R3 -- No --> R4{"Allowed ICMP<br/>(rate limited)?"}
            R4 -- Yes --> Acc3[ACCEPT<br/>To Local Process]
            R4 -- No --> R5{"TCP dport 22<br/>(SSH)?"}
            R5 -- Yes --> Acc4[ACCEPT<br/>To SSH Service]
            R5 -- No --> R6{"TCP dport 80<br/>(HTTP)?"}
            R6 -- Yes --> Acc5[ACCEPT<br/>To Web Service]
            R6 -- No --> R7{"TCP dport 443<br/>(HTTPS)?"}
            R7 -- Yes --> Acc6[ACCEPT<br/>To Web Service]
            R7 -- No --> PolDrop[Default Policy<br/>DROP]
        end

        ForwardHook[Forward Chain Hook - policy DROP] -- "Not locally destined" --> FwdDrop[DROP]
        OutputHook[Output Chain Hook - policy ACCEPT] <-- LocalGenPkt[Packet from Local Process]

    end

    subgraph LocalSys [Local System]
        direction TB
        LocalProc[Local Services<br/>SSH, Web, etc.]
        LoInterface[Loopback 'lo']
    end

    %% Connections
    PacketIn --> NIC
    NIC --> InputHook
    InputHook --> R1
    NIC -- "Routing Decision" --> ForwardHook
    LocalProc --> LocalGenPkt
    LocalGenPkt --> OutputHook
    Acc1 --> LocalProc
    Acc2 --> LoInterface
    LoInterface --> LocalProc
    Acc3 --> LocalProc
    Acc4 --> LocalProc
    Acc5 --> LocalProc
    Acc6 --> LocalProc
    OutputHook --> NIC --> ExtNet

    %% Styling (Simplified)
    classDef accept fill:#ccffcc,stroke:#333;
    classDef drop fill:#ffcccc,stroke:#333;
    class Acc1,Acc2,Acc3,Acc4,Acc5,Acc6 accept;
    class Drop1,PolDrop,FwdDrop drop;
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
