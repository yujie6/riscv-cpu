`include "defines.v"

module id(input wire rst,
          input wire [`InstAddrBus] pc_i,                 // Read from IF_ID
          input wire [`InstBus] inst_i,
          input wire [`RegBus] reg1_data_i,               // Read from regfile
          input wire [`RegBus] reg2_data_i,
          input wire [`RegAddrBus] ex_wd_forward,
          input wire ex_wreg_forward,
          input wire [`RegBus] ex_wdata_forward,
          input wire [`RegAddrBus] mem_wd_forward,
          input wire mem_wreg_forward,
          input wire [`RegBus] mem_wdata_forward,
          output reg reg1_read_o,                         // Output to regfile
          output reg reg2_read_o,
          output reg [`RegAddrBus] reg1_addr_o,
          output reg [`RegAddrBus] reg2_addr_o,
          output reg [`AluOpBus] aluop_o,                 // Data sends to EX
          output reg [`AluSelBus] alusel_o,               // how to deal ? what's the logic
          output reg [`RegBus] reg1_o,
          output reg [`RegBus] reg2_o,
          output reg [`RegBus] imm_o,                     // send imm to id_ex
          output reg [`RegAddrBus] shamt_o,
          output reg [`RegAddrBus] rd_o,
          output wire [`InstAddrBus] pc_o,
          output reg [`InstAddrBus] branch_target_addr_o,
          output reg [`InstAddrBus] link_addr_o,
          output reg [`MemSelBus] mem_sel_o,
          output reg mem_we_o,
          output reg mem_load_sign_o,
          output reg branch_flag_o,
          output reg wreg_o);
    wire [2:0] funct3      = inst_i[14:12];
    wire [6:0] funct7      = inst_i[31:25];
    wire [6:0] opcode      = inst_i[6:0];
    wire [`RegAddrBus] rs1 = inst_i[19:15];
    wire [`RegAddrBus] rs2 = inst_i[24:20];
    wire [`RegAddrBus] rd  = inst_i[11:7];
    wire [`RegBus] pc_4;
    wire [`RegBus] pc_8;
    assign pc_4 = pc_i + 4;
    assign pc_8 = pc_i + 8;
    assign pc_o = pc_i;

    // imm computing
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
    {11{inst_i[31]}}, inst_i[31], inst_i[19:12], inst_i[20],
    inst_i[30:21], 1'b0
    };
    wire [`RegBus] sign_imm_b = {
        {19{inst_i[31]}},
    inst_i[31],inst_i[7],inst_i[30:25],inst_i[11:8], 1'b0
    };
    
    
    reg instvalid;
    
    always @(*) begin
        if (rst == `RstEnable) begin
            aluop_o              <= `EXE_NOP_OP;
            alusel_o             <= `EXE_RES_NOP;
            rd_o                 <= `NOPRegAddr;
            wreg_o               <= `WriteDisable;
            instvalid            <= `InstInvalid;
            reg1_read_o          <= 1'b0;
            reg2_read_o          <= 1'b0;
            reg1_addr_o          <= `NOPRegAddr;
            reg2_addr_o          <= `NOPRegAddr;
            branch_target_addr_o <= `NOPInstAddr;
            branch_flag_o        <= 1'b0;
            imm_o                <= 32'h0;
            shamt_o              <= 5'b00000;
        end
        
        else begin
        aluop_o              <= `EXE_NOP_OP;
        alusel_o             <= `EXE_RES_NOP;
        rd_o                 <= `NOPRegAddr;
        wreg_o               <= `WriteDisable;
        instvalid            <= `InstInvalid;
        reg1_read_o          <= `ReadDisable;
        reg2_read_o          <= `ReadDisable;
        imm_o                <= `ZeroWord;
        branch_target_addr_o <= `NOPInstAddr;
        branch_flag_o        <= 1'b0;
        shamt_o              <= 5'b00000;
        reg1_addr_o          <= rs1;
        reg2_addr_o          <= rs2;
        case (opcode)
            `EXE_LUI: begin
                // Load immediate to rd
                aluop_o <= `EXE_LUI_OP;
                alusel_o <= `EXE_RES_ARITH;
                wreg_o  <= `WriteEnable;
                imm_o   <= imm_u;
                rd_o    <= rd;
                //$display("lui detected");
            end
            
            `EXE_AUIPC: begin
                // change pc to pc + imm
                aluop_o <= `EXE_AUIPC_OP;
                alusel_o <= `EXE_RES_ARITH;
                wreg_o  <= `WriteEnable;
                imm_o   <= imm_u;
                rd_o    <= rd;
            end
            
            `EXE_JAL: begin
                // jump to imm_j and write pc+4 to rd
                // FIXME: Continuous 2 jump inst, the second should not be canceled
                aluop_o                 <= `EXE_JAL_OP;
                alusel_o                <= `EXE_RES_JUMP_BRANCH;
                wreg_o                  <= `WriteEnable;
                imm_o                   <= $signed(imm_j);
                rd_o                    <= rd;
                link_addr_o             <= pc_4;
                branch_flag_o           <= 1'b1;
                branch_target_addr_o    <= pc_i + $signed(imm_j);
                // branch_target_addr_o <= ;
            end
            
            `EXE_JALR: begin
                // jump to reg[rs1] + imm_i
                aluop_o              <= `EXE_JALR_OP;
                alusel_o             <= `EXE_RES_JUMP_BRANCH;
                wreg_o               <= `WriteEnable;
                imm_o                <= imm_i;
                rd_o                 <= rd;
                if (rd == 5'b00000 && rs1 == 5'b00001 && imm_i == `ZeroWord) begin
                    $display("All process done");
                    $finish;
                end
                reg1_read_o          <= `ReadEnable;
                link_addr_o <= pc_4;
                branch_flag_o        <= 1'b1;
                branch_target_addr_o <= imm_i + reg1_o;
            end
            
            `EXE_BRANCH: begin
                // if compare returns 1, jumps to pc+imm
                // TODO: all compare are done here in ID
                wreg_o      <= `WriteDisable;
                rd_o        <= `NOPRegAddr;
                imm_o       <= sign_imm_b;
                reg1_read_o <= `ReadEnable;
                reg2_read_o <= `ReadEnable;
                alusel_o    <= `EXE_RES_JUMP_BRANCH;
                case (funct3)
                    `EXE_BEQ: begin
                        aluop_o <= `EXE_BEQ_OP;
                        if (reg1_o == reg2_o) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    `EXE_BNE: begin
                        aluop_o <= `EXE_BNE_OP;
                        if (reg1_o != reg2_o) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    `EXE_BLT: begin
                        aluop_o <= `EXE_BLT_OP;
                        if ($signed(reg1_o) < $signed(reg2_o)) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    `EXE_BGE: begin
                        aluop_o <= `EXE_BGE_OP;
                        if ($signed(reg1_o) > $signed(reg2_o)) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    `EXE_BLTU: begin
                        aluop_o <= `EXE_BLTU_OP;
                        if (reg1_o < reg2_o) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    `EXE_BGEU: begin
                        aluop_o <= `EXE_BGEU_OP;
                        if (reg1_o == reg2_o) begin
                            branch_target_addr_o <= pc_i + sign_imm_b;
                            branch_flag_o        <= 1'b1;
                        end
                    end
                    default: begin
                    end
                endcase
            end
            
            `EXE_LOAD: begin
                wreg_o      <= `WriteEnable;
                rd_o        <= rd;
                reg1_read_o <= `ReadEnable;
                reg2_read_o <= `ReadDisable;
                alusel_o    <= `EXE_RES_LOAD_STORE;
                imm_o       <= imm_i;
                case (funct3)
                    `EXE_LB: begin
                        aluop_o <= `EXE_LB_OP;
                        mem_we_o <= `WriteDisable;
                        mem_sel_o <= `MEM_BYTE;
                        mem_load_sign_o <= 1'b1;
                    end
                    `EXE_LH: begin
                        aluop_o <= `EXE_LH_OP;
                        mem_we_o <= `WriteDisable;
                        mem_sel_o <= `MEM_HALF;
                        mem_load_sign_o <= 1'b1;
                    end
                    `EXE_LW: begin
                        aluop_o <= `EXE_LW_OP;
                        mem_we_o <= `WriteDisable;
                        mem_sel_o <= `MEM_WORD;
                        mem_load_sign_o <= 1'b1; 
                    end
                    `EXE_LBU: begin
                        aluop_o <= `EXE_LBU_OP;
                        mem_we_o <= `WriteDisable;
                        mem_sel_o <= `MEM_BYTE;
                        mem_load_sign_o <= 1'b0;
                    end
                    `EXE_LHU: begin
                        aluop_o <= `EXE_LHU_OP;
                        mem_we_o <= `WriteDisable;
                        mem_sel_o <= `MEM_HALF;
                        mem_load_sign_o <= 1'b0; 
                    end
                    default: begin
                        aluop_o <= `EXE_NOP_OP;
                    end
                endcase
            end
            
            `EXE_STORE: begin
                wreg_o      <= `WriteDisable;
                rd_o        <= `NOPRegAddr;
                reg1_read_o <= `ReadEnable;
                reg2_read_o <= `ReadEnable;
                alusel_o    <= `EXE_RES_LOAD_STORE;
                imm_o       <= imm_s;
                case (funct3)
                    `EXE_SB: begin
                        aluop_o <= `EXE_SB_OP;
                        mem_sel_o <= `MEM_BYTE;
                        mem_we_o <= `WriteEnable;
                    end
                    `EXE_SH: begin
                        aluop_o <= `EXE_SH_OP;
                        mem_sel_o <= `MEM_HALF;
                        mem_we_o <= `WriteEnable;
                    end
                    `EXE_SW: begin
                        aluop_o <= `EXE_SW_OP;
                        mem_sel_o <= `MEM_WORD;
                        mem_we_o <= `WriteEnable;
                    end
                    default: begin
                        aluop_o <= `EXE_NOP_OP;
                    end
                endcase
            end
            
            `EXE_ALU_IMM: begin
                wreg_o      <= `WriteEnable;
                rd_o        <= rd;
                reg1_read_o <= `ReadEnable;
                imm_o <= imm_i;
                case (funct3)
                    // TODO: where is SLTU
                    `EXE_ADDI: begin
                        // 12-bit imm sign extended, then reg[rd] <= imm + reg[rs1]
                        aluop_o  <= `EXE_ADDI_OP;
                        alusel_o <= `EXE_RES_ARITH;
                    end
                    `EXE_SLTI: begin
                        // imm sign extended & rs1 as signed 32-bit
                        // reg[rd] <= (imm > reg[rs1])
                        aluop_o <= `EXE_SLTI_OP;
                    end
                    `EXE_SLTIU: begin
                        // imm sign extended & rs1 as unsigned 32-bit
                        aluop_o <= `EXE_SLTIU_OP;
                    end
                    `EXE_XORI: begin
                        // almost the same as ADDI
                        aluop_o  <= `EXE_XORI_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    `EXE_ORI: begin
                        // almost the same as ADDI
                        $display("Ori detected");
                        aluop_o  <= `EXE_ORI_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    `EXE_ANDI: begin
                        // almost the same as ADDI
                        aluop_o  <= `EXE_ANDI_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    `EXE_SLLI: begin
                    // FIXME: Modify alusel here 
                        // reg[rd] <= (reg[rs1] << shamt) also called shit amount
                        aluop_o <= `EXE_SLLI_OP;
                        shamt_o <= rs2;
                    end
                    `EXE_SRLI: begin
                        // reg[rd] < = (reg[rs1] >> shamt) indeed shamt = rs2
                        aluop_o <= `EXE_SRLI_OP;
                        shamt_o <= rs2;
                    end
                    `EXE_SRAI: begin
                        // reg[rd] <= (reg[rs1] >> shamt) (arithmetic shift, sign-bit->hign bit)
                        aluop_o <= `EXE_SRAI_OP;
                        shamt_o <= rs2;
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
                case (funct3)
                    `EXE_ADD_SUB: begin
                        case (funct7)
                            `EXE_ADD: begin
                                aluop_o  <= `EXE_ADD_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                            end
                            `EXE_SUB: begin
                                aluop_o  <= `EXE_SUB_OP;
                                alusel_o <= `EXE_RES_LOGIC;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    `EXE_SLL: begin
                        aluop_o  <= `EXE_SLL_OP;
                        alusel_o <= `EXE_RES_SHIFT;
                    end
                    `EXE_SLT: begin
                        aluop_o <= `EXE_SLT_OP;
                    end
                    `EXE_SLTU: begin
                        aluop_o <= `EXE_SLTU_OP;
                    end
                    `EXE_XOR: begin
                        aluop_o  <= `EXE_XOR_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    `EXE_SRL_SRA: begin
                        case (funct7)
                            `EXE_SRL: begin
                                aluop_o <= `EXE_SRL_OP;
                            end
                            `EXE_SRA: begin
                                aluop_o <= `EXE_SRA_OP;
                            end
                            default: begin
                                
                            end
                        endcase
                    end
                    `EXE_OR: begin
                        aluop_o  <= `EXE_OR_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    `EXE_AND: begin
                        aluop_o  <= `EXE_AND_OP;
                        alusel_o <= `EXE_RES_LOGIC;
                    end
                    default: begin
                        
                    end
                endcase
            end
            
            default: begin
            end
        endcase
    end
    end
    
    always @(*) begin
        if (rst == `RstEnable) begin
            reg1_o <= `ZeroWord;
        end
        else if ((reg1_read_o == `ReadEnable) && (ex_wreg_forward == `WriteEnable)
            && (ex_wd_forward == reg1_addr_o)) begin
            // NOTE: Date forwarding from ex
            reg1_o <= ex_wdata_forward;
            end else if ((reg1_read_o == `ReadEnable) && (mem_wreg_forward == `WriteEnable)
            && (mem_wd_forward == reg1_addr_o)) begin
            // NOTE: Data forwarding from mem
            reg1_o <= mem_wdata_forward;
            end
        else if (reg1_read_o == `ReadEnable) begin
            reg1_o <= reg1_data_i; // read from regfile port 1
            end else if (reg1_read_o == `ReadDisable) begin
            reg1_o <= `ZeroWord;
        end
            end
            
            always @(*) begin
                if (rst == `RstEnable) begin
                    reg2_o <= `ZeroWord;
                    end else if ((reg2_read_o == `ReadEnable) && (ex_wreg_forward == `WriteEnable)
                    && (ex_wd_forward == reg2_addr_o)) begin
                    // NOTE: Date forwarding from ex
                    reg2_o <= ex_wdata_forward;
                    end else if ((reg2_read_o == `ReadEnable) && (mem_wreg_forward == `WriteEnable)
                    && (mem_wd_forward == reg2_addr_o)) begin
                    // NOTE: Data forwarding from mem
                    reg2_o <= mem_wdata_forward;
                    end else if (reg2_read_o == `ReadEnable) begin
                    reg2_o <= reg2_data_i; // read from regfile port 2
                    end else begin
                    reg2_o <= `ZeroWord;
                end
            end
            
            endmodule // id
