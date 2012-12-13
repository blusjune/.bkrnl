#!/bin/sh

##.bdx.0100.y.build.sh
##_ver=20121213_131600

_srcs="te.c";
_tmpdir="/tmp";
_outfile="te.exec";
_datafile="myfile";
_catchme_cmd="catchme.sh";

echo "#>> please place a data file '$_datafile' to the '$_tmpdir' directory";
read -p "#?? need to escape to the shell? [y|n] " _ans;
if [ "X$_ans" = "Xy" ]; then
	bash;
fi




if [ -f $_tmpdir/$_outfile ]; then
	echo "#>> rm $_tmpdir/$_outfile";
	rm $_tmpdir/$_outfile;
fi




if [ ! -f $_tmpdir/$_catchme_cmd ]; then
	cat > $_tmpdir/$_catchme_cmd << EOF
echo "----------------------------------------------------";
echo "CATCHME: (\$0) [PID: \$\$]";
echo "----------------------------------------------------";
./_FTcmd.restart.sh;
exec $_tmpdir/$_outfile;
./_FTcmd.flush_and_turnoff.sh;
EOF
	echo "#>> $_tmpdir/$_catchme_cmd created";
fi
if [ ! -f _$_catchme_cmd ]; then
	ln -s $_tmpdir/$_catchme_cmd _$_catchme_cmd;
fi




echo "#>> gcc -static -o $_tmpdir/$_outfile $_srcs";
gcc -static -o $_tmpdir/$_outfile $_srcs;




if [ ! -f "_$_outfile" ]; then
	echo "#>> ln -s $_tmpdir/$_outfile _$_outfile";
	ln -s $_tmpdir/$_outfile _$_outfile;
fi

echo "#>> build completed";
