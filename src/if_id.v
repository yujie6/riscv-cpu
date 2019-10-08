`include "./defines.v"

module if_id(
    input wire clk,
    input wire rst,

    input wire[`InstAddrBus] if_pc,
    input wire[`InstBus] if_inst,
    output reg[`InstAddrBus] if_pc,
    output reg[`InstBus] id_inst
);
    
endmodule // if_id