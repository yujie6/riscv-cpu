# RiscV-CPU Hollow
This project is about writing a CPU from scratch with *RISC-V ISA*. It's written 
by **verilog** hardware design language.

## 1. Prerequisite
### 1.1 Install RISC-V toolchain
Before we start, it's necessary to install RISC-V toolchain (cross compiler).

Here is a brief introduction about how to install RiscV toolchain 
for linux or WSL on Windows in 2019.
Before installation, make sure you have at least *8GB free space*. First clone the official repository: 
```
git clone https://github.com/riscv/riscv-gnu-toolchain.git && cd riscv-gnu-toolchain
```
This might take some time. It is suggested to add proxy for your git (If you don't have one, ask TA for help):  
```
git config --global http.proxy 'socks5://127.0.0.1:1080'
```
Now we can start compile the toolchain
```
./configure --prefix=/opt/riscv --with-arch=rv32ia --with-abi=ilp32 
sudo make all 
```
**Remark**: Here `--with-arch=rv32ia` means we only use the ISA with 32-bit address space, 32 registers and atomic instruction (That's what A-extension means). Using `--with-arch=rv32i` will leads to build error. And using `--with-arch=rv32gc` (This is suggested by the official repository, here `g` stands for general which means `i,m,a,f,d` extensions, `c` stands for support  16-bit instructions) will make our `build.sh` crashed.

You may wait for about an hour. After that add the 
toolchain to your PATH, that is add the following to your `$HOME/.bashrc` or `$HOME/.zshrc` if you are using zsh.
```
export PATH=$PATH:/opt/riscv/bin
```
check if your toolchain works by  
```
riscv32-unknown-elf-gcc -v
riscv32-unknown-linux-gnu-gcc -v 
```
### 1.2 Build Test Binaries
Here you can use the shell script I wrote.
In the root directory, run script

    bash build.sh all

to build all test cases. Or you can write your own test and just build one testcase by

    bash build.sh testname

This will compile 'testcase/testname.c' and output some intermediate files to directory 'testdata/'

Intermediate files:

- testdata/om/testname.om: compiled ELF file
- testdata/data/testname.data: RAM data that can be read by verilog
- testdata/bin/testname.bin: RAM data in binary
- testdata/dump/testname.dump: decompilation of the ELF file

### 1.3 Simulations and Tests
* Using Vivado: Just move the `.data`  file to the src directory and run simulation. 
* Using Iverilog: Iverilog is a light weight and open source simulator, which is easy to install with `apt` and fast to simulate. Here I wrote a script `sim.sh` to help me test my CPU, just type 
```bash
cd src
./sim.sh testname
``` 
## 2. The Architecture
### 2.1 Five Stage
The five stages are the same with the classic five stage architecture.
### 2.2 Stall Controller
### 2.3 Memory Controller
### 2.4 Instruction Cache

## 3. Go on Board 


## References
[1] 手把手教你设计CPU--RISC-V处理器篇,胡振波,人民邮电出版社,2018

[2] 自己动手写CPU,雷思磊,电子工业出版社,2014