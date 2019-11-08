`include"defines.v"
module MemController (input wire rst,
            input wire if_mem_req_i,
            input wire mem_mem_req_i,
            input wire mem_write_enable_i,
            input wire[`InstAddrBus] if_mem_addr_i,
            input wire[`InstAddrBus] mem_mem_addr_i,
            input wire[`MemDataBus] mem_data_i,
            output reg write_enable_o,
            output reg[`InstAddrBus] mem_addr_o,
            output reg[`MemDataBus] mem_data_o,
            output reg if_stall_req_o,
            output reg mem_stall_req_o);
    
    always @ (*) begin
        if (rst) begin
            write_enable_o  <= 1'b0;
            mem_addr_o      <= `ZeroWord;
            mem_data_o      <= 8'h00;
            if_stall_req_o  <= 1'b0;
            mem_stall_req_o <= 1'b0;
            end else begin
            write_enable_o <= 1'b0;
            mem_addr_o     <= `ZeroWord;
            mem_data_o     <= 8'h00;
            if (mem_mem_req_i) begin
                if_stall_req_o  <= 1'b0;
                mem_stall_req_o <= 1'b1;
                write_enable_o  <= mem_write_enable_i;
                mem_addr_o      <= mem_mem_addr_i;
                mem_data_o      <= mem_data_i;
                end else if (if_mem_req_i) begin
                if_stall_req_o  <= 1'b1;
                mem_stall_req_o <= 1'b0;
                write_enable_o  <= 1'b0;
                mem_addr_o      <= if_mem_addr_i;
                end else begin
                if_stall_req_o  <= 1'b0;
                mem_stall_req_o <= 1'b0;
            end
        end
    end
    
endmodule 
