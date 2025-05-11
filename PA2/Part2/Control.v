`define R_Format    6'b000000
`define Addi	    6'b001001
`define Sw	        6'b101011
`define Lw	        6'b100011
`define Ori	        6'b001101
`define Beq	        6'b000100
`define Jump	    6'b000010

module Control(
    //Input
    input wire [5:0] OpCode,
    //Output
    output reg Reg_dst,
    output reg Branch,
    output reg RegWrite,
    output reg [1:0] ALU_OP,
    output reg ALU_src,
    output reg Mem_w,
    output reg Mem_r,
    output reg Mem_to_reg,
    output reg Jump
);

    always @(*) begin
        case(OpCode)
            `R_Format: begin // R-Format 6'b000000
                ALU_OP = 2'b10;
                RegWrite = 1'b1;
                Reg_dst = 1'b1;
                Branch = 1'b0;
                ALU_src = 1'b0;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b0;
            end
            `Addi: begin // I-Format Addi 6'b001001
                ALU_OP = 2'b00;
                RegWrite = 1'b1;
                Reg_dst = 1'b0;
                Branch = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b0;               
            end
            `Sw: begin // I-Format Store Word 6'b101011
                ALU_OP = 2'b00;
                RegWrite = 1'b0;
                Reg_dst = 1'b0;
                Branch = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b1;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b0;
            end
            `Lw: begin // I-Format Load Word 6'b100011
                ALU_OP = 2'b00;
                RegWrite = 1'b1;
                Reg_dst = 1'b0;
                Branch = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b1;
                Mem_to_reg = 1'b1;
                Jump = 1'b0;
            end
            `Ori: begin // I-Format Ori 6'b001101
                ALU_OP = 2'b11;
                RegWrite = 1'b1;
                Reg_dst = 1'b0;
                Branch = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b0;
            end
            `Beq: begin // I-Format Beq 6'b000100
                ALU_OP = 2'b01;
                RegWrite = 1'b0;
                Reg_dst = 1'b0;
                Branch = 1'b1;
                ALU_src = 1'b0;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b0;
            end
            `Jump: begin // J-Format Jump 6'b000010
                ALU_OP = 2'b01;
                RegWrite = 1'b0;
                Reg_dst = 1'b0;
                Branch = 1'b0;
                ALU_src = 1'b0;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
                Jump = 1'b1;        
            end
            default: begin
                ALU_OP = 2'b11;
                RegWrite = 1'b0;
                Reg_dst = 1'b1;
                Branch = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b1;
                Mem_to_reg = 1'b1;
                Jump = 1'b0;             
            end
        endcase
    end
endmodule