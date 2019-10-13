
`define RstEnable 1'b1 //reset signal is 1
`define RstDisable 1'b0 //reset signal is 0
`define ZeroWord 32'h00000000 //32 bit 0 word
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define AluOpBus 7:0
`define AluSelBus 2:0
`define ChipEnable 1'b1
`define ChipDisable 1'b0
`define WriteEnable 1'b1
`define WriteDisable 1'b0
`define ReadEnable 1'b1
`define ReadDisable 1'b0
`define InstInvalid 1'b0
`define InstValid 1'b1

// ------------- macros related to instructions ---------------
`define EXE_ORI 7'b0010011
`define EXE_NOP 7'b0000000 // no operation

//AluOp
`define EXE_OR_OP 8'b00100101
`define EXE_NOP_OP 8'b00000000
//AluSel
`define EXE_RES_LOGIC 3'b001
`define EXE_RES_NOP 3'b000


// -------------- macros related to rom ----------------------
`define InstAddrBus 31:0
`define InstBus 31:0
`define InstMemNum  130171 // the size of rom is 128km
`define InstMemNumLog2 17 // the len of Rom address

// --------------- macros related to register ----------------
`define RegAddrBus 4:0 // len of Regfile address
`define RegBus 31:0 // number of registers in Regfile
`define RegWidth 32
`define RegNum 32
`define NOPRegAddr 5'b00000
`define RegNumLog2 32
