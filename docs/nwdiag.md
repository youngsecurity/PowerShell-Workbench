# Network Diagram Automation

Testing network diagram content creation automation

## Background

Network diagram content creation automation can bring significant benefits to organizations and professionals working on network design, maintenance, or troubleshooting. Benefits from increasing efficiency, accuracy, and collaboration to reducing costs and enabling better decision-making. It can significantly enhance the management and scalability of networks while ensuring compliance and improving troubleshooting capabilities.

## Source

[Kroki//Docs](https://docs.kroki.io/kroki/setup/use-docker-or-podman/)

```nwdiag {kroki=true}
nwdiag {
  network dmz {
    address = "210.x.x.x/24"

    web01 [address = "210.x.x.1"];
    web02 [address = "210.x.x.2"];
  }
  network internal {
    address = "172.x.x.x/24";

    web01 [address = "172.x.x.1"];
    web02 [address = "172.x.x.2"];
    db01;
    db02;
  }
}
```
