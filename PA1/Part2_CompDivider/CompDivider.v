module CompDivider(
	// Outputs
	output	[31:0]	Quotient,
	output	[31:0]	Remainder,
	output			Ready,
	// Inputs
	input	[31:0]	Dividend,
	input	[31:0]	Divisor,
	input			Run,
	input			Reset,
	input			clk
);
	wire W_ctrl,Carry;
	wire [31:0] Result;
	wire [63:0] Remainder_out; 
	ALU u0(Remainder_out[63:32],Divisor,W_ctrl,Carry,Result);
	Remainder r0(Result,Dividend,W_ctrl,clk,Carry,Remainder_out);
	Control l0(Run,Reset,clk,W_ctrl,Ready);
	// Assignment ----------------------------------------------------------------
	assign {Remainder,Quotient} = {1'b0,Remainder_out[63:33],Remainder_out[31:0]};
	
endmodule


