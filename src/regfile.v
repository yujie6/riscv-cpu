`include "./defines.v"

module regfile(
    input wire clk,
    input wire rst,
    // wirte port 
    input wire we,  // write or not
    input wire[`RegAddrBus] waddr,
    input wire[`RegBus] wdata,
    // read port 1
    input wire re1,  // write or not
    input wire[`RegAddrBus] raddr1,
    output reg[`RegBus] rdata1,
    // read port 2
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
always @(posedge clk) begin
    if (rst == `RstDisable) begin
        if ((re1 == `ReadEnable) && (raddr1 != `RegNumLog2'h0))
        begin
            rdata1 <= regs[raddr1];
        end
    end
end

always @(posedge clk) begin
    if (rst == `RstDisable) begin
        if ((re2 == `ReadEnable) && (raddr2 != `RegNumLog2'h0))
        begin
            rdata2 <= regs[raddr2];
        end
    end
end

endmodule // regfile