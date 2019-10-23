`include "./defines.v"

module mem_wb(
    input wire clk,
    input wire rst,

    input wire [`RegAddrBus] mem_rd,
    input wire [`RegBus] mem_wdata,
    input wire mem_wreg,

    output reg [`RegAddrBus] wb_rd,
    output reg [`RegBus] wb_wdata,
    output wire wb_wreg
);
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            wb_rd <= `NOPRegAddr;
            wb_wdata <= `ZeroWord;
            wb_wreg <= `WriteDisable;
        end else begin
            wb_rd <= mem_rd;
            wb_wdata <= mem_wdata;
            wb_wreg <= mem_wreg;
        end

    end


endmodule: mem_wb