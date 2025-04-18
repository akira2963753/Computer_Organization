`define ADDU  6'b100100
`define SUBU  6'b100011
`define OR  6'b100101
`define SRL  6'b000010
`define SLL  6'b000000

module ALU(
    input [31:0] Src_1,
    input [31:0] Src_2,
    input [4:0] Shamt,
    input [5:0] Funct,
    output reg [31:0] ALU_result,
    output Zero,
    output reg Carry
);
    always @(*) begin
        case(Funct) 
            `ADDU: {Carry,ALU_result} = Src_1 + Src_2;
            `SUBU: begin
                ALU_result = Src_1 - Src_2;
                Carry = (Src_1>=Src_2)? 1'b0:1'b1;
            end
            `OR: {Carry,ALU_result} = (Src_1|Src_2);
            `SRL: {Carry,ALU_result} = Src_1 >> Shamt;
            `SLL: {Carry,ALU_result} = Src_1 << Shamt;
            default:;
        endcase
    end
    assign Zero = (ALU_result==32'b0);
endmodule
