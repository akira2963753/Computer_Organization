`define INSTR_MEM_SIZE	128	// Bytes
module IM(
	//Output
    output [31:0] Instr,
	//Input
    input wire [31:0] InstrAddr
);
	reg [7:0]InstrMem[0:`INSTR_MEM_SIZE - 1];
	assign Instr[31:24] = InstrMem[InstrAddr];
    assign Instr[23:16] = InstrMem[InstrAddr+1];
    assign Instr[15:8] = InstrMem[InstrAddr+2];
    assign Instr[7:0] = InstrMem[InstrAddr+3];
endmodule
