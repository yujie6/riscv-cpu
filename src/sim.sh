#!/bin/bash
Green='\e[0;32m'        # Green
BGreen='\e[1;32m'       # Green
NC='\e[m'
if [[ $1 == "" ]]
then 
    echo "Random test"
    if [ ! -f test.mem ]; then mv ../testdata/data/expr.data ./test.mem; fi
else 
    echo "Test for $1"

    if [ -f test.mem ]; then rm test.mem; fi
    cp ../testdata/data/$1.data ./test.mem
fi

iverilog -o run_sim ../sim/testbench.v ./*.v ./common/block_ram/block_ram.v ./common/fifo/fifo.v ./common/uart/*.v
./run_sim