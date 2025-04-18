module Remainder(
    input [31:0] ALU_result,
    input [31:0] Dividend_in,
    input W_ctrl,
    input clk,
    input Carry,
    output reg [63:0] Remainder_out
);
    
    always @(posedge clk) begin
        if(W_ctrl) begin
            if(Carry) Remainder_out <= {Remainder_out[62:0],1'b0}; // New Remainder < 0
            else Remainder_out <= {ALU_result[30:0],Remainder_out[31:0],1'b1}; // New Remainder >= 0
        end
        else Remainder_out <= {31'd0,Dividend_in,1'd0};
    end
    
endmodule

