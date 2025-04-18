module Product(
    input ALU_carry,
    input [31:0] ALU_result,
    input [31:0] Multiplier_in,
    input W_ctrl,
    input clk,
    output reg [63:0] Product_out
);
    // Set Product_out ------------------------------------------------------------------------------
    always @(posedge clk) begin
        if(W_ctrl) Product_out <= {ALU_carry,ALU_result,Product_out[31:1]};
        else Product_out <= {32'd0,Multiplier_in}; // Include Reset and else condition
    end
    
endmodule