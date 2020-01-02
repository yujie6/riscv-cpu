# RiscV-CPU Hollow
This project is about writing a CPU from scratch with *RISC-V ISA* (rv32ia). It's written 
by **verilog** hardware design language.
It has features as follows:

* It has five stages pipiline with meomory controller and stall controller.
* It has 512 bytes instruction cache, which can contain 128 instructions. 
* It can be simulated correctly for the instructions in rv32i, except ECALL, EBREAK, CSRRW, CSRRS, CSRRC, CSRRWI, CSRRSI, CSRRCI.

* It can generate a CPU on FPGA, simulate a memory on PC, and connect two of them by using uart.
And could pass all the tests given on board with a frequency of 150M Hz.

## 1. Prerequisite
### 1.1 Install RISC-V toolchain
Before we start, it's necessary to install RISC-V toolchain (cross compiler).

Here is a brief introduction about how to install RiscV toolchain 
for linux or WSL on Windows in 2019.
Before installation, make sure you have at least *8GB free space*. First clone the official repository: 
```
git clone https://github.com/riscv/riscv-gnu-toolchain.git && cd riscv-gnu-toolchain
```
This might take some time. It is suggested to add proxy for your git:  
```
git config --global http.proxy 'socks5://127.0.0.1:1080'
```
Now we can start compile the toolchain
```
./configure --prefix=/opt/riscv --with-arch=rv32ia --with-abi=ilp32 
sudo make all 
```
**Remark**: Here `--with-arch=rv32ia` means we only use the ISA with 32-bit address space, 32 registers and atomic instruction (That's what A-extension means). Using `--with-arch=rv32i` will leads to build error. 

You may wait for about an hour. After that add the following to your `$HOME/.bashrc` or `$HOME/.zshrc` if you are using zsh.
```
export PATH=$PATH:/opt/riscv/bin
```
check if your toolchain works by  
```
riscv32-unknown-elf-gcc -v
```
### 1.2 Build Test Binaries
Here you can use the shell script I wrote.
In the root directory, run script

    ./build.sh all
    ./build.sh testname

to build all test cases or only one testcase.

This will compile 'testcase/testname.c' and output some intermediate files to directory 'testdata/'. And the `.data` file is exactly what we need.

### 1.3 Simulations and Tests
* Using Vivado: Just move the `.data`  file to the src directory and run simulation. 
* Using Iverilog: Iverilog is a light weight and open source simulator, which is easy to install with `apt` and fast to simulate. Here I wrote a script `sim.sh` to help me test my CPU, just type 
```bash
cd src
./sim.sh testname
``` 
## 2. The Architecture
### 2.1 Five Stages
The five stages are the same with the classic five stage architecture. And one thing need to 
be dealt with is control hazard, I use a stall controller to schedule all the stuffs here
```verilog
always @(*) begin
        if (rst == `RstEnable) begin
            stall <= 7'b0000000;
        end else if (stallreq_mem == `Stop) begin 
            stall <= 7'b1001111; // [5:0]
        end else if (stallreq_branch == `Stop) begin
            stall <= 7'b0100010; // cancel previous inst
        end 
        else if (stallreq_id == `Stop) begin
            stall <= 7'b0000111;
        end else if (stallreq_if == `Stop) begin
            stall <= 7'b0000001;    
        end else begin
            stall <= 7'b0000000;     
        end
    end
```

### 2.2 Memory Access
Due to the poor API of ram.v, we can only fetch 1 byte of data from memory per cycle. Thus 
it's necessary to fetch one instruction with 4 stages. Moreover, to deal with conflict between
IF memory access and MEM stage memory access, we have to use a memory controller to 
schedule all the accesses as well as communicating with stall controller. 
The core of my memory controller is:
```verilog
if (mem_mem_req_i) begin
    if_stall_req_o  <= 1'b0;
    mem_stall_req_o <= 1'b1;
    write_enable_o  <= mem_write_enable_i;
    mem_addr_o      <= mem_mem_addr_i;
    mem_data_o      <= mem_data_i;
    mem_write       <= mem_write_byte;
    end else if (if_mem_req_i) begin
    if_stall_req_o  <= 1'b1;
    mem_stall_req_o <= 1'b0;
    write_enable_o  <= 1'b0;
    mem_data_o      <= mem_data_i;
    mem_addr_o      <= if_mem_addr_i;
    end else begin
    if_stall_req_o  <= 1'b0;
    mem_stall_req_o <= 1'b0;
end
```


### 2.3 Instruction Cache
The instructino cache can boost the speed of 
instruction fetch a lot. And the implementation is simple and naive, the core of
my instruction cache is the following lines:
```verilog
if (!(read_index_i ^ write_index_i) && we_i) begin // read_index_i == write_index_i
                hit_o  <= 1'b1;
                inst_o <= write_inst_i;
                end else if (!(read_tag_i ^ rtag_c) && rvalid) begin
                hit_o  <= 1'b1;
                inst_o <= rinst_c;
                end else begin
                hit_o  <= 1'b0;
                inst_o <= `ZeroWord;
end
```

## 3. On Board Implementation
Before having implementation, make sure there is no critical warning. For exmaple, check if one reg
variable has been edited in two different @always loop.

After that, we can generate bit stream and test on board!
Before testing, make sure serial is installed:
```bash
sudo apt install catkin
cd serial && make install
```
Now
```bash
./run_test_fpga.sh testname
```
## References
[1] 手把手教你设计CPU--RISC-V处理器篇,胡振波,人民邮电出版社,2018

[2] 自己动手写CPU,雷思磊,电子工业出版社,2014