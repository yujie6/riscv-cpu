`include "./defines.v"
module mem(input wire rst,
           input wire clk,
           input wire [`RegAddrBus] rd_i,
           input wire [`RegBus] wdata_i,
           input wire [`InstAddrBus] pc_i,
           input wire wreg_i,
           input wire memdone_rst_i,
           input wire [`RegBus] mem_reg2_i,           // data from rs2
           input wire [`MemAddrBus] mem_addr_i,
           input wire [`MemDataBus] mem_read_byte_i,  // data read from memory
           input wire [`AluOpBus] aluop_i,
           input wire [`AluSelBus] alusel_i,
           input wire [`MemSelBus] mem_sel_i,
           input wire mem_we_i,
           input wire mem_load_sign_i,
           output reg [`MemAddrBus] mem_addr_o,       // data addr send to memory
           output wire [`InstAddrBus] pc_o,
           output reg mem_we_o,                       // write or not
           output reg [`MemSelBus] mem_sel_o,         // Byte | Half Word | Word
           output reg [`MemDataBus] mem_write_byte_o, // this is rs2 send to memory
           output reg [`RegAddrBus] rd_o,
           output reg [`RegBus] wdata_o,              // data send to rd
           output wire stallreq_mem_o,
           output reg wreg_o);
    
    assign pc_o = pc_i;
    reg mem_done;
    reg [`MemAddrBus] mem_addr_write;
    reg [`MemAddrBus] mem_addr_read;

    always @(*) begin
        if (rst == `RstEnable) begin
            rd_o             <= `NOPRegAddr;
            wdata_o          <= `ZeroWord;
            wreg_o           <= `WriteDisable;
            mem_sel_o        <= `MEM_NOP;
            mem_addr_o <= `ZeroWord;
            end else begin
            mem_addr_o <= (mem_we_i == 1'b1) ? mem_addr_write : mem_addr_read; 
            rd_o     <= rd_i;
            wreg_o   <= wreg_i;
            mem_sel_o <= mem_sel_i;
            if (alusel_i == `EXE_RES_LOAD_STORE && mem_we_i == 1'b0) begin
                // NOTE: Deal with result of load
                if (mem_sel_i == `MEM_BYTE) begin
                    if (mem_load_sign_i) begin
                        wdata_o <= $signed({{24{byte_read_1[7]}}, byte_read_1});
                        end else begin
                        wdata_o <= {{24{1'b0}}, byte_read_1};
                    end
                    end else if (mem_sel_i == `MEM_HALF) begin
                    if (mem_load_sign_i) begin
                        wdata_o <= $signed({{16{byte_read_2[7]}}, byte_read_2, byte_read_1});
                        end else begin
                        wdata_o <= {{16{1'b0}}, byte_read_2, byte_read_1};
                    end
                    end else if (mem_sel_i == `MEM_WORD) begin
                    wdata_o <= {byte_read_4, byte_read_3, byte_read_2, byte_read_1};
                    end else begin
                    wdata_o <= `ZeroWord;
                end
                end else begin
                wdata_o <= wdata_i;
            end
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
    
    reg mem_read_done;
    reg [4:0] stage_read;
    reg [`MemDataBus] byte_read_1;
    reg [`MemDataBus] byte_read_2;
    reg [`MemDataBus] byte_read_3;
    reg [`MemDataBus] byte_read_4;

    assign byte_write_1 = mem_reg2_i[7:0];
    assign byte_write_2 = mem_reg2_i[15:8];
    assign byte_write_3 = mem_reg2_i[23:16];
    assign byte_write_4 = mem_reg2_i[31:24];
    assign byte_addr_1  = mem_addr_i;
    assign byte_addr_2  = mem_addr_i + 1;
    assign byte_addr_3  = mem_addr_i + 2;
    assign byte_addr_4  = mem_addr_i + 3;

    wire req_mem_write, req_mem_read, req_mem;
    assign req_mem_write = (mem_done && !memdone_rst_i) ? 1'b0 : alusel_i == `EXE_RES_LOAD_STORE;
    assign req_mem_read = (mem_read_done && !memdone_rst_i) ? 1'b0 : alusel_i == `EXE_RES_LOAD_STORE;
    assign req_mem = mem_we_i ? req_mem_write : req_mem_read;
    assign stallreq_mem_o = rst ? 1'b0 : req_mem;

    // always @ (*) begin
    //     if (rst) begin
    //         stallreq_mem_o <= 1'b0;
    //         end else begin
    //         stallreq_mem_o <= req_mem;
    //         // if (mem_we_i) begin
    //         //     if (mem_done) begin // || mem_read_done
    //         //         stallreq_mem_o <= 1'b0;
    //         //     end else begin
    //         //         stallreq_mem_o <= 
    //         //         alusel_i == `EXE_RES_LOAD_STORE;
    //         //     end
    //         // end else begin
    //         //     if (mem_read_done) begin
    //         //         stallreq_mem_o <= 1'b0;
    //         //     end else begin
    //         //         stallreq_mem_o <= 
    //         //         alusel_i == `EXE_RES_LOAD_STORE;
    //         //     end
    //         // end
    //     end
    // end
    
<<<<<<< HEAD
    // always @(pc_i) begin
    //     mem_done <= 1'b0;
    //     mem_read_done <= 1'b0;
    // end
    reg [`InstAddrBus] OldPC_write, OldPC_read;
=======
    always @(pc_i) begin
        // mem_done <= 1'b0;
        // mem_read_done <= 1'b0;
    end
>>>>>>> 20baedcbd3fc741cad0add7d1a812dc06f3aa152
    
    reg [`InstAddrBus] OldPC_write, OldPC_read;
    
    // There shall be some kind of delay
    always @(posedge clk) begin
        // if (pc_i != OldPC_write && rst == `RstDisable) begin
        //         OldPC_write <= pc_i;
        //         mem_done <= 1'b0;
        // end
        if (memdone_rst_i == 1'b1) mem_done <= 1'b0;

        if (rst) begin
            OldPC_write <= pc_i;
            mem_we_o <= `WriteDisable;
            mem_addr_write <= `ZeroWord;
<<<<<<< HEAD
        end
        else begin
            if (pc_i != OldPC_write) begin
                OldPC_write <= pc_i;
                mem_done <= 1'b0;
            end
        if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b1) begin
=======
        end else if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b1) begin
>>>>>>> 20baedcbd3fc741cad0add7d1a812dc06f3aa152
            mem_we_o  <= `WriteEnable;
            case (stage_write)
                5'b00000: begin
                    mem_addr_write      <= byte_addr_1;
                    mem_write_byte_o <= byte_write_1;
                    stage_write      <= 5'b00001;
                    //$display("mem store start!");
                end
                5'b00001: begin
                    if (mem_sel_o == `MEM_BYTE) begin
                        mem_done    <= 1'b1;
                        stage_write <= 5'b00000;
                        mem_we_o    <= `WriteDisable;
                        // NOTE: Remember to reset mem_addr_o, or the hci cannot stop
                        mem_addr_write <= `ZeroWord;
                        //$display("mem done");
                    end
                    else begin
                        mem_addr_write       <= byte_addr_2;
                        mem_write_byte_o <= byte_write_2;
                        stage_write      <= 5'b00010;
                    end
                end
                
                5'b00010: begin
                    mem_addr_write       <= byte_addr_3;
                    mem_write_byte_o <= byte_write_3;
                    if (mem_sel_o == `MEM_HALF) begin
                        mem_done    <= 1'b1;
                        stage_write <= 5'b00000;
                        mem_we_o    <= `WriteDisable;
                        mem_addr_write <= `ZeroWord;
                    end
                    else begin
                        stage_write <= 5'b00011;
                    end
                end
                5'b00011: begin
                    mem_addr_write       <= byte_addr_4;
                    mem_write_byte_o <= byte_write_4;
                    stage_write      <= 5'b00100;
                end
                5'b00100: begin
                    if (mem_sel_o == `MEM_WORD) begin
                        mem_done    <= 1'b1;
                        stage_write <= 5'b00000;
                        mem_we_o    <= `WriteDisable;
                        mem_addr_write <= `ZeroWord;
                    end
                    else begin
                        stage_write <= 5'b00101;
                    end
                end
                default: begin
                    
                end
            endcase
            end else begin
            stage_write      <= {5{1'b0}};
            mem_write_byte_o <= `ZeroByte;
<<<<<<< HEAD
            if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b0 && !mem_read_done) begin
                mem_we_o  <= `WriteDisable;    
            end
        end
=======
            // if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b0 && !mem_read_done) begin
            //     mem_we_o  <= `WriteDisable;    
            // end
            mem_we_o <= `WriteDisable;
>>>>>>> 20baedcbd3fc741cad0add7d1a812dc06f3aa152
        end 
    end
    
    
    
    always @(posedge clk) begin
<<<<<<< HEAD
        if (rst) begin
            OldPC_read <= pc_i;
            mem_addr_read <= `ZeroWord;
        end else begin
            if (pc_i != OldPC_read) begin
                OldPC_read <= pc_i;
                mem_read_done <= 1'b0;
            end
        if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b0 && !mem_read_done) begin
=======
        if (pc_i != OldPC_read && rst == `RstDisable) begin
                OldPC_read <= pc_i;
                mem_read_done <= 1'b0;
        end
        
        if (rst) begin
            OldPC_read <= pc_i;
            mem_addr_read <= `ZeroWord;
        end else if (rst == `RstDisable && stallreq_mem_o == 1'b1 && mem_we_i == 1'b0) begin
>>>>>>> 20baedcbd3fc741cad0add7d1a812dc06f3aa152
            // $display("load start", mem_addr_i);
            // load takes 2 cycle
            case (stage_read)
                5'b00000: begin
                    mem_addr_read <= byte_addr_1;
                    stage_read <= 5'b00001;
                end
                5'b00001: begin
                    mem_addr_read <= byte_addr_2;
                    stage_read <= 5'b00010;
                end
                5'b00010: begin
                    mem_addr_read  <= byte_addr_3;
                    byte_read_1 <= mem_read_byte_i;
                    if (mem_sel_o == `MEM_BYTE) begin
                        mem_read_done <= 1'b1;
                        stage_read    <= 5'b00000;
                        mem_addr_read <= `ZeroWord;
                    end
                    else begin
                        stage_read <= 5'b00011;
                    end
                end
                5'b00011: begin
                    mem_addr_read  <= byte_addr_4;
                    byte_read_2 <= mem_read_byte_i;
                    if (mem_sel_o == `MEM_HALF) begin
                        mem_read_done <= 1'b1;
                        stage_read    <= 5'b00000;
                        mem_addr_read <= `ZeroWord;
                    end
                    stage_read <= 5'b00100;
                end
                5'b00100: begin
                    byte_read_3 <= mem_read_byte_i;
                    stage_read  <= 5'b00101;
                end
                5'b00101: begin
                    byte_read_4   <= mem_read_byte_i;
                    mem_read_done <= 1'b1;
                    stage_read    <= 5'b00000;
                    mem_addr_read <= `ZeroWord;
                end
                default: ;
            endcase
            end else begin
            stage_read    <= {5{1'b0}};
        end
        end
    end
    
endmodule
