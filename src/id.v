`include "defines.v"

module id(input wire rst,
          input wire [`InstAddrBus] pc_i,       // Read from IF_ID
          input wire [`InstBus] inst_i,
          input wire [`RegBus] reg1_data_i,     // Read from regfile
          input wire [`RegBus] reg2_data_i,
          output reg reg1_read_o,               // Output to regfile
          output reg reg2_read_o,
          output reg [`RegAddrBus] reg1_addr_o,
          output reg [`RegAddrBus] reg2_addr_o,
          output reg [`AluOpBus] aluop_o,       // Data sends to EX
          output reg [`AluSelBus] alusel_o,     // how to deal ? what's the logic
          output reg [`RegBus] reg1_o,
          output reg [`RegBus] reg2_o,
          output reg [`RegBus] imm_o,           // send imm to id_ex
          output reg [`RegAddrBus] rd_o,
          output reg wreg_o);
    wire [2:0] funct3      = inst_i[14:12];
    wire [6:0] funct7      = inst_i[31:25];
    wire [6:0] opcode      = inst_i[6:0];
    wire [`RegAddrBus] rs1 = inst_i[19:15];
    wire [`RegAddrBus] rs2 = inst_i[24:20];
    wire [`RegAddrBus] rd  = inst_i[11:7];
    
    wire [`RegBus] imm_i = {
    {20{1'b0}}, inst_i[31:20]
    };
    wire [`RegBus] imm_b = {
    {19{1'b0}},
    inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8], 1'b0
    };
    wire [`RegBus] imm_s = {
    {20{1'b0}},inst_i[31:25],inst_i[11:7]
    };
    wire [`RegBus] imm_u = {
    inst_i[31:12], {12{1'b0}}
    };
    wire [`RegBus] imm_j = {
    {11{1'b0}}, inst_i[31], inst_i[19:12], inst_i[20],
    inst_i[30:21], 1'b0
    };
    
    
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
            imm_o       <= 32'h0;
            end else begin
            aluop_o     <= `EXE_NOP_OP;
            alusel_o    <= `EXE_RES_NOP;
            rd_o        <= `NOPRegAddr;
            wreg_o      <= `WriteDisable;
            instvalid   <= `InstInvalid;
            reg1_read_o <= `ReadDisable;
            reg2_read_o <= `ReadDisable;
            reg1_o      <= `ZeroWord;
            reg2_o      <= `ZeroWord;
            imm_o       <= `ZeroWord;
            // should not declare here, as the instructions here are
            // parallel ??
            reg1_addr_o <= rs1;
            reg2_addr_o <= rs2;
            case (opcode)
                `EXE_LUI: begin
                    // Load immediate to rd
                    wreg_o <= `WriteEnable;
                    imm_o  <= imm_u;
                    rd_o   <= rd;
                end
                
                `EXE_AUIPC: begin
                    // change pc to pc + imm
                    wreg_o <= `WriteEnable;
                    imm_o  <= imm_u;
                    rd_o   <= rd;
                end
                
                `EXE_JAL: begin
                    // jump to imm_j and write pc+4 to rd
                    wreg_o <= `WriteEnable;
                    imm_o  <= imm_j;
                    rd_o   <= rd;
                end
                
                `EXE_JALR: begin
                    // jump to reg[rs1] + imm_i
                    wreg_o      <= `WriteEnable;
                    imm_o       <= imm_i;
                    rd_o        <= rd;
                    reg1_read_o <= `ReadEnable;
                    reg1_o      <= reg1_data_i;
                end
                
                `EXE_BRANCH: begin
                    wreg_o      <= `WriteDisable;
                    imm_o       <= imm_b;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadEnable;
                    reg1_o      <= reg1_data_i;
                    reg2_o      <= reg2_data_i;
                    case (funct3)
                        `EXE_BEQ: begin
                            
                        end
                        `EXE_BNE: begin
                            
                        end
                        `EXE_BLT: begin
                            
                        end
                        `EXE_BGE: begin
                            
                        end
                        `EXE_BLTU: begin
                            
                        end
                        `EXE_BGEU: begin
                            
                        end
                        default: begin
                        end
                    endcase
                end
                
                `EXE_LOAD: begin
                    wreg_o      <= `WriteEnable;
                    rd_o        <= rd;
                    reg1_read_o <= `ReadEnable;
                    reg1_o      <= reg1_data_i;
                    imm_o       <= imm_i;
                    case (funct3)
                        `EXE_LB: begin
                            
                        end
                        `EXE_LH: begin
                            
                        end
                        `EXE_LW: begin
                            
                        end
                        `EXE_LBU: begin
                            
                        end
                        `EXE_LHU: begin
                            
                        end
                        default: begin
                            
                        end
                    endcase
                end
                
                `EXE_ALU_IMM: begin
                    wreg_o      <= `WriteEnable;
                    rd_o        <= rd;
                    reg1_read_o <= `ReadEnable;
                    reg1_o      <= reg1_data_i;
                    imm_o       <= imm_i;
                    case (funct3)
                        `EXE_ADDI: begin
                            // 12-bit imm sign extended, then reg[rd] <= imm + reg[rs1]
                        end
                        `EXE_SLTI: begin
                            // imm sign extended & rs1 as signed 32-bit
                            // reg[rd] <= (imm > reg[rs1])
                        end
                        `EXE_SLTIU: begin
                            // imm sign extended & rs1 as unsigned 32-bit
                        end
                        `EXE_XORI: begin
                            // almost the same as ADDI
                        end
                        `EXE_ORI: begin
                            // almost the same as ADDI
                        end
                        `EXE_ANDI: begin
                            // almost the same as ADDI
                        end
                        `EXE_SLLI: begin
                            // reg[rd] <= (reg[rs1] << shamt) also called shit amount
                        end
                        `EXE_SRLI: begin
                            // reg[rd] < = (reg[rs1] >> shamt) indeed shamt = rs2
                        end
                        `EXE_SRAI: begin
                            // reg[rd] <= (reg[rs1] >> shamt) (arithmetic shift, sign-bit->hign bit)
                        end
                        default: begin
                        end
                    endcase
                end
                
                `EXE_ALU_REG: begin
                    wreg_o      <= `WriteEnable;
                    rd_o        <= rd;
                    reg1_read_o <= `ReadEnable;
                    reg2_read_o <= `ReadEnable;
                    reg1_o      <= reg1_data_i;
                    reg2_o      <= reg2_data_i;
                    case (funct3)
                        `EXE_ADD_SUB: begin
                            case (funct7)
                                `EXE_ADD: begin
                                    
                                end
                                `EXE_SUB: begin
                                    
                                end
                                default: begin
                                    
                                end
                            endcase
                        end
                        `EXE_SLL: begin
                            
                        end
                        `EXE_SLT: begin
                            
                        end
                        `EXE_SLTU: begin
                            
                        end
                        `EXE_XOR: begin
                            
                        end
                        `EXE_SRL_SRA: begin
                            case (funct7)
                                `EXE_SRL: begin
                                    
                                end
                                `EXE_SRA: begin
                                    
                                end
                                default: begin
                                    
                                end
                            endcase
                        end
                        `EXE_OR: begin
                            
                        end
                        `EXE_AND: begin
                            
                        end
                        default: begin
                            
                        end
                    endcase
                end
                
                
                
                `EXE_ORI: begin
                    wreg_o      <= `WriteEnable;
                    aluop_o     <= `EXE_OR_OP;
                    alusel_o    <= `EXE_RES_LOGIC; // The operation is logic
                    reg2_read_o <= `ReadDisable;
                    reg1_read_o <= `ReadEnable;
                    // imm <= 
                    rd_o      <= rd;
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
            reg1_o <= `ZeroWord;
        end
    end
    
    always @(*) begin
        if (rst == `RstEnable) begin
            reg2_o <= `ZeroWord;
            end else if (reg2_read_o == `ReadEnable) begin
            reg2_o <= reg2_data_i; // read from regfile port 2
            end else begin
            reg2_o <= `ZeroWord;
        end
    end
    
endmodule // id
