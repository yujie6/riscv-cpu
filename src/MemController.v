// Control
`include "./defines.v"

module MemController(input wire rst_i,
                     input wire clk_i,
                     input wire [`MemAddrBus] mem_addr_i,  // data addr send to memory
                     input wire we_i,                      // write or not
                     input wire [`RegBus] mem_wdata_i,     // this is rs2 send to memor
                     input wire [7:0] mem_byte_i,
                     input wire if_mem_req_i,
                     input wire mem_mem_req_i,
                     output reg [7:0] we_byte_o,
                     output wire we_o,
                     output reg [`MemAddrBus] byte_addr_o); // data read from ram
    assign we_o = we_i;

    always @(posedge clk_i) begin // read from ram.v
        if (rst_i) begin
            we_byte_o <= 8'h00;        
        end else if (if_mem_req_i) begin
            we_byte_o <= mem_byte_i;
            byte_addr_o <= mem_addr_i;
        end else if (mem_mem_req_i) begin
            if (we_i) begin
                
            end else begin
                
            end
        end
    end
    
endmodule // MemControler
