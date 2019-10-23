// RISCV32I CPU top module
// port modification allowed for debugging purposes
`include "defines.v"
module cpu(input wire clk_in,
    input wire rst_in,
    input wire rdy_in,
    input wire [7:0] mem_din,
    output wire [7:0] mem_dout,
    output wire [31:0] mem_addr,
    output wire mem_wr,
    output wire [31:0] dbgreg_dout);

    // implementation goes here

    // Specifications:
    // - Pause cpu(freeze pc, registers, etc.) when rdy_in is low
    // - Memory read takes 2 cycles(wait till next cycle), write takes 1 cycle(no need to wait)
    // - Memory is of size 128KB, with valid address ranging from 0x0 to 0x20000
    // - I/O port is mapped to address higher than 0x30000 (mem_a[17:16] == 2'b11)
    // - 0x30000 read: read a byte from input
    // - 0x30000 write: write a byte to output (write 0x00 is ignored)
    // - 0x30004 read: read clocks passed since cpu starts (in dword, 4 bytes)
    // - 0x30004 write: indicates program stop (will output '\0' through uart tx)

    wire [`InstAddrBus] pc;
    wire [`InstAddrBus] id_pc_i;
    wire [`InstBus] id_inst_i;


    always @(posedge clk_in)
        begin
            if (rst_in)
                begin
                    mem_dout <= 8'b00000000;
                    mem_wr <= `WriteDisable;
                    mem_addr <= `ZeroWord;
                    dbgreg_dout <= `ZeroWord;
                end
            else if (!rdy_in)
                begin
                    // Pause
                end
            else
                begin

                end
        end



    if_id if_id0(
        .clk(clk_in), .rst(rst_in), .if_pc(pc),
        .if_inst()
    );


endmodule: cpu
