`define R_Format 6'b000000
`define ADDIU 6'b001001
`define SW 6'b101011
`define LW 6'b100011
`define ORI 6'b001101

module Control(
    //Input
    input [5:0] OpCode,
    //Output
    output reg Reg_dst,
    output reg Reg_w,
    output reg [1:0] ALU_op,
    output reg ALU_src,
    output reg Mem_w,
    output reg Mem_r,
    output reg Mem_to_reg
);
    always @(*) begin   
        case(OpCode)
            `R_Format : begin
                ALU_op = 2'b10;
                Reg_w = 1'b1;
                Reg_dst = 1'b1;
                ALU_src = 1'b0;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;              
            end
            `ADDIU : begin
                ALU_op = 2'b00;
                Reg_w = 1'b1;
                Reg_dst = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
            end
            `ORI : begin
                ALU_op = 2'b11;
                Reg_w = 1'b1;
                Reg_dst = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
            end         
            `SW : begin
                ALU_op= 2'b00;
                Reg_w = 1'b0;
                Reg_dst = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b1;
                Mem_r = 1'b0;
                Mem_to_reg = 1'b0;
            end
            `LW : begin
                ALU_op = 2'b00;
                Reg_w = 1'b1;
                Reg_dst = 1'b0;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b1;
                Mem_to_reg = 1'b1;
            end
            default : begin
                ALU_op = 2'b11;
                Reg_w = 1'b0;
                Reg_dst = 1'b1;
                ALU_src = 1'b1;
                Mem_w = 1'b0;
                Mem_r = 1'b1;
                Mem_to_reg = 1'b1;
            end
            
        endcase
    end

endmodule