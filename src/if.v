`include "defines.v"
// memory access for instructions

module IF(input wire clk,
          input wire rst,
          input wire [6:0] stall,
          input wire [`MemAddrBus] branch_addr_i,
          input wire branch_flag_i,
          input wire [`InstAddrBus] cache_inst_i,
          input wire cache_hit_i,
          input wire [`MemDataBus] mem_byte_i,
          output reg[`InstAddrBus] pc,
          output reg[`InstAddrBus] cache_waddr_o,
          output reg cache_we_o,
          output reg[`InstBus] cache_winst_o,
          output reg[`InstAddrBus] cache_raddr_o,
          output reg[`MemAddrBus] mem_addr_o,
          output reg[`InstBus] inst_o,
          output reg mem_we_o,
          output reg if_mem_req_o,
          output reg branch_cancel_req_o,
          output reg ce);
    
    reg [3:0] stage;
    reg [`MemDataBus] inst_block1;
    reg [`MemDataBus] inst_block2;
    reg [`MemDataBus] inst_block3;
    
    reg first_fetch;
    
    always @(posedge clk) begin
        if (rst == `RstEnable) begin
            ce <= `ChipDisable;
            first_fetch = 1'b1;
            cache_waddr_o <= `ZeroWord;
            cache_we_o    <= 1'b0;
            cache_winst_o <= `ZeroWord;
            cache_raddr_o <= `ZeroWord;
            end else begin
            ce <= `ChipEnable;
        end
    end
    
    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            pc                  <= `ZeroWord;
            if_mem_req_o        <= 1'b0;
            branch_cancel_req_o <= 1'b0;
            stage               <= 4'b0000;
            // TODO: Consider Jumping later
            end else if (stall[0] == `NoStop && branch_flag_i == 1'b1) begin
            pc                  <= branch_addr_i;
            cache_raddr_o       <= branch_addr_i;
            cache_we_o <= 1'b0;
            stage               <= 4'b0000;
            branch_cancel_req_o <= 1'b1;
            if_mem_req_o        <= 1'b1;
            end else if (stall[0] == `NoStop && if_mem_req_o == 1'b0 && first_fetch == 1'b0) begin
            pc                  <= pc + 4'h4;
            cache_waddr_o       <= `ZeroWord;
            cache_we_o <= 1'b0;
            stage               <= 4'b0000;
            if_mem_req_o        <= 1'b1;
            branch_cancel_req_o <= 1'b0;
        end
    end
    
    
    
    always @(posedge clk) begin
        if (ce == `ChipDisable) begin
            mem_addr_o <= `ZeroWord;
            end else begin
            mem_we_o <= 1'b0;
            if (if_mem_req_o == 1'b1 || first_fetch == 1'b1) begin
                case (stage)
                    4'b0000: begin
                        if (stall[6]) begin
                            stage <= 4'b1000;
                        end
                        else begin
                            mem_addr_o   <= pc;
                            cache_raddr_o <= pc;
                            stage        <= 4'b0001;
                            if_mem_req_o <= 1'b1;
                        end
                        //$display("yes, send byte_addr_1");
                    end
                    4'b1000: begin
                        if (!stall[6]) begin
                            stage        <= 4'b0001;
                            mem_addr_o   <= pc;
                            if_mem_req_o <= 1'b1;
                        end
                    end
                    4'b0001: begin
                        if (stall[6]) begin
                            stage <= 4'b1000;
                        end
                        else if (cache_hit_i) begin
                            stage        <= 4'b0000;
                            inst_o       <= cache_inst_i;
                            if_mem_req_o <= 1'b0;
                            first_fetch  <= 1'b0;
                        end 
                        else begin
                            mem_addr_o     <= pc + 1;
                            stage          <= 4'b0010;
                            if_mem_req_o   <= 1'b1;
                            // inst_block1 <= mem_byte_i;
                        end
                        //$display("yes, send byte_addr_2");
                    end
                    4'b1001: begin
                        if (!stall[6]) begin
                            stage        <= 4'b1010;
                            if_mem_req_o <= 1'b1;
                            mem_addr_o   <= pc + 1;
                        end
                    end
                    4'b0010: begin
                        if (stall[6]) begin
                            stage <= 4'b1000;
                        end
                        else begin
                            mem_addr_o   <= pc + 2;
                            stage        <= 4'b0011;
                            if_mem_req_o <= 1'b1;
                            inst_block1  <= mem_byte_i;
                        end
                        //$display("yes, send byte_addr_3");
                    end
                    4'b1010: begin
                        if (!stall[6]) begin
                            // mirror of 0010, but do not store inst_block1
                            mem_addr_o   <= pc + 2;
                            stage        <= 4'b0011;
                            if_mem_req_o <= 1'b1;
                        end
                    end
                    4'b0011: begin
                        if (stall[6]) begin
                            stage <= 4'b1001;  // resent pc + 1 & pc + 2
                        end
                        else begin
                            mem_addr_o   <= pc + 3;
                            stage        <= 4'b0100;
                            if_mem_req_o <= 1'b1;
                            inst_block2  <= mem_byte_i;
                        end
                        //$display("yes, send byte_addr_4");
                    end
                    4'b1011: begin
                        if (!stall[6]) begin
                            if_mem_req_o <= 1'b1;
                            mem_addr_o   <= pc + 2;
                        end
                    end
                    4'b1100: begin
                        if (!stall[6]) begin
                            mem_addr_o   <= pc + 3;
                            stage        <= 4'b0100;
                            if_mem_req_o <= 1'b1;
                        end
                    end
                    4'b0100: begin
                        if (stall[6]) begin
                            stage <= 4'b1011; // resent pc + 2 & pc + 3 (since block1 & block2 are done)
                        end
                        stage        <= 4'b0101;
                        if_mem_req_o <= 1'b1;
                        inst_block3  <= mem_byte_i;
                    end
                    4'b1101: begin
                        if (!stall[6]) begin
                            mem_addr_o   <= pc + 3;
                            stage        <= 4'b1110;
                            if_mem_req_o <= 1'b1;
                        end
                    end
                    
                    4'b1110: begin
                        if (!stall[6]) begin
                            stage        <= 4'b0101;
                            if_mem_req_o <= 1'b1;
                        end
                    end
                    4'b0101: begin
                        if (stall[6]) begin // resent pc + 3
                            stage <= 4'b1101;
                            end else begin
                                stage        <= 4'b0000;
                                inst_o       <= {mem_byte_i, inst_block3, inst_block2, inst_block1};
                                cache_we_o   <= `WriteEnable;
                                cache_waddr_o <= cache_raddr_o;
                                cache_winst_o <= {mem_byte_i, inst_block3, inst_block2, inst_block1};
                                if_mem_req_o <= 1'b0;
                                first_fetch  <= 1'b0;
                            end
                        end
                        default: ;
                endcase
                end else begin
                
            end
        end
    end
    
endmodule // pc_reg
