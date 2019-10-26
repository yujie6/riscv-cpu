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
             input wire [`MemAddrBus] id_link_addr,
             input wire id_wreg,
             output reg [`AluOpBus] ex_aluop,
             output reg [`AluSelBus] ex_alusel,
             output reg [`RegBus] ex_reg1,
             output reg [`RegBus] ex_reg2,
             output reg [`RegAddrBus] ex_shamt,
             output reg [`RegBus] ex_imm,
             output reg [`RegAddrBus] ex_wd,
             output reg [`MemAddrBus] ex_link_addr,
             output reg ex_wreg);
    always @ (posedge clk) begin
        if (rst == `RstEnable) begin
            ex_aluop  <= `EXE_NOP_OP;
            ex_alusel <= `EXE_RES_NOP;
            ex_reg1   <= `ZeroWord;
            ex_reg2   <= `ZeroWord;
            ex_imm    <= `ZeroWord;
            ex_shamt  <= 5'b00000;
            ex_wd     <= `NOPRegAddr;
            ex_wreg   <= `WriteDisable;
            ex_link_addr <= {17{1'b0}};
            end else begin
            ex_aluop  <= id_aluop;
            ex_alusel <= id_alusel;
            ex_reg1   <= id_reg1;
            ex_reg2   <= id_reg2;
            ex_shamt  <= id_shamt;
            ex_imm    <= id_imm;
            ex_wd     <= id_wd;
            ex_wreg   <= id_wreg;
            ex_link_addr <= id_link_addr;
        end
    end
    
    
endmodule // id_ex
