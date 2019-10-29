`include "./defines.v"
module mem(input wire rst,
           input wire [`RegAddrBus] rd_i,
           input wire [`RegBus] wdata_i,
           input wire wreg_i,
           input wire [`RegBus] mem_reg2_i,     // data from rs2
           input wire [`MemAddrBus] mem_addr_i,
           input wire [`RegBus] mem_data_i,     // data read from memory
           input wire [`AluOpBus] aluop_i,
           output reg [`MemAddrBus] mem_addr_o, // data addr send to memory
           output reg mem_we_o,                 // write or not
           output reg mem_ce_o,
           output reg [`MemSelBus] mem_sel_o,   // Byte | Half Word | Word
           output reg [`RegBus] mem_wdata_o,    // this is rs2 send to memory
           output reg [`RegAddrBus] rd_o,
           output reg [`RegBus] wdata_o,        // data send to rd
           output reg wreg_o);
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_o        <= `NOPRegAddr;
            wdata_o     <= `ZeroWord;
            wreg_o      <= `WriteDisable;
            mem_wdata_o <= `ZeroWord;
            mem_ce_o    <= 1'b1;
            mem_sel_o   <= `MEM_NOP;
            end else begin
            mem_ce_o <= 1'b0;
            rd_o     <= rd_i;
            wdata_o  <= wdata_i;
            wreg_o   <= wreg_i;
            // FIXME: Should not go this way, all decode shall be done in ID
            case (aluop_i)
                `EXE_SB_OP: begin
                    mem_sel_o   <= `MEM_BYTE;
                    mem_addr_o  <= mem_addr_i;
                    mem_wdata_o <= mem_reg2_i;
                    mem_we_o    <= `WriteEnable;
                end
                `EXE_SH_OP: begin
                    mem_sel_o   <= `MEM_HALF;
                    mem_addr_o  <= mem_addr_i;
                    mem_wdata_o <= mem_reg2_i;
                    mem_we_o    <= `WriteEnable;
                end
                `EXE_SW_OP: begin
                    mem_sel_o   <= `MEM_WORD;
                    mem_addr_o  <= mem_addr_i;
                    mem_wdata_o <= mem_reg2_i;
                    mem_we_o    <= `WriteEnable;
                end
                `EXE_LB_OP: begin
                    mem_sel_o  <= `MEM_BYTE;
                    mem_addr_o <= mem_addr_i;
                    mem_we_o   <= `WriteDisable;
                    wdata_o    <= mem_data_i;
                end
                `EXE_LH_OP: begin
                    mem_sel_o  <= `MEM_HALF;
                    mem_addr_o <= mem_addr_i;
                    mem_we_o   <= `WriteDisable;
                    wdata_o    <= mem_data_i;
                end
                `EXE_LW_OP: begin
                    mem_sel_o  <= `MEM_WORD;
                    mem_addr_o <= mem_addr_i;
                    mem_we_o   <= `WriteDisable;
                    wdata_o    <= mem_data_i;
                end
                `EXE_LBU_OP: begin
                    mem_sel_o  <= `MEM_BYTE;
                    mem_addr_o <= mem_addr_i;
                    mem_we_o   <= `WriteDisable;
                    wdata_o    <= mem_data_i;
                end
                `EXE_LHU_OP: begin
                    mem_sel_o  <= `MEM_HALF;
                    mem_addr_o <= mem_addr_i;
                    mem_we_o   <= `WriteDisable;
                    wdata_o    <= mem_data_i;
                end
                default: ;
            endcase
        end
    end
    // DEBUG: CONSIDER SEND DATA INDEPENDENTLY OR NOT
    // always @(*) begin
    //     if (rst == `RstEnable) begin
    
    //     end else begin
    //         wdata_o <= mem_data_i;
    //     end
    // end
    
endmodule
