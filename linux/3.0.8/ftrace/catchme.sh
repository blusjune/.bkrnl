echo "CATCHME: ($0) [PID: $$]";
echo "#>> list of available big files:";
ls -alF /x/bigfile/;
read -p "_dd_ifname: " _dd_ifname;
_dd_if="/x/bigfile/$_dd_ifname";
read -p "_dd_blksz: " _dd_blksz;
read -p "_dd_skip: " _dd_skip;
read -p "_dd_count: " _dd_count;


./_FTcmd.restart.sh;
exec dd if=$_dd_if bs=$_dd_blksz skip=$_dd_skip count=$_dd_count of=/dev/null;
./_FTcmd.flush_and_turnoff.sh;
