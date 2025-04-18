module Control(
    input Run,
    input Reset,
    input clk,
    output W_ctrl,
    output Ready
);
    // Set Register -------------------------------------
    reg [4:0] cnt;
    
    // Assignment ---------------------------------------
    assign Ready = (cnt==5'd31)? 1'b1 : 1'b0;
    assign W_ctrl = (Reset)? 1'b0 : 1'b1;
    
    // Set Counter ---------------------------------------
    always @(posedge clk) begin
        cnt <= (Run)? cnt + 5'd1 : 5'd0;
    end
    
endmodule


