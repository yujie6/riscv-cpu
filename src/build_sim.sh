#!/bin/bash
iverilog -o sim ../sim/testbench.v ./*.v ./common/block_ram/block_ram.v ./common/fifo/fifo.v ./common/uart/*.v
