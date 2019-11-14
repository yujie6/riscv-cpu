`include "./defines.v"

module ex_mem(
    input wire clk,
    input wire rst,

    input wire [`RegAddrBus] ex_rd,
    input wire ex_wreg,
    input wire [`AluOpBus] ex_aluop,
    input wire [`RegBus] ex_reg2,
    input wire [`RegBus] ex_wdata,
    input wire [`MemAddrBus] ex_memaddr,
    input wire [`InstAddrBus] ex_pc,
    input wire [5:0] stall,
    output reg[`RegAddrBus] mem_rd,
    output reg[`RegBus] mem_wdata,
    output reg[`MemAddrBus] mem_addr,
    output reg mem_wreg,
    output reg [`InstAddrBus] mem_pc,
    output wire [`RegBus] mem_reg2,
    output wire [`AluOpBus] mem_aluop
);
    assign mem_reg2 = ex_reg2;
    assign mem_aluop = ex_aluop;

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            mem_rd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;
            mem_addr <= `ZeroWord;
            mem_pc <= `ZeroWord;
        end else if (stall[2] == `Stop && stall[3] == `NoStop) begin
            mem_rd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;
            mem_addr <= `ZeroWord;
            mem_pc <= `ZeroWord;
        end 
        
        else if (stall[2] == `NoStop) begin
            mem_rd <= ex_rd;
            mem_wdata <= ex_wdata;
            mem_wreg <= ex_wreg;
            mem_addr <= ex_memaddr;
            mem_pc <= ex_pc;
        end
    end

endmodule