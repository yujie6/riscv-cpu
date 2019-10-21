`timescale 1s/1s

module led (input clk,
            input rst_n,
            output red,
            output green,
            output yellow);
    
    reg[4:0] cnt;
    
    always@(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            cnt <= 8'h00;
            end else begin
            cnt <= cnt + 1'b1;
        end
    end
    
    parameter ST_IDLE = 3'b000;
    parameter ST_R    = 3'b001;
    parameter ST_G    = 3'b010;
    parameter ST_Y    = 3'b100;
    reg[2:0]  status;
    
    always@(posedge clk or negedge rst_n)
    begin
        if (!rst_n) begin
            status <= ST_IDLE;
            end else begin
            case (cnt)
            8'd00: begin status <= ST_G; end
        8'd15: begin status <= ST_Y; end
    8'd18: begin status <= ST_R; end
            endcase
        end
    end
    
    assign red    = (status == ST_R);
    assign green  = (status == ST_G);
    assign yellow = (status == ST_Y);
    
endmodule
