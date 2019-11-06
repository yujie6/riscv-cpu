// Control
`include "./defines.v"

module MemController(input wire rst_i,
                     input wire clk_i,
                     input wire [`MemAddrBus] mem_addr_i,  // data addr send to memory
                     input wire we_i,                      // write or not
                     input wire [`MemSelBus] mem_sel_i,    // Byte | Half Word | Word
                     input wire [`RegBus] mem_wdata_i,     // this is rs2 send to memor
                     input wire [7:0] mem_byte_i,
                     output reg [7:0] we_byte_o,
                     output reg [`MemAddrBus] byte_addr_o,
                     output reg [`RegBus] mem_data_o);
    // TODO: Concatenate 4 bytes to a word and send it to mem.v
    // TODO: Split a word into 4 bytes and send them to ram.v
    wire [`MemAddrBus] addr_1;
    wire [`MemAddrBus] addr_2;
    wire [`MemAddrBus] addr_3;
    wire [`MemAddrBus] addr_4;
    assign addr_1 = mem_addr_i;
    assign addr_2 = mem_addr_i + 8;
    assign addr_3 = mem_addr_i + 16;
    assign addr_4 = mem_addr_i + 24;
    reg [3:0] stage;
    reg [7:0] inst_block1;
    reg [7:0] inst_block2;
    reg [7:0] inst_block3;
    
    always @(posedge clk_i) begin
        if (rst_i) begin
            
            end else begin
            case (stage)
                4'b0000: begin
                    byte_addr_o <= addr_1;
                    stage <= 4'b0001;
                end
                4'b0001: begin
                    byte_addr_o <= addr_2;
                    stage <= 4'b0010; 
                end
                4'b0010: begin
                    
                end
                default: ;
            endcase
        end
    end
    
endmodule // MemControler
