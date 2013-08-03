#!/bin/sh
#.bdx.0100.y.process_gpgized_files.sh
#_ver="20130803_101736";




echo "#>> update gighub source tree (add-commit-push)";

rm -f .tstamp.*;
touch .tstamp.$(tstamp);

git add -A
#git add .tstamp.*
git commit -a
read -p "#<< Go ahead? [Y|n] " _ans;
if [ "X$_ans" = "Xn" ]; then
	echo "#>> Exit without pushing";
	exit 0;
fi
git push --all -u




