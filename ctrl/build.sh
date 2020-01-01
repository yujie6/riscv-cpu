set -e
dir=`dirname $0`
g++ $dir/controller.cpp -std=c++14 -I /usr/local/include/ -L /usr/local/lib -lserial -lpthread -o $dir/ctrl
