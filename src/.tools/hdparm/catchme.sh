#!/bin/sh



echo "#>> You should be root!";
echo "#>> Please prepare some file on the SSD to be TRIMed";
echo "#>> Escape to shell...";
bash;

read -p "#?? target file: " _target_file;
if [ "X$_target_file" != "X" ]; then
	if [ ! -f $_target_file ]; then
		echo "#>> target file cannot open properly";
		exit 0;
	fi
else
	echo "#>> target file should be specified - EXIT";
	exit 0;
fi

_blk_dev="$(df -k $_target_file | tail -1 | awk '{print $1}' | sed -e 's/\([^0-9]*\)[0-9]*/\1/g')";
_sector_info="$(sudo hdparm --fibmap $_target_file | tail -1)"; 
_start_sect="$(echo $_sector_info | awk '{ print $2 }')";
_size_in_sect="$(echo $_sector_info | awk '{ print $4 }')";

echo "#>> '$_target_file' ($_start_sect:$_size_in_sect)";
read -p "#>> number of sectors to TRIM (from start offset): " _num_of_sect_to_trim;

echo "PID: $$";
read -p "ready to go? [y|n]" _ans;
if [ "X$_ans" != "Xy" ]; then
	echo "exit!!!";
	exit 0;
fi

exec hdparm --please-destroy-my-drive --trim-sector-ranges $_start_sect:$_num_of_sect_to_trim $_blk_dev;

#exec hdparm --fibmap 8xhosts;
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154368:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154368:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154372:4 /dev/sdb
#exec hdparm --please-destroy-my-drive --trim-sector-ranges 84154376:4 /dev/sdb



