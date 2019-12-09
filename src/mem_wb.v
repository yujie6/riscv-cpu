`include "./defines.v"

module mem_wb(input wire clk,
              input wire rst,
              input wire [`InstAddrBus] wb_pc_i,
              input wire [`RegAddrBus] mem_rd,
              input wire [`RegBus] mem_wdata,
              input wire mem_wreg,
              input wire [6:0] stall,
              output reg [`RegAddrBus] wb_rd,
              output reg [`RegBus] wb_wdata,
              output reg wb_wreg);
    reg wb_done;
    reg inst_valid;
    reg [`InstAddrBus] OldPc; 

    // always @(wb_pc_i) begin
    //     wb_done = 1'b0;
    // end
    
    always @(*) begin
        if (mem_rd == `NOPRegAddr && mem_wdata == `ZeroWord) begin
            inst_valid <= 1'b0;
        end else begin
            inst_valid <= 1'b1; 
        end
    end

    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            wb_rd    <= `NOPRegAddr;
            wb_wdata <= `ZeroWord;
            wb_wreg  <= `WriteDisable;
            wb_done  <= 1'b0;
            OldPc <= wb_pc_i;
            end else begin
            if (wb_pc_i != OldPc) begin
                wb_done <= 1'b0;
                OldPc <= wb_pc_i;
            end
            if (stall[3] == `Stop && stall[4] == `NoStop) begin
            wb_rd    <= `NOPRegAddr;
            wb_wdata <= `ZeroWord;
            wb_wreg  <= `WriteDisable;
            end else if (stall[3] == `NoStop && !wb_done && inst_valid) begin
            wb_rd    <= mem_rd;
            wb_wdata <= mem_wdata;
            wb_wreg  <= mem_wreg;
            wb_done  <= 1'b1;
            end 
        end
        
    end
    
    
endmodule
