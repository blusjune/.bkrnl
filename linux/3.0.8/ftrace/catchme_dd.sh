#!/bin/sh




echo "===================";
echo "PID: $$";
echo "-------------------";

read -p "_dd_ifname: " _dd_ifname;
_dd_if="/x/bigfile/$_dd_ifname";
read -p "_dd_blksz: " _dd_blksz;
read -p "_dd_skip: " _dd_skip;
read -p "_dd_count: " _dd_count;


echo "===================";
read -p "ready to go? [y|n]" _ans;
if [ "X$_ans" != "Xy" ]; then
	echo "exit!!!";
	exit 0;
fi

exec dd if=$_dd_if bs=$_dd_blksz skip=$_dd_skip count=$_dd_count of=/dev/null

#exec hdparm --fibmap 8xhosts;
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154368:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154368:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154372:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154376:4 /dev/sdb



