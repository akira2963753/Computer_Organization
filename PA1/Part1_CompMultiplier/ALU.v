module ALU(
    input [31:0] Src_1, //Product
    input [31:0] Src_2, //Multiplicand_out
    input Funct,
    output Carry,
    output [31:0] Result
); 
    // Assignment -----------------------------------------
    assign {Carry,Result} = (Funct)? Src_1 + Src_2 : Src_1;

endmodule