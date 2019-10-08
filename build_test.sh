#!/bin/sh
set -e
prefix='/opt/riscv'
rpath=$prefix/bin/
# clearing test dir
rm -rf ./test
mkdir ./test
tool1=riscv32-unknown-elf-
tool2=riscv32-unknown-linux-gnu-
tool=${tool1}
# compiling rom
${rpath}${tool}as -o ./sys/rom.o -march=rv32i ./sys/rom.s
# compiling testcase
cp ./testcase/${1%.*}.c ./test/test.c
${rpath}${tool}gcc -o ./test/test.o -I ./sys -c ./test/test.c -O2 -march=rv32i -mabi=ilp32 -Wall
# linking
${rpath}${tool}ld -T ./sys/memory.ld ./sys/rom.o ./test/test.o -L $prefix/riscv32-unknown-elf/lib/ -L $prefix/lib/gcc/riscv32-unknown-elf/9.2.0/ -lc -lm -lgcc -lnosys -o ./test/test.om
# converting to verilog format
${rpath}${tool}objcopy -O verilog ./test/test.om ./test/test.data
# converting to binary format(for ram uploading)
${rpath}${tool}objcopy -O binary ./test/test.om ./test/test.bin
# decompile (for debugging)
${rpath}${tool}objdump -D ./test/test.om > ./test/test.dump
