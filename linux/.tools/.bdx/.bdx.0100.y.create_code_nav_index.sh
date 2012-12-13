#!/bin/sh

##.bdx.0100.y.create_code_nav_index.sh
##_ver=20121213_151247


_tstamp=$(tstamp);
_srcdir="linux";
_prefix="linux-3.0.8-xpc_dmcache";
_index_file_ctags="${_prefix}.tags";
_index_file_cscope="${_prefix}.cscope_out";
_index_file_ctags_default="tags";
_index_file_cscope_default="cscope.out";


if [ -f $_index_file_ctags ]; then
	mv $_index_file_ctags old.${_index_file_ctags}.$_tstamp;
fi
ctags -f $_index_file_ctags -R $_srcdir;
if [ ! -f $_index_file_ctags_default ]; then
	ln -s $_index_file_ctags $_index_file_ctags_default;
fi


if [ -f $_index_file_cscope ]; then
	mv $_index_file_cscope old.${_index_file_cscope}.$_tstamp;
fi
cscope -f $_index_file_cscope -R -s $_srcdir;
if [ ! -f $_index_file_cscope_default ]; then
	ln -s $_index_file_cscope $_index_file_cscope_default;
fi


echo "#>> Done! successfully";


