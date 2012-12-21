#!/bin/sh

# echo 0 131072 cache /dev/sdc1 /dev/sdb 0 8 65536 256 0 | dmsetup create dmc0
# echo 2048 3907029167 cache /dev/sdc1 /dev/sdb 0 8 65536 256 0 | dmsetup create dmc0
# echo 2048 3907029167 cache /dev/sdc1 /dev/sdb 0 1 65536 256 0 | dmsetup create dmc0


trial_04()	# it works!
{
umount /dev/sdc
umount /dev/sdb
echo 0 131072 cache /dev/sdc /dev/sdb 0 1 65536 256 0 | dmsetup create dmc0
}




_dmc_conf_01()		## it really works well!!! (first successful configuration)
{
	_srcdsk_start="0";
	_srcdsk_size="131072";		# number of 512B sectors
	_dm_target="cache";
	_srcdsk="/dev/sdc1";
	_cache_media="/dev/sdb1";
	_cache_use_prev_cache="0";
	_cache_media_blksz="8";		# here 8 means 4KB (4096B)
	_cache_media_size="65536";	# number of 512B sectors
	_cache_nway="256";
	_cache_writepolicy="0";		# '0' means no delay
	_dmc_name="dmc0"
}

_dmc_conf_02()		## experimental, _cache_media_size=16777216 is the only successful case
{
	_srcdsk_start="0";
	_srcdsk_size="3907029168";	# size in sector(512B) num (it can be non-'2^n' num, also can be even odd number)
	_dm_target="cache";
	_srcdsk="/dev/sdc";
	_cache_media="/dev/sdb";
	_cache_use_prev_cache="0";
	_cache_media_blksz="8";		# here 8 means 4KB (4096B)
	_cache_media_size="16777216";	# size in sector(512B) num (must be 2^n)	# ok # 2^24
#	_cache_media_size="16777215";	# size in sector(512B) num (must be 2^n)	# failed # 2^24-1
#	_cache_media_size="33554432";	# size in sector(512B) num (must be 2^n)	# failed # 2^24
#	_cache_media_size="67108864";	# size in sector(512B) num (must be 2^n)	# failed # 2^26
#	_cache_media_size="134217728";	# size in sector(512B) num (must be 2^n)	# failed # 2^27
#	_cache_media_size="250069680";	# size in sector(512B) num (must be 2^n)	# failed # 2^?
	_cache_nway="256";
	_cache_writepolicy="0";		# '0' means no delay
	_dmc_name="dmc0"
}


_dmc_conf()
{
#	_dmc_conf_01;
	_dmc_conf_02;

	_dmc_conf_flag="y";
}


trial_05_dmc_make()	# it works!
{
	_dmc_conf;

	if [ "X$_dmc_conf_flag" != "Xy" ]; then
		echo "#>> ERROR: dm-cache is not configured properly -- EXIT";
		exit 2;
	fi

## Note: dmc0 is equivalent to /dev/sdx like block device
## so, before creating dmc0, /dev/sdc1 should not be mounted or used
## please make sure that /dev/sdc1 and /dev/sdb1 is unmounted clearly. 

	echo "------------------------------------------------------------------";
	echo "#>> creating cache $_dmc_name ...";
	echo "$_srcdsk_start $_srcdsk_size $_dm_target $_srcdsk $_cache_media \
$_cache_use_prev_cache $_cache_media_blksz $_cache_media_size $_cache_nway $_cache_writepolicy";
	echo "------------------------------------------------------------------";
	echo "$_srcdsk_start $_srcdsk_size $_dm_target $_srcdsk $_cache_media \
$_cache_use_prev_cache $_cache_media_blksz $_cache_media_size $_cache_nway $_cache_writepolicy" | dmsetup create $_dmc_name;
	_retval=$?;
	if [ "X$_retval" != "X0" ]; then
		echo "#>> FAIL: dmsetup create $_dmc_name -- EXIT"
		echo "------------------------------------------------------------------";
		exit 2;
	else
		echo "#>> SUCCESS: dmsetup create $_dmc_name";
		dmsetup -v status $_dmc_name;
		echo "------------------------------------------------------------------";
	fi

## after creating device-mapped device 'dmc0', then
## you can format it with mkfs.ext4 and mount it.

	echo "";
	echo "#>> mkfs.ext4 /dev/mapper/$_dmc_name";
	mkfs.ext4 /dev/mapper/$_dmc_name;

	echo "";
	echo "#>> mount /dev/mapper/$_dmc_name /mnt/sdc1";
	mount /dev/mapper/$_dmc_name /mnt/sdc1;

	echo "------------------------------------------------------------------";

## but still have a question - no need to fdisk?
## even the following command 'fdisk /dev/mapper/dmc0' seems work well,
## and fdisk shows me '/dev/mapper/dmc0p1' partition created.
## but I cannot find '/dev/mapper/dmc0p1' so
## it is impossible to do 'mkfs.ext4 /dev/mapper/dmc0p1'.

}




trial_05_dmc_clean()	# it works!
{
dmsetup -v status;
sleep 1;
umount /dev/mapper/dmc0;
dmsetup remove dmc0;
sleep 1;
dmsetup -v status;
}




trial_05_dmc_clean;
#trial_05_dmc_make;




exit 0;




# foo@bar$ sudo fdisk -l /dev/sdc
# 
# Disk /dev/sdc: 2000.4 GB, 2000398934016 bytes
# 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
# Units = sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 4096 bytes
# I/O size (minimum/optimal): 4096 bytes / 4096 bytes
# Disk identifier: 0x4ff22821
# 
# Device Boot      Start         End      Blocks(KB)   Id  System
# /dev/sdc1            2048     2099199     1048576   83  Linux		# 1GB		2,097,152 blocks
# /dev/sdc2         2099200    23070719    10485760   83  Linux		# 10GB		20,971,520 blocks
# /dev/sdc3        23070720  3907029167  1941979224   83  Linux		# 1988GB	3,883,958,448 blocks




# device	# of 512B blocks
# /dev/sdb1	2048
# /dev/sdb2	204800
# /dev/sdb3	2097152
# /dev/sdb5	20971520
# /dev/sdb6	226788016




# foo@bar$ sudo fdisk -l /dev/sdb
# 
# Disk /dev/sdb: 128.0 GB, 128035676160 bytes
# 255 heads, 63 sectors/track, 15566 cylinders, total 250069680 sectors
# Units = sectors of 1 * 512 = 512 bytes
# Sector size (logical/physical): 512 bytes / 512 bytes
# I/O size (minimum/optimal): 512 bytes / 512 bytes
# Disk identifier: 0x4ff22821
# 
# Device Boot      Start         End      Blocks(KB)   Id  System
# /dev/sdb1            2048        4095        1024   83  Linux
# /dev/sdb2            4096      208895      102400   83  Linux
# /dev/sdb3          208896     2306047     1048576   83  Linux
# /dev/sdb4         2306048   250069679   123881816    5  Extended
# /dev/sdb5         2308096    23279615    10485760   83  Linux
# /dev/sdb6        23281664   250069679   113394008   83  Linux
