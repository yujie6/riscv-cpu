`include "./defines.v"
// FIXME: NEED MORE PORTS HERE
module mem(input wire rst,
           input wire [`RegAddrBus] rd_i,
           input wire [`RegBus] wdata_i,
           input wire wreg_i,
           output reg [`RegAddrBus] rd_o,
           output reg [`RegBus] wdata_o,
           output reg wreg_o);
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_o    <= `NOPRegAddr;
            wdata_o <= `ZeroWord;
            wreg_o  <= `WriteDisable;
            end else begin
            rd_o    <= rd_i;
            wdata_o <= wdata_i;
            wreg_o  <= wreg_i;
        end
    end
    
endmodule
