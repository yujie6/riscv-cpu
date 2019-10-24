// ----------------- basic macros ------------------------
`define RstEnable 1'b1 //reset signal is 1
`define RstDisable 1'b0 //reset signal is 0
`define ZeroWord 32'h00000000 //32 bit 0 word
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define InstInvalid 1'b0
`define InstValid 1'b1

// ------------- macros related to instructions ---------------
`define EXE_LUI 7'b0110111
`define EXE_AUIPC 7'b0010111
`define EXE_JAL 7'b1101111
`define EXE_JALR 7'b1100111
// brach opcode
`define EXE_BRANCH 7'b1100011
`define EXE_BEQ 3'b000
`define EXE_BNE 3'b001
`define EXE_BLT 3'b100
`define EXE_BGE 3'b101
`define EXE_BLTU 3'b110
`define EXE_BGEU 3'b111
// load opcode
`define EXE_LOAD 7'b0000011
`define EXE_LB 3'b000
`define EXE_LH 3'b001
`define EXE_LW 3'b010
`define EXE_LBU 3'b100
`define EXE_LHU 3'b101
// store opcode
`define EXE_STORE 7'b0100011
`define EXE_SB 3'b000
`define EXE_SH 3'b001
`define EXE_SW 3'b010
// logic operation
// rs1 & imm 
`define EXE_ALU_IMM 7'b0010011
`define EXE_ADDI 3'b000
`define EXE_SLTI 3'b010
`define EXE_SLTIU 3'b011
`define EXE_XORI 3'b100 
`define EXE_ORI 3'b110 
`define EXE_ANDI 3'b111
`define EXE_SLLI 3'b001
`define EXE_SRLI_SRAI 3'b101
`define EXE_SRLI 7'b0000000
`define EXE_SRAI 7'b0100000
// rs1 & rs2
`define EXE_ALU_REG 7'b0110011
`define EXE_ADD_SUB 3'b000
`define EXE_ADD 7'b0000000
`define EXE_SUB 7'b0100000
`define EXE_SLL 3'b001
`define EXE_SLT 3'b010
`define EXE_SLTU 3'b011
`define EXE_XOR 3'b100
`define EXE_SRL_SRA 3'b101
`define EXE_SRL 7'b0000000
`define EXE_SRA 7'b0100000 
`define EXE_OR 3'b110
`define EXE_AND 3'b111
// no operation
`define EXE_NOP 7'b0000000 

//AluOp --- switch(aluop) in EX
`define EXE_OR_OP 8'b00100101
`define EXE_NOP_OP 8'b00000000
//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP 3'b000


// -------------- macros related to rom ----------------------
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum 130171 // the size of rom is 128km
`define InstMemNumLog2 17 // the len of Rom address

// --------------- macros related to register ----------------
`define RegAddrBus 4:0 // len of Regfile address
`define RegBus 31:0 // number of registers in Regfile
`define RegWidth 32
`define RegNum 32
`define NOPRegAddr 5'b00000
`define RegNumLog2 32




