module CompMultiplier(
	// Outputs
	output	[63:0]	Product,
	output		Ready,
	// Inputs
	input	[31:0]	Multiplicand,
	input	[31:0]	Multiplier,
	input		Run,
	input		Reset,
	input		clk
);
	wire W_ctrl,Carry;
	wire [31:0] Result;
	ALU u0(Product[63:32],Multiplicand,Product[0],Carry,Result);
	Product p0(Carry,Result,Multiplier,W_ctrl,clk,Product);
	Control l0(Run,Reset,clk,W_ctrl,Ready);
	
endmodule

