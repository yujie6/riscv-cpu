`include "./defines.v"

module mem(
    input wire rst,
    input wire [`RegAddrBus] rd_i,
    input wire [`RegBus] wdata_i,
    input wire wreg_i,

    output wire [`RegAddrBus] rd_o,
    output wire [`RegBus] wdata_o,
    output wire wreg_o
);
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_o <= `NOPRegAddr;
            wdata_o <= `ZeroWord;
            wreg_o <= `WriteDisable;
        end else begin
            rd_o <= rd_i;
            wdata_o <= wdata_i;
            wreg_o <= wreg_i;
        end
    end

endmodule: mem