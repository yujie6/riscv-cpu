`include "./defines.v"

module id(input wire rst,
          input wire[`InstAddrBus] pc_i,
          input wire[`InstBus] inst_i,
          input wire[`RegBus] reg1_data_i,
          input wire[`RegBus] reg2_data_i,
          output reg reg1_read_o,
          output reg reg2_read_o,
          output reg[`RegAddrBus] reg1_addr_o,
          output reg[`RegAddrBus] reg2_addr_o,
          output reg[`AluOpBus] aluop_o,
          output reg wreg_o);
    //wire[2:0] funct3 = inst_i[];
    //wire[2:0] funct7 = inst_i[];
    wire[6:0] opcode   = inst_i[6:0];
    wire[4:0] rs1      = inst_i[19:15];
    wire[4:0] rs2      = inst_i[24:20];
    wire[4:0] rd       = inst_i[11:7];
    
    
    
endmodule // id
