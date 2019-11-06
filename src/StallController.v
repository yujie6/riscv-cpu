// connect to 4 stage module to control stalls
// Possible Improvement 
// 1. out-of-order execution (renaming...)
// 2. multiple issueing (multiple modules to decode )
// 3. data forwarding 
// 4. Cache memory
`include "./defines.v"

module StallController(
    input wire rst,
    input wire stallreq_ex,
    input wire stallreq_id,
    output reg [5:0] stall
);
    // stall[0] -> stop PC
    // stall[1] -> stop if
    // stall[2] -> stop id
    // stall[3] -> stop ex
    // stall[4] -> stop mem
    // stall[5] -> stop wb
    always @(*) begin
        if (rst == `RstEnable) begin
            stall <= 6'b000000;
        end else if (stallreq_ex == `Stop) begin
            stall <= 6'b001111;
        end else if (stallreq_id == `Stop) begin
            stall <= 6'b000111;
        end else begin
            stall <= 6'b000000;     
        end
    end

endmodule // StallControler