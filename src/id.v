`include "./defines.v"

module id(input wire rst,
          input wire[`InstAddrBus] pc_i,       // Read from IF_ID
          input wire[`InstBus] inst_i,
          input wire[`RegBus] reg1_data_i,     // Read from regfile
          input wire[`RegBus] reg2_data_i,
          output reg reg1_read_o,              // Output to regfile
          output reg reg2_read_o,
          output reg[`RegAddrBus] reg1_addr_o,
          output reg[`RegAddrBus] reg2_addr_o,
          output reg[`AluOpBus] aluop_o,       // Data sends to EX
          output reg[`AluSelBus] alusel_o,
          output reg[`RegBus] reg1_o,
          output reg[`RegBus] reg2_o,
          output reg[`RegAddrBus] rd_o,
          output reg wreg_o);
    //wire[2:0] funct3  = inst_i[];
    //wire[2:0] funct 7 = inst_i[];
    wire[6:0] opcode    = inst_i[6:0];
    wire[4:0] rs1       = inst_i[19:15];
    wire[4:0] rs2       = inst_i[24:20];
    wire[4:0] rd        = inst_i[11:7];
    
    reg[`RegBus] imm;
    
    reg instvalid;
    
    always @(*) begin
        if (rst == `RstEnable) begin
            aluop_o     <= `EXE_NOP_OP;
            alusel_o    <= `EXE_RES_NOP;
            rd_o        <= `NOPRegAddr;
            wreg_o      <= `WriteDisable;
            instvalid   <= `InstInvalid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= `NOPRegAddr;
            reg2_addr_o <= `NOPRegAddr;
            imm         <= 32'h0;
            end else begin
            aluop_o     <= `EXE_NOP_OP;
            alusel_o    <= `EXE_RES_NOP;
            rd_o        <= `NOPRegAddr;
            wreg_o      <= `WriteDisable;
            instvalid   <= `InstInvalid;
            reg1_read_o <= 1'b0;
            reg2_read_o <= 1'b0;
            reg1_addr_o <= inst_i[19:15];
            reg2_addr_o <= inst_i[24:20];
            imm         <= `ZeroWord;
            
            case (opcode)
                `EXE_ORI: begin
                    wreg_o      <= `WriteEnable;
                    aluop_o     <= `EXE_OR_OP;
                    alusel_o    <= `EXE_RES_LOGIC; // The operation is logic
                    reg2_read_o <= `ReadDisable;
                    reg1_read_o <= `ReadEnable;
                    // imm <= 
                    rd_o <= rd;
                    instvalid <= `InstValid;
                end
                default: begin
                end
            endcase
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            reg1_o <= `ZeroWord;
        end else if (reg1_read_o == `ReadEnable) begin
            reg1_o <= reg1_data_i; // read from regfile port 1
        end else if (reg1_read_o == `ReadDisable) begin
            reg1_o <= imm;
        end else begin
            reg1_o <= `ZeroWord;
        end
    end

    always @(*) begin
        if (rst == `RstEnable) begin
            reg2_o <= `ZeroWord;
        end else if (reg2_read_o == `ReadEnable) begin
            reg2_o <= reg2_data_i; // read from regfile port 2
        end else if (reg2_read_o == `ReadDisable) begin
            reg2_o <= imm;
        end else begin
            reg2_o <= `ZeroWord;
        end
    end
    
endmodule // id
