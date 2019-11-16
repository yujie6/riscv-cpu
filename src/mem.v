`include "./defines.v"
module mem(input wire rst,
           input wire [`RegAddrBus] rd_i,
           input wire [`RegBus] wdata_i,
           input wire [`InstAddrBus] pc_i,
           input wire wreg_i,
           input wire [`RegBus] mem_reg2_i,           // data from rs2
           input wire [`MemAddrBus] mem_addr_i,
           input wire [`RegBus] mem_data_i,           // data read from memory
           input wire [`AluOpBus] aluop_i,
           input wire [`MemSelBus] mem_sel_i,
           input wire mem_we_i,
           input wire mem_load_sign_i,
           output reg [`MemAddrBus] mem_addr_o,       // data addr send to memory
           output reg mem_we_o,                       // write or not
           output reg mem_ce_o,
           output reg [`MemSelBus] mem_sel_o,         // Byte | Half Word | Word
           output reg [`MemDataBus] mem_write_byte_o, // this is rs2 send to memory
           output reg [`RegAddrBus] rd_o,
           output reg [`RegBus] wdata_o,              // data send to rd
           output reg stallreq_mem_o,
           output reg wreg_o);


    reg mem_done;
    reg mem_operation;
    
    always @(*) begin
        if (rst == `RstEnable) begin
            rd_o             <= `NOPRegAddr;
            wdata_o          <= `ZeroWord;
            wreg_o           <= `WriteDisable;
            mem_write_byte_o <= `ZeroByte;
            mem_ce_o         <= 1'b1;
            mem_sel_o        <= `MEM_NOP;
            stallreq_mem_o   <= 1'b0;
            end else begin
            mem_ce_o       <= 1'b0;
            rd_o           <= rd_i;
            wdata_o        <= wdata_i;
            wreg_o         <= wreg_i;
            stallreq_mem_o <= 1'b0;
            // FIXME: Should not go this way, all decode shall be done in ID
            case (aluop_i)
                `EXE_SB_OP: begin
                    mem_sel_o      <= `MEM_BYTE;
                    mem_we_o       <= `WriteEnable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_SH_OP: begin
                    mem_sel_o      <= `MEM_HALF;
                    mem_we_o       <= `WriteEnable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_SW_OP: begin
                    mem_sel_o      <= `MEM_WORD;
                    mem_we_o       <= `WriteEnable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_LB_OP: begin
                    mem_sel_o      <= `MEM_BYTE;
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_LH_OP: begin
                    mem_sel_o      <= `MEM_HALF;
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_LW_OP: begin
                    mem_sel_o      <= `MEM_WORD;
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_LBU_OP: begin
                    mem_sel_o      <= `MEM_BYTE;
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b1;
                end
                `EXE_LHU_OP: begin
                    mem_sel_o      <= `MEM_HALF;
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b1;
                end
                default: begin
                    mem_we_o       <= `WriteDisable;
                    stallreq_mem_o <= 1'b0;
                end
            endcase
        end
    end
    
    reg [4:0] stage_write;
    wire [`MemDataBus] byte_write_1;
    wire [`MemDataBus] byte_write_2;
    wire [`MemDataBus] byte_write_3;
    wire [`MemDataBus] byte_write_4;
    wire [`MemAddrBus] byte_addr_1;
    wire [`MemAddrBus] byte_addr_2;
    wire [`MemAddrBus] byte_addr_3;
    wire [`MemAddrBus] byte_addr_4;
    
    assign byte_write_1 = mem_reg2_i[7:0];
    assign byte_write_2 = mem_reg2_i[15:8];
    assign byte_write_3 = mem_reg2_i[23:16];
    assign byte_write_4 = mem_reg2_i[31:24];
    assign byte_addr_1  = mem_addr_i;
    assign byte_addr_2  = mem_addr_i + 1;
    assign byte_addr_3  = mem_addr_i + 2;
    assign byte_addr_4  = mem_addr_i + 3;
    
    always @ ( * ) begin
        if (rst) begin
            stallreq_mem_o           <= 1'b0;
        end else begin
            if (mem_done) begin
                stallreq_mem_o       <= 1'b0;
            end else if (!mem_done) begin
                stallreq_mem_o      <= mem_operation;
            end
        end
    end


    always @(*) begin
        if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_o == 1'b1) begin
            mem_we_o <= `WriteEnable;
            case (stage_write)
                5'b00000: begin
                    mem_addr_o       <= byte_addr_1;
                    mem_write_byte_o <= byte_write_1;
                    if (mem_sel_o == `MEM_BYTE) begin
                        stallreq_mem_o <= 1'b0;
                        stage_write    <= 5'b00000;
                        mem_done <= 1'b1;
                        end else begin
                            stage_write    <= 5'b00001;
                            stallreq_mem_o <= 1'b1;
                        end
                    end
                    5'b00001: begin
                        mem_addr_o       <= byte_addr_2;
                        mem_write_byte_o <= byte_write_2;
                        if (mem_sel_o == `MEM_HALF) begin
                            stallreq_mem_o <= 1'b0;
                            stage_write    <= 5'b00000;
                            end else begin
                                stage_write    <= 5'b00010;
                                stallreq_mem_o <= 1'b1;
                            end
                        end
                        5'b00010: begin
                            mem_addr_o       <= byte_addr_3;
                            mem_write_byte_o <= byte_write_3;
                            stage_write      <= 5'b00011;
                            stallreq_mem_o   <= 1'b1;
                        end
                        5'b00011: begin
                            mem_addr_o       <= byte_addr_4;
                            mem_write_byte_o <= byte_write_4;
                            stage_write      <= 5'b00000;
                            stallreq_mem_o   <= 1'b0;
                        end
                        default: ;
            endcase
            end else begin
            stage_write      <= {5{1'b0}};
            mem_write_byte_o <= `ZeroByte;
        end
    end
    
    reg [4:0] stage_read;
    reg [`MemDataBus] byte_read_1;
    reg [`MemDataBus] byte_read_2;
    reg [`MemDataBus] byte_read_3;
    reg [`MemDataBus] byte_read_4;
    
    always @(*) begin
        if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_o == 1'b0) begin
            mem_we_o <= `WriteDisable;
            case (stage_read)
                5'b00000: begin
                    mem_addr_o     <= byte_addr_1;
                    stallreq_mem_o <= 1'b1;
                end
                5'b00001: begin
                    mem_addr_o     <= byte_addr_2;
                    stallreq_mem_o <= 1'b1;
                end
                5'b00010: begin
                    mem_addr_o     <= byte_addr_3;
                    stallreq_mem_o <= 1'b1;
                end
                5'b00011: begin
                    mem_addr_o     <= byte_addr_4;
                    stallreq_mem_o <= 1'b1;
                end
                default: ;
            endcase
            end else begin
            stage_read  <= {5{1'b0}};
            wdata_o     <= mem_data_i;
            byte_read_1 <= `ZeroByte;
            byte_read_2 <= `ZeroByte;
            byte_read_3 <= `ZeroByte;
            byte_read_4 <= `ZeroByte;
        end
    end
endmodule
