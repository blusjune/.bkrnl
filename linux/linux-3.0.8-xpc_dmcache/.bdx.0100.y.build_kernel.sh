#!/bin/sh

_tstamp="$(tstamp)";
_whoami="$(whoami)";
_build_dir__default="/x/linux_kernel_build-$_tstamp";




make mrproper;




read -p "#>> directory to build the kernel: " _build_dir;
if [ "X$_build_dir" = "X" ]; then
	_build_dir=$_build_dir__default;
	if [ ! -d $_build_dir ]; then
		sudo mkdir -p $_build_dir;
		sudo chown -R $_whoami $_build_dir;
		echo "#>> $_build_dir is created";

		_config_latest=$(ls -1 .config* | sort | tail -1);
		cp $_config_latest $_build_dir;
		edco "#>> latest .config file ($_config_latest) is copied to $_build_dir";
	fi
fi




echo "#>> please make sure you have proper '.config' file";
echo "#   you may have to do one of the following actions:
	make O=$_build_dir menuconfig;    ...........................(1)
	cd $_build_dir; ln -s _latest_config_file_ .config;    ......(2)
";
read -p "#>> whcih action do you want to do [1|2|n] " _ans;
case "X$_ans" in
	"X1")
		echo "#>> make O=$_build_dir menuconfig;";
		make O=$_build_dir menuconfig;
		;;
	"X2")
		echo "#>> cd $_build_dir; ln -s $_config_latest .config;";
		(cd $_build_dir; ln -s $_config_latest .config;)
		;;
	*)
		echo "#>> nothing (config) happened -- exit";
		exit 0;
		;;
esac




read -p "#>> continue to build the kernel? [y|n] " _ans;
if [ "X$_ans" != "Xy" ]; then
	echo "#>> nothing (build) happened -- exit";
	exit 0;
fi
if [ ! -f $_build_dir/.config ]; then
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




