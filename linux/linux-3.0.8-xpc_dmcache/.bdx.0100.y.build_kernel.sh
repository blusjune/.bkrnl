#!/bin/sh

_tstamp="$(tstamp)";
_build_dir__default="/x/linux_kernel_build-$_tstamp";




make mrproper;




read -p "#>> directory to build the kernel: " _build_dir;
if [ "X$_build_dir" = "X" ]; then
	_build_dir=$_build_dir__default;
fi
read -p "#>> ready to do 'make O=$_build_dir menuconfig'? [y|n] " _ans;
if [ "X$_ans" = "Xy" ]; then
	make O=$_build_dir menuconfig;
else
	exit 0;
fi

echo "#>> please make sure that you have proper '.config' file";
read -p "#>> escape to a shell to check '.config' file? [y|n] " _ans;
if [ "X$_ans" = "Xy" ]; then
	bash;
fi
read -p "#>> continue to build the kernel? [y|n] " _ans;
if [ "X$_ans" != "Xy" ]; then
	exit 0;
fi

if [ ! -f .config ]; then
	echo "#>> cannot go any further: '.config' file is needed -- exit";
	exit 0;
fi




make O=$_build_dir;




read -p "#>> ready to do install kernel and modules? [y|n] " _ans;
if [ "X$_ans" = "Xy" ]; then
	echo "#>> sudo make O=$_build_dir modules_install install";
	sudo make O=$_build_dir modules_install install;
else
	echo "#>> exit without installing anything to the system";
	exit 0;
fi




