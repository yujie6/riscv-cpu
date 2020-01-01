`include "./defines.v"

module id_ex(input wire clk,
             input wire rst,
             input wire [`AluOpBus] id_aluop,
             input wire [`AluSelBus] id_alusel,
             input wire [`RegBus] id_reg1,
             input wire [`RegBus] id_reg2,
             input wire [`RegBus] id_imm,
             input wire [`RegAddrBus] id_shamt,
             input wire [`RegAddrBus] id_wd,
             input wire [`InstAddrBus] id_pc,  
             input wire [`MemAddrBus] id_link_addr,
             input wire id_wreg,
             input wire [6:0] stall,
             input wire id_load_sign,
             input wire id_mem_we,
             input wire [`MemSelBus] id_mem_sel,
             output reg [`AluOpBus] ex_aluop,
             output reg [`AluSelBus] ex_alusel,
             output reg [`RegBus] ex_reg1,
             output reg [`RegBus] ex_reg2,
             output reg [`InstAddrBus] ex_pc,
             output reg [`RegAddrBus] ex_shamt,
             output reg [`RegBus] ex_imm,
             output reg [`RegAddrBus] ex_wd,
             output reg [`MemAddrBus] ex_link_addr,
             output reg ex_load_sign,
             output reg ex_mem_we,
             output reg [`MemSelBus] ex_mem_sel,
             output reg ex_wreg);
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            ex_aluop  <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1   <= `ZeroWord;
            ex_reg2   <= `ZeroWord;
            ex_pc <= `ZeroWord;
            ex_imm    <= `ZeroWord;
            ex_shamt  <= 5'b00000;
            ex_wd     <= `NOPRegAddr;
            ex_wreg   <= `WriteDisable;
            ex_link_addr <= {32{1'b0}};
            ex_mem_sel <= `MEM_NOP;
            ex_mem_we <= 1'b0;
            end else if ((stall[1] == `Stop && stall[2] == `NoStop) || stall[5]) begin
            ex_aluop  <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1   <= `ZeroWord;
            ex_reg2   <= `ZeroWord;
            ex_pc <= `ZeroWord;
            ex_imm    <= `ZeroWord;
            ex_shamt  <= 5'b00000;
            ex_wd     <= `NOPRegAddr;
            ex_wreg   <= `WriteDisable;
            ex_link_addr <= {32{1'b0}};
            ex_mem_sel <= `MEM_NOP;
            end else if (stall[1] == `NoStop) begin
            ex_aluop  <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1   <= id_reg1;
            ex_reg2   <= id_reg2;
            ex_shamt  <= id_shamt;
            ex_imm    <= id_imm;
            ex_wd     <= id_wd;
            ex_pc <= id_pc;
            ex_wreg   <= id_wreg;
            ex_link_addr <= id_link_addr;
            ex_mem_sel <= id_mem_sel;
            ex_mem_we <= id_mem_we;
            ex_load_sign <= id_load_sign;
        end
    end
    
    
endmodule // id_ex
