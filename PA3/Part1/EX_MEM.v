module EX_MEM(
    input clk,
    // Control Signal input
    input Reg_w_in,
    input Mem_to_reg_in,
    input Mem_w_in,
    // others input
    input [31:0] ALU_Result_in,
    input [31:0] RtData_in,
    input [4:0] RdAddr_in,
    input [31:0] ISE_in,
    output reg [31:0] ISE_out,
    // Control Singal output
    output reg Reg_w_out,
    output reg Mem_to_reg_out,
    output reg Mem_w_out,
    // others output
    output reg [31:0] ALU_Result_out,
    output reg [31:0] RtData_out,
    output reg [4:0] RdAddr_out   
);
    always @(posedge clk) begin
        ISE_out <= ISE_in;
        Reg_w_out <= Reg_w_in; 
        Mem_to_reg_out <= Mem_to_reg_in;
        Mem_w_out <= Mem_w_in;
        ALU_Result_out <= ALU_Result_in;
        RtData_out <= RtData_in;
        RdAddr_out <= RdAddr_in;      
    end

endmodule