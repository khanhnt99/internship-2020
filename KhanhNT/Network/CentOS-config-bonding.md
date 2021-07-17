# Config bonding trên CentOS

## 1. Bonding

```
modprobe bonding
[root@controller ~]# modinfo bonding 
filename:       /lib/modules/3.10.0-1160.el7.x86_64/kernel/drivers/net/bonding/bonding.ko.xz
author:         Thomas Davis, tadavis@lbl.gov and many others
description:    Ethernet Channel Bonding Driver, v3.7.1
version:        3.7.1
license:        GPL
alias:          rtnl-link-bond
retpoline:      Y
rhelversion:    7.9
srcversion:     3B2F8F8533AEAE2EB01F706
depends:        
intree:         Y
vermagic:       3.10.0-1160.el7.x86_64 SMP mod_unload modversions 
signer:         CentOS Linux kernel signing key
sig_key:        E1:FD:B0:E2:A7:E8:61:A1:D1:CA:80:A2:3D:CF:0D:BA:3A:A4:AD:F5
sig_hashalgo:   sha256
```

- vi `/etc/sysconfig/network-scripts/ifcfg-bond0`
```
DEVICE=bond0
NAME=bond0
BONDING_MASTER=yes
TYPE=Bond
ONBOOT=yes
BOOTPROTO=none
BONDING_OPTS="mode=802.3ad miimon=100 lacp_rate=fast"
NM_CONTROLLED=no
```

- vi `/etc/sysconfig/network-scripts/ifcfg-enp5s0f0`
```
TYPE=Ethernet
BOOTPROTO=none
NAME=enp5s0f0
UUID=xxx
DEVICE=enp5s0f0
ONBOOT=yes
MASTER=bond0
SLAVE=yes
NM_CONTROLLED=no
```

- vi `/etc/sysconfig/network-scripts/ifcfg-enp5s0f1`
```
TYPE=Ethernet
BOOTPROTO=none
NAME=enp5s0f1
UUID=xxx
DEVICE=enp5s0f1
ONBOOT=yes
MASTER=bond0
SLAVE=yes
NM_CONTROLLED=no
```

```
[root@controller ~]# cat /proc/net/bonding/bond0 
Ethernet Channel Bonding Driver: v3.7.1 (April 27, 2011)

Bonding Mode: IEEE 802.3ad Dynamic link aggregation
Transmit Hash Policy: layer2 (0)
MII Status: up
MII Polling Interval (ms): 100
Up Delay (ms): 0
Down Delay (ms): 0

802.3ad info
LACP rate: fast
Min links: 0
Aggregator selection policy (ad_select): stable
System priority: 65535
```

## 2. InterfaceVLAN

```
[root@controller ~]# lsmod | grep 8021q
8021q                  33080  0 
garp                   14384  1 8021q
mrp                    18542  1 8021q
```

- vi `/etc/sysconfig/network-scripts/ifcfg-bond0.53`
```
DEVICE=bond0.53
NAME=bond0.53
BOOTPROTO=none
ONPARENT=yes
IPADDR=192.168.53.32
NETMASK=255.255.255.0
NETWORK=192.168.53.0
VLAN=yes
NM_CONTROLLED=no
GATEWAY=192.168.53.1
DNS1=8.8.8.8
```


__Docs__
- https://tuxfixer.com/configure-bridge-interface-over-vlan-tagged-bonded-interface-on-centos-rhel/
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/7/html/networking_guide/sec-configure_802_1q_vlan_tagging_using_the_command_line
- https://access.redhat.com/documentation/en-us/red_hat_enterprise_linux/6/html/deployment_guide/sec-configuring_a_vlan_over_a_bond

