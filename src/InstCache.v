`include "./defines.v"


module InstCache(input wire clk_i,
                 input wire rst_i,
                 input wire rdy_i,
                 input wire we_i,
                 input wire[`InstAddrBus] write_pc_i,
                 input wire[`InstBus] write_inst_i,
                 input wire[`InstAddrBus] read_pc_i,
                 output reg hit_o,
                 output reg[`InstBus] inst_o);
    
    (* ram_style = "registers" *) reg [31:0] cache_data[`BlockNum - 1:0];
    (* ram_style = "registers" *) reg [9:0]  cache_tag[`BlockNum - 1:0];
    (* ram_style = "registers" *) reg        cache_valid[`BlockNum - 1:0];
    
    wire        rvalid;
    wire [9:0]  read_tag_i;
    wire [6:0]  read_index_i;
    wire [9:0]  write_tag_i;
    wire [6:0]  write_index_i;
    wire [9:0]  rtag_c;
    wire [31:0] rinst_c;
    
    assign read_tag_i    = read_pc_i[16:7];
    assign read_index_i  = read_pc_i[6:0];
    assign write_tag_i   = write_pc_i[16:7];
    assign write_index_i = write_pc_i[6:0];
    assign rvalid        = cache_valid[read_index_i];
    assign rtag_c        = cache_tag[read_index_i];
    assign rinst_c       = cache_data[read_index_i];
    
    integer i;
    
    always @ (posedge clk_i) begin
        if (rst_i)begin
            for (i = 0; i < `BlockNum; i = i + 1) begin
                cache_valid[i] <= 1'b0;
            end
            end else if (we_i) begin // write enable
            cache_valid[write_index_i] <= 1'b1;
            cache_tag[write_index_i]   <= write_tag_i;
            cache_data[write_index_i]  <= write_inst_i;
        end
    end
    
    
    always @ (*) begin
        if (rst_i || !rdy_i) begin
            hit_o  <= 1'b0;
            inst_o <= `ZeroWord;
            end else begin
            if ((read_index_i == write_index_i) && we_i) begin // read_index_i == write_index_i
                hit_o  <= 1'b1;
                inst_o <= write_inst_i;
                end else if ((read_tag_i == rtag_c) && rvalid) begin
                hit_o  <= 1'b1;
                inst_o <= rinst_c;
                end else begin
                hit_o  <= 1'b0;
                inst_o <= `ZeroWord;
            end
        end
    end
endmodule // InstCache
