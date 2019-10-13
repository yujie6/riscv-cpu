`include "./defines.v"

module ex_mem(
    input wire clk,
    input wire rst,

    input wire [`RegAddrBus] ex_rd,
    input wire ex_wreg,
    input wire [`RegBus] ex_wdata,
    output reg[`RegAddrBus] mem_rd,
    output reg[`RegBus] mem_wdata,
    output reg mem_wreg
);
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            mem_rd <= `NOPRegAddr;
            mem_wreg <= `WriteDisable;
            mem_wdata <= `ZeroWord;
        end else begin
            mem_rd <= ex_rd;
            mem_wdata <= ex_wdata;
            mem_wreg <= ex_wreg;
        end
    end

endmodule : ex_mem