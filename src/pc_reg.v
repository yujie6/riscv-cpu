`include "defines.v"
// pc modifications are all here
module pc_reg(input wire clk,
              input wire rst,
              input wire branch_flag_i,
              input wire [`MemAddrBus] branch_addr_i,
              output reg[`InstAddrBus] pc,
              output reg ce
              );
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
            end else begin
            ce <= `ChipEnable;
        end
    end
    
    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc <= `ZeroWord;
            end else if (branch_flag_i == 1'b1) begin
                pc <= branch_addr_i;        
            end else begin
            pc <= pc + 4'h4;
        end
    end
    
endmodule // pc_reg
