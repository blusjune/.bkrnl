#!/bin/sh


_tstamp=$(tstamp);
_bufsz=100000;
_attic=".archive";


if [ ! -d $_attic ]; then
	mkdir -p $_attic;
fi


echo 1 > tracing/buffer_size_kb;
echo 0 > tracing/tracing_on;
cat tracing/set_ftrace_filter > $_attic/set_ftrace_filter.$_tstamp;

cat cfg.set_ftrace_filter | grep -v '#' > tracing/set_ftrace_filter;

echo $_bufsz > tracing/buffer_size_kb;
echo 1 > tracing/tracing_on;
