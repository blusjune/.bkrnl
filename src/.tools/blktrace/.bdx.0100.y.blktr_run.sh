#!/bin/sh
##.bdx.0100.y.blktr_run.sh
##_ver=20121221_200656
##_ver=20121222_152258


_tstamp="$(tstamp)";


if [ "X$(id -u)" != "X0" ]; then
	echo "#>> you MUST be root -- EXIT";
	exit 2;
fi




read -p "#<< pre-tune the system? [y|n] " _ans;
if [ "X$_ans" = "Xy" ]; then
	. .bdx.0110.n.blktr_pretune_system.sh		# for ease of observation (blktracing)
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
