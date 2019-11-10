// RISCV32I CPU top module
// port modification allowed for debugging purposes
`include "defines.v"
module cpu(input wire clk_in,
           input wire rst_in,
           input wire rdy_in,
           input wire [7:0] mem_din,
           output wire [7:0] mem_dout,
           output wire [31:0] mem_addr,
           output wire mem_wr,
           output wire rom_ce_o,
           output wire [31:0] dbgreg_dout);
    // REVIEW: RAM read and write 1 byte per cycle
    // REVIEW: Thus we need to wait 3 cycles when there is a word write | read
    
    
    // implementation goes here
    // Specifications:
    // - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
    // - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
    // - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
    // - I/O port is mapped to address higher than 0x30000 (mem_a[17:16] == 2'b11)
    // - 0x30000 read: read a byte from input
    // - 0x30000 write: write a byte to output (write 0x00 is ignored)
    // - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
    // - 0x30004 write: indicates program stop (will output '\0' through uart tx)
    
    // MemController
    wire if_mem_req;
    wire mem_mem_req;
    
    
    wire [`InstBus] first_inst = {{12{1'b1}},{5'b00010},{3'b110},{5'b00100},{7'b0010011}};
    wire [`InstAddrBus] pc;
    wire [`InstAddrBus] id_pc_i;
    wire [`InstBus] if_inst_o;
    wire [`MemAddrBus] if_mem_addr;
    wire if_write_enable;
    wire [`InstBus] id_inst_i;
    //assign id_inst_i = {first_inst};
    //assign mem_din   = first_inst;
    wire [`AluOpBus] id_aluop_o;
    wire [`AluSelBus] id_alusel_o;
    wire [`RegBus] id_reg1_o;
    wire [`RegBus] id_reg2_o;
    wire [`RegBus] id_imm_o;
    wire [`RegAddrBus] id_shamt_o;
    wire id_wreg_o;
    wire [`RegAddrBus] id_wd_o;
    wire [`MemAddrBus] id_branch_target_addr_o;
    wire id_branch_flag_o;
    wire [`MemAddrBus] id_link_addr_o;
    
    wire [`AluOpBus] ex_aluop_i;
    wire [`MemAddrBus] ex_link_addr_i;
    wire [`AluSelBus] ex_alusel_i;
    wire [`RegBus] ex_reg1_i;
    wire [`RegBus] ex_reg2_i;
    wire [`RegAddrBus] ex_shamt_i;
    wire [`RegBus] ex_imm_i;
    wire ex_wreg_i;
    wire [`RegAddrBus] ex_wd_i;
    
    wire ex_wreg_o;
    wire [`RegAddrBus] ex_wd_o;
    wire [`RegBus] ex_wdata_o;
    wire [`AluOpBus] ex_aluop_o;
    wire [`RegBus] ex_reg2_o;
    wire [`MemAddrBus] ex_memaddr_o;
    
    wire mem_wreg_i;
    wire [`RegAddrBus] mem_wd_i;
    wire [`RegBus] mem_wdata_i;
    wire [`AluOpBus] mem_aluop_i;
    wire [`RegBus] mem_reg2_i;
    wire [`MemAddrBus] mem_addr_i;
    
    wire mem_wreg_o;
    wire [`RegAddrBus] mem_wd_o;
    wire [`RegBus] mem_wdata_o;
    wire [`MemSelBus] mem_sel_o;
    wire [`MemAddrBus] mem_mem_addr_o;
    wire [`RegBus] mem_data_o;
    
    wire wb_wreg_i;
    wire [`RegAddrBus] wb_wd_i;
    wire [`RegBus] wb_wdata_i;
    
    // regfile
    wire reg1_read;
    wire reg2_read;
    wire [`RegBus] reg1_data;
    wire [`RegBus] reg2_data;
    wire [`RegAddrBus] reg1_addr;
    wire [`RegAddrBus] reg2_addr;

    // stall controller 
    wire [5:0] stall_sign;
    wire stallreq_mem;
    wire stallreq_ex;
    wire stallreq_if;
    
    // Instruction cache
    wire                    inst_cache_we;
    wire[`InstAddrBus]      inst_cache_wpc;
    wire[`InstBus]          inst_cache_winst;
    wire[`InstAddrBus]      inst_cache_rpc;
    wire                    inst_cache_hit;
    wire[`InstBus]          inst_cache_inst;
    
    
    always @(posedge clk_in)
    begin
        if (rst_in)
        begin
            
        end
        else if (!rdy_in)
        begin
            
        end
        else
        begin
            
        end
    end
    
    MemController MemControl0(
            .if_mem_req_i(if_mem_req),
            .mem_mem_req_i(mem_mem_req),
            .mem_write_enable_i(mem_we_o),
            .if_mem_addr_i(if_mem_addr),
            .mem_mem_addr_i(mem_mem_addr_o),
            .mem_data_i(mem_dout),
            .write_enable_o(mem_wr),
            .mem_addr_o(mem_addr),
            .mem_data_o(mem_din),
            .if_stall_req_o(stallreq_if),
            .mem_stall_req_o(stallreq_mem)
    );
    
    StallController StallController0(
    .rst(rst_in),
    .stall(stall_sign),
    .stallreq_mem(stallreq_mem),
    .stallreq_ex(stallreq_ex),
    .stallreq_id(stallreq_id),
    .stallreq_if(stallreq_if)
    );
    
    IF if0(
    .clk(clk_in), .rst(rst_in),
    .pc(pc), .ce(rom_ce_o),
    .mem_addr_o(if_mem_addr),
    .mem_we_o(if_write_enable),
    .mem_byte_i(mem_dout),
    .stall(stall_sign),
    .inst_o(if_inst_o),
    .if_mem_req_o(if_mem_req),
    .branch_flag_i(id_branch_flag_o),
    .branch_addr_i(id_branch_target_addr_o)
    );
    
    
    
    if_id if_id0(
    .clk(clk_in), .rst(rst_in), .if_pc(pc),
    .stall(stall_sign),
    .if_inst(first_inst), // supposed to be mem_din (but it's only 1 byte)
    .id_pc(id_pc_i),
    .id_inst(id_inst_i)
    );
    
    id id0(
    .rst(rst_in), .pc_i(id_pc_i), .inst_i(id_inst_i),
    // input from regfile
    .reg1_data_i(reg1_data), .reg2_data_i(reg2_data),
    // data send to regfile
    .reg1_read_o(reg1_read), .reg2_read_o(reg2_read),
    .reg1_addr_o(reg1_addr), .reg2_addr_o(reg2_addr),
    .branch_target_addr_o(id_branch_target_addr_o),
    .branch_flag_o(id_branch_flag_o),
    // data send to ed_ex
    .aluop_o(id_aluop_o), .alusel_o(id_alusel_o),
    .reg1_o(id_reg1_o), .reg2_o(id_reg2_o),
    .rd_o(id_wd_o), .wreg_o(id_wreg_o),
    .imm_o(id_imm_o), .shamt_o(id_shamt_o),
    // data forwarding from ex
    .ex_wd_forward(ex_wd_o), .ex_wdata_forward(ex_wdata_o),
    .ex_wreg_forward(ex_wreg_o),
    // data forwarding from mem
    .mem_wd_forward(mem_wd_o), .mem_wdata_forward(mem_wdata_o),
    .mem_wreg_forward(mem_wreg_o)
    );
    
    regfile regfile0(
    .clk(clk_in), .rst(rst_in),
    .we(wb_wreg_i), .waddr(wb_wd_i),
    .wdata(wb_wdata_i), .re1(reg1_read),
    .raddr1(reg1_addr), .rdata1(reg1_data),
    .re2(reg2_read), .raddr2(reg2_addr),
    .rdata2(reg2_data)
    );
    
    id_ex id_ex0(
    .rst(rst_in), .clk(clk_in),
    // data from id
    .id_reg1(id_reg1_o), .id_reg2(id_reg2_o),
    .id_wd(id_wd_o), .id_wreg(id_wreg_o),
    .id_alusel(id_alusel_o), .id_aluop(id_aluop_o),
    .id_imm(id_imm_o), .id_shamt(id_shamt_o),
    .id_link_addr(id_link_addr_o),
    .stall(stall_sign),
    // data send to ex
    .ex_reg1(ex_reg1_i), .ex_reg2(ex_reg2_i),
    .ex_wd(ex_wd_i), .ex_wreg(ex_wreg_i),
    .ex_aluop(ex_aluop_i), .ex_alusel(ex_alusel_i),
    .ex_imm(ex_imm_i), .ex_shamt(ex_shamt_i),
    .ex_link_addr(ex_link_addr_i)
    );
    
    ex ex0(
    // input from id_ex
    .rst(rst_in), .reg1_i(ex_reg1_i),
    .reg2_i(ex_reg2_i), .rd_i(ex_wd_i),
    .aluop_i(ex_aluop_i), .alusel_i(ex_alusel_i),
    .wreg_i(ex_wreg_i), .imm_i(ex_imm_i),
    .shamt_i(ex_shamt_i),
    .link_addr_i(ex_link_addr_i),
    // output to ex_mem
    .rd_o(ex_wd_o), .wdata_o(ex_wdata_o),
    .wreg_o(ex_wreg_o), .mem_addr_o(ex_memaddr_o)
    );
    
    ex_mem ex_mem0(
    .rst(rst_in), .clk(clk_in),
    // input from ex
    .ex_wreg(ex_wreg_o), .ex_wdata(ex_wdata_o),
    .ex_rd(ex_wd_o),
    .ex_memaddr(ex_memaddr_o),
    .stall(stall_sign),
    // output to mem
    .mem_wdata(mem_wdata_i), .mem_wreg(mem_wreg_i),
    .mem_rd(mem_wd_i), .mem_addr(mem_addr_i),
    .mem_aluop(mem_aluop_i)
    );
    // FIXME: PORTS CHECKING (NUMBER AND NAMES)
    mem mem0(
    // input from ex_mem
    .rst(rst_in), .wreg_i(mem_wreg_i),
    .wdata_i(mem_wdata_i), .rd_i(mem_wd_i),
    .aluop_i(mem_aluop_i),
    .mem_addr_i(mem_addr_i),
    .mem_sel_o(mem_sel_o),
    .mem_wdata_o(mem_wdata_o),
    .mem_addr_o(mem_mem_addr_o),
    .mem_we_o(mem_we_o),
    .mem_ce_o(rom_ce_o),
    .mem_data_i(mem_data_o),
    // output to mem_wb
    .wreg_o(mem_wreg_o), .wdata_o(mem_wdata_o),
    .rd_o(mem_wd_o)
    );
    
    mem_wb mem_wb0(
    // input from mem
    .rst(rst_in), .clk(clk_in),
    .mem_rd(mem_wd_o), .mem_wreg(mem_wreg_o),
    .mem_wdata(mem_wdata_o),
    .stall(stall_sign),
    // output to wb (regfile)
    .wb_wreg(wb_wreg_i), .wb_wdata(wb_wdata_i),
    .wb_rd(wb_wd_i)
    );
    
    
endmodule
