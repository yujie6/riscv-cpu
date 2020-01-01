dir=`dirname $0`
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib
echo "LD PATH is $LD_LIBRARY_PATH"
$dir/ctrl $@
