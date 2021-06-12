# Cấu hình bonding interface vlan
```
root@controller:~# modprobe bonding
root@controller:~# lsmod | grep bonding
bonding               167936  0
```

- Edit `/etc/modules`
```
bonding
```





```
network:
    version: 2
    ethernets:
        enp5s0f0:
                dhcp4: false
        enp5s0f1:
                dhcp4: false
    bonds:
         bond0:
            interfaces: [enp5s0f0, enp5s0f1]
            mtu: 9000
            parameters:
                 mode: 802.3ad
                 lacp-rate: fast
                 mii-monitor-interval: 100
                 transmit-hash-policy: layer2
    vlans:
          bond0.53:
                  dhcp4: no
                  id: 53
                  link: bond0
                  mtu: 9000
                  addresses: [192.168.53.32/24]
                  gateway4: 192.168.53.1
          bond0.54:
                  dhcp4: no
                  id: 54
                  link: bond0
                  mtu: 9000
                  addresses: [192.168.54.32/24]
```

- Detail bonding
```
root@controller:~# cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2 (0)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0
Peer Notification Delay (ms): 0

802.3ad info
LACP rate: fast
Min links: 0
Aggregator selection policy (ad_select): stable
System priority: 65535
System MAC address: c6:cf:70:d8:42:21
Active Aggregator Info:
	Aggregator ID: 1
	Number of ports: 2
	Actor Key: 15
	Partner Key: 100
	Partner Mac Address: 01:e0:52:00:00:01

Slave Interface: enp5s0f1
MII Status: up
Speed: 10000 Mbps
Duplex: full
Link Failure Count: 0
Permanent HW addr: ac:1f:6b:8a:48:6f
Slave queue ID: 0
Aggregator ID: 1
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
    system priority: 65535
    system mac address: c6:cf:70:d8:42:21
    port key: 15
    port priority: 255
    port number: 1
    port state: 63
details partner lacp pdu:
    system priority: 32768
    system mac address: 01:e0:52:00:00:01
    oper key: 100
    port priority: 32768
    port number: 514
    port state: 61

Slave Interface: enp5s0f0
MII Status: up
Speed: 10000 Mbps
Duplex: full
Link Failure Count: 1
Permanent HW addr: ac:1f:6b:8a:48:6e
Slave queue ID: 0
Aggregator ID: 1
Actor Churn State: none
Partner Churn State: none
Actor Churned Count: 0
Partner Churned Count: 0
details actor lacp pdu:
    system priority: 65535
    system mac address: c6:cf:70:d8:42:21
    port key: 15
    port priority: 255
    port number: 2
    port state: 63
details partner lacp pdu:
    system priority: 32768
    system mac address: 01:e0:52:00:00:01
    oper key: 100
    port priority: 32768
    port number: 513
```

__Docs__
- https://askubuntu.com/questions/1033531/how-can-i-create-a-bond-interface-in-ubuntu-18-04
- https://www.snel.com/support/how-to-set-up-lacp-bonding-on-ubuntu-18-04-with-netplan/