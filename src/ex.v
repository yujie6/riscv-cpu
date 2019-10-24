`include "defines.v"

module ex(input wire rst,
          input wire [`AluOpBus] aluop_i,
          input wire [`AluSelBus] alusel_i,
          input wire [`RegBus] reg1_i,
          input wire [`RegBus] reg2_i,
          input wire [`RegAddrBus] shamt_i,
          input wire [`RegBus] imm_i,
          input wire [`RegAddrBus] rd_i,
          input wire wreg_i,
          output reg [`RegAddrBus] rd_o,
          output reg wreg_o,
          output reg [`RegBus] wdata_o);
    
    reg [`RegBus] logic_out;
    reg [`RegBus] shift_out;
    reg [`RegBus] arith_out;
    reg [`RegBus] mem_out;
    
    // All logic operation are done in this submodule
    always @(*) begin
        if (rst == `RstEnable) begin
            logic_out <= `ZeroWord;
            end else begin
            case (aluop_i)
                `EXE_OR_OP:   logic_out <= reg1_i | reg2_i;
                `EXE_AND_OP:  logic_out <= reg1_i & reg2_i;
                `EXE_XOR_OP:  logic_out <= reg1_i ^ reg2_i;
                `EXE_ORI_OP:  logic_out <= reg1_i | imm_i;
                `EXE_ANDI_OP: logic_out <= reg1_i & imm_i;
                `EXE_XORI_OP: logic_out <= reg1_i ^ imm_i;
                default : begin
                    logic_out <= `ZeroWord;
                end
            endcase
        end
    end
    
    // all shift operations are done here
    always @(*) begin
        if (rst == `RstEnable) begin
            shift_out <= `ZeroWord;
            end else begin
            case (aluop_i)
                `EXE_SLL_OP:   logic_out <= reg1_i | reg2_i;
                `EXE_SLLI_OP:  logic_out <= reg1_i & reg2_i;
                `EXE_SRL_OP:   logic_out <= reg1_i ^ reg2_i;
                `EXE_SRLI_OP:  logic_out <= reg1_i | imm_i;
                
                `EXE_SLT_OP:   logic_out <= reg1_i & imm_i;
                `EXE_SLTI_OP:  logic_out <= reg1_i ^ imm_i;
                `EXE_SLTU_OP:  logic_out <= reg1_i ^ imm_i;
                `EXE_SLTIU_OP: logic_out <= reg1_i ^ imm_i;
                default : begin
                    shift_out <= `ZeroWord;
                end
            endcase
        end
    end
    
    // all arithmetic operations are done here including pc 
    always @(*) begin
        if (rst == `RstEnable) begin
            arith_out <= `ZeroWord;
            end else begin
            case (aluop_i)
                `EXE_ADD_OP:   arith_out  <= reg1_i + reg2_i;
                `EXE_ADDI_OP:  arith_out  <= reg1_i + imm_i;
                `EXE_SUB_OP:   arith_out  <= reg1_i - reg2_i;
                `EXE_SUBI_OP:   arith_out <= reg1_i - imm_i;
                // JAL and so on ...
                default : begin
                    arith_out <= `ZeroWord;
                end
            endcase
        end
    end
    
    // By the inst alusel_i given, choose one as the final result
    // There will only be logic op here
    always @(*) begin
        rd_o   <= rd_i;
        wreg_o <= wreg_i;
        case (alusel_i)
            `EXE_RES_LOGIC: begin
                wdata_o <= logic_out;
            end
            `EXE_RES_ARITH: begin
                wdata_o <= arith_out;
            end
            default : begin
                wdata_o <= `ZeroWord;
            end
        endcase
    end
    
endmodule
