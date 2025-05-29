module MEM_WB(
    input clk,
    // Control Signal input
    input Reg_w_in,
    input Mem_to_reg_in,
    // Others input
    input [31:0] ALU_Result_in,
    input [31:0] MemReadData_in,
    input [4:0] RdAddr_in,
    // Control Signal output 
    output reg Reg_w_out,
    output reg Mem_to_reg_out,
     // Others output
    output reg [31:0] ALU_Result_out,
    output reg [31:0] MemReadData_out,
    output reg [4:0] RdAddr_out
);

    always @(posedge clk) begin
        Reg_w_out <= Reg_w_in;
        Mem_to_reg_out <= Mem_to_reg_in;
        ALU_Result_out <= ALU_Result_in;
        MemReadData_out <= MemReadData_in;
        RdAddr_out <= RdAddr_in;
    end
endmodule