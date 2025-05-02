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
```
