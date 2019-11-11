`include "defines.v"
// memory access for instructions

module IF(input wire clk,
          input wire rst,
          input wire [5:0] stall,
          input wire [`MemAddrBus] branch_addr_i,
          input wire branch_flag_i,
          input wire [`MemDataBus] mem_byte_i,
          output reg[`InstAddrBus] pc,
          output reg[`MemAddrBus] mem_addr_o,
          output reg[`InstBus] inst_o,
          output reg mem_we_o,
          output reg if_mem_req_o,
          output reg ce);
    
    reg [3:0] stage;
    reg [`MemDataBus] inst_block1;
    reg [`MemDataBus] inst_block2;
    reg [`MemDataBus] inst_block3;
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
            end else begin
            ce <= `ChipEnable;
        end
    end
    
    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc           <= `ZeroWord;
            if_mem_req_o <= 1'b0;
            stage        <= 4'b0000;
            end else if (branch_flag_i == 1'b1) begin
            pc    <= branch_addr_i;
            stage <= 4'b0000;
            end else if (stall[0] == `NoStop && if_mem_req_o == 1'b0 &&
            inst_o != `ZeroWord) begin
            pc           <= pc + 4'h4;
            stage        <= 4'b0000;
            if_mem_req_o <= 1'b1;
        end
    end
    
    
    
    always @(posedge clk) begin
        // TODO: Concatenate 4 bytes to a word make it inst
        if (ce == `ChipDisable) begin
            mem_addr_o <= `ZeroWord;
            end else begin
            mem_we_o <= 1'b0;
            if (if_mem_req_o == 1'b1 || pc == `ZeroWord) begin
                case (stage)
                    4'b0000: begin
                        mem_addr_o   <= pc;
                        stage        <= 4'b0001;
                        if_mem_req_o <= 1'b1;
                        //$display("yes, send byte_addr_1");
                    end
                    4'b0001: begin
                        mem_addr_o   <= pc + 8;
                        stage        <= 4'b0010;
                        if_mem_req_o <= 1'b1;
                        //$display("yes, send byte_addr_2");
                    end
                    4'b0010: begin
                        mem_addr_o   <= pc + 16;
                        stage        <= 4'b0011;
                        inst_block1  <= mem_byte_i;
                        if_mem_req_o <= 1'b1;
                        //$display("yes, send byte_addr_3");
                    end
                    4'b0011: begin
                        mem_addr_o   <= pc + 24;
                        stage        <= 4'b0100;
                        inst_block2  <= mem_byte_i;
                        if_mem_req_o <= 1'b1;
                        //$display("yes, send byte_addr_4");
                    end
                    4'b0100: begin
                        stage        <= 4'b0101;
                        inst_block3  <= mem_byte_i;
                        if_mem_req_o <= 1'b1;
                    end
                    4'b0101: begin
                        stage        <= 4'b0000;
                        inst_o       <= {mem_byte_i, inst_block3, inst_block2, inst_block1};
                        if_mem_req_o <= 1'b0;
                        //$display("Inst fetch success!!");
                    end
                    default: ;
                endcase
                end else begin
                
            end
        end
    end
    
endmodule // pc_reg
