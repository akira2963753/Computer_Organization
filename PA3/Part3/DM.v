`define DATA_MEM_SIZE	32	// Bytes

module DM ( 
	// Outputs
    output [31:0] MemReadData, 
	// Inputs
    input wire [31:0] MemAddr, 
    input wire [31:0] MemWriteData, 
    input wire MemWrite, 
    input wire clk);

	reg [7:0]DataMem[0:`DATA_MEM_SIZE - 1];

	assign MemReadData = {DataMem[MemAddr], DataMem[MemAddr + 1], DataMem[MemAddr + 2], DataMem[MemAddr + 3]};

    always @(negedge clk) begin
        if(MemWrite) {DataMem[MemAddr],DataMem[MemAddr+1],DataMem[MemAddr+2],DataMem[MemAddr+3]} <= MemWriteData;
        else;
    end

endmodule
