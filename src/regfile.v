`include "defines.v"

module regfile(
    input wire clk,
    input wire rst,
    // wirte port 
    input wire we,  // write or not
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus] wdata,
    // read port 1 (for rs1)
    input wire re1,  // write or not
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus] rdata1,
    // read port 2 (for rs2)
    input wire re2,  // write or not
    input wire[`RegAddrBus] raddr2,
    output reg[`RegBus] rdata2
);

reg[`RegBus] regs[0:`RegNum-1];

// ----------- wirte operation -------------- 
always @(posedge clk) begin
    if (rst == `RstDisable) begin
        if ((we == `WriteEnable) && (waddr != `RegNumLog2'h0)) 
        begin
            regs[waddr] <= wdata;
        end
    end
end
// ------------ read operation ---------------
always @(*) begin
    if (rst == `RstEnable || raddr2 == `RegNumLog2'h0) begin
    // Knowing that register 0 is always ZEROWORD
        rdata1 <= `ZeroWord;
    end else if ((raddr1 == waddr) && (we == `WriteEnable) &&
                (re1 == `ReadEnable)) begin
        rdata1 <= wdata;
    end else if (re1 == `ReadEnable) begin
        rdata1 <= regs[raddr1];
    end else begin
        rdata1 <= `ZeroWord;
    end
end

always @(*) begin
    if (rst == `RstEnable || raddr2 == `RegNumLog2'h0) begin
        rdata2 <= `ZeroWord;
    end else if ((raddr2 == waddr) && (we == `WriteEnable) &&
                (re2 == `ReadEnable)) begin
        rdata2 <= wdata;
    end else if (re2 == `ReadEnable) begin
        rdata2 <= regs[raddr2];
    end else begin
        rdata2 <= `ZeroWord;
    end
end

endmodule // regfile