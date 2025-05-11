`define REG_MEM_SIZE 32
module RF(
    //Output
    output [31:0] RsData,
    output [31:0] RtData, 
    //Input
    input wire [4:0] RsAddr,
    input wire [4:0] RtAddr,
    input wire [4:0] RdAddr,
    input wire [31:0] RdData,
    input wire RegWrite,
    input wire clk
);
	reg [31:0]R[0:`REG_MEM_SIZE - 1];
    assign RsData = R[RsAddr];
    assign RtData = R[RtAddr];

    always @(negedge clk) begin
        if(RegWrite) R[RdAddr] <= RdData;
        else;
    end
endmodule
