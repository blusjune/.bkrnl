#!/bin/sh
##_ver=20121221_200656


_tstamp="$(tstamp)";


if [ "X$(id -u)" != "X0" ]; then
	echo "#>> you MUST be root -- EXIT";
	exit 2;
fi

read -p "#<< device to block trace: " _dev;
if [ "X$_dev" = "X" ]; then
	echo "#>> device to trace MUST be specified -- EXIT";
	exit 2;
fi


_dev_safename=$(echo $_dev | sed -e 's/\//_/g' );
_outdir=".explog";
_bplog="${_outdir}/btlog.${_tstamp}.$_dev_safename.log";
_bpbin="${_outdir}/btlog.${_tstamp}.$_dev_safename.bin";
echo "blktrace: $_dev_safename";

#blktrace -d $_dev -o - | blkparse -i - -d $_bpbin;
blktrace -d $_dev -o - | blkparse -i -
