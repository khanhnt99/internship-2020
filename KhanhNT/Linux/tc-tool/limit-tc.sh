#!/bin/bash
IF="ens3"
echo "$IF"
ifb="ifb3"
echo "$ifb"
lan="192.168.0."
down="50000"
up="5000"

TC=$(which tc)

modprobe ifb numifb=1
ip link add $ifb type ifb
ip link set dev $ifb up

## Limit incoming traffic

### Clean interface

run_traffic_control() 
{
      $TC qdisc del dev $IF handle ffff: ingress > /dev/null 2>&1
      $TC qdisc del root dev $ifb > /dev/null 2>&1
      $TC qdisc del root dev $IF > /dev/null 2>&1
      
      #$TC qdisc add dev $IF root handle 1: htb default 999
      $TC qdisc add dev $IF handle ffff: ingress > /dev/null 2>&1
      
      ### Redirect ingress ens3 to egress ifb3
      $TC filter add dev $IF parent ffff: protocol ip u32 match u32 0 0 action mirred egress redirect dev $ifb > /dev/null 2>&1
      $TC qdisc add dev $ifb root handle 1: htb default 10 2>&1
      $TC qdisc add dev $IF root handle 1: htb default 10 2>&1
      
      for i in $(seq 1 255); do
	      # Limit Download
	      #TC class add dev $ifb parent 1:1 classid 1:$i htb rate ${down}kbit	
      	      $TC class add dev $IF parent 1:1 classid 1:$i htb rate ${down}kbit > /dev/null 2>&1	
      	      $TC filter add dev $IF protocol ip parent 1: prio 1 u32 match ip dst $lan$i/32 flowid 1:$i > /dev/null 2>&1

	      # Limit Upload
	      $TC class add dev $ifb parent 1:1 classid 1:$i htb rate ${up}kbit > /dev/null 2>&1
	      $TC filter add dev $ifb protocol ip parent 1: prio 1 u32 match ip src $lan$i/32 flowid 1:$i > /dev/null 2>&1

      done
} 

stop_traffic_control()
{
	$TC qdisc del dev $IF root > /dev/null 2>&1
	$TC qdisc del dev $IF parent ffff: > /dev/null 2>&1
	$TC qdisc del dev $ifb root > /dev/null 2>&1
	ip link del $ifb
}

case "$1" in
	start)
		echo -n "Starting bandwidth shaping "
		run_traffic_control
		echo "done start"
		;;
	
	stop)
		echo -n "Stoping bandwidth shaping "
		stop_traffic_control
		echo "done stop"
		;;

	*)
		pwd=$(pwd)
		echo "Usage: bash limit-tc.sh {start|stop}"
		;;
esac

exit 0
