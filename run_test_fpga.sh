#!/bin/sh
# build testcase
# copy test input
if [ ! -d tmp ] 
then
		mkdir tmp
fi

if [ -f ./testcase/$@.in ] 
then 
		cp ./testcase/$@.in ./tmp/$@.in 
else 
		echo "This test DO NOT need input file."
fi
# copy test output
if [ -f ./testcase/$@.ans ]; then cp ./testcase/$@.ans ./tmp/$@.ans; fi

# add your own test script here
# Example: assuming serial port on /dev/ttyUSB1

./ctrl/build.sh
./ctrl/run.sh ./testdata/bin/$@.bin ./tmp/$@.in /dev/ttyUSB1 -I

#./ctrl/run.sh ./test/test.bin ./test/test.in /dev/ttyUSB1 -T > ./test/test.out
#if [ -f ./test/test.ans ]; then diff ./test/test.ans ./test/test.out; fi
