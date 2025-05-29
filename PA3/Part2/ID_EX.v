module ID_EX(
    input clk,
    // Control Signal input
    input Reg_w_in,
    input Mem_to_reg_in,
    input Mem_w_in,
    input Mem_r_in,
    input Reg_dst_in,
    input [1:0] ALU_op_in,
    input ALU_src_in,
    // Data input
    input [31:0] RsData_in,
    input [31:0] RtData_in,
    // Immediate sign extend input
    // Address input
    input [4:0] RtAddr_in,
    input [4:0] RdAddr_in,
    input [4:0] RsAddr_in,
    // Control Signal output
    output reg Reg_w_out,
    output reg Mem_to_reg_out,
    output reg Mem_w_out,
    output reg Mem_r_out,
    output reg Reg_dst_out,
    output reg [1:0] ALU_op_out,
    output reg ALU_src_out,
    // Data output
    output reg [31:0] RsData_out,
    output reg [31:0] RtData_out,
    // Immediate sign extend output
    // Address out
    output reg [4:0] RtAddr_out,
    output reg [4:0] RdAddr_out,
    output reg [4:0] RsAddr_out
);

    always @(posedge clk) begin
        Reg_w_out <= Reg_w_in;
        Mem_to_reg_out <= Mem_to_reg_in;
        Mem_w_out <= Mem_w_in;
        Mem_r_out <= Mem_r_in;
        Reg_dst_out <= Reg_dst_in;
        ALU_op_out <= ALU_op_in;
        ALU_src_out <= ALU_src_in;
        RsData_out <= RsData_in;
        RtData_out <= RtData_in;
        RtAddr_out <= RtAddr_in;
        RdAddr_out <= RdAddr_in;
        RsAddr_out <= RsAddr_in;
    end

endmodule