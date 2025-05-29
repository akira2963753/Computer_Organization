`define ADD 6'b001001
`define SUB 6'b001010
`define SHIFT 6'b100001
`define OR 6'b100101

module ALU(
    //Input
    input wire [31:0] RsData,
    input wire [31:0] RtData,
    input wire [4:0] Shamt,
    input wire [5:0] Funct,
    //Output
    output reg [31:0] RdData
);
    
    always @(*) begin
        case(Funct)
            `ADD: RdData = RsData + RtData;
            `SUB: RdData = RsData - RtData;
            `SHIFT: RdData = RsData << Shamt; 
            //`OR: RdData = RsData | RtData; 
            default: RdData = RsData | RtData;
        endcase
    end
endmodule