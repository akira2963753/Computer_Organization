module Forwarding_Unit(
    input [4:0] EX_MEMRdAddr,
    input EX_MEMReg_w,
    input [4:0] MEM_WBRdAddr,
    input MEM_WBReg_w,
    input [4:0] RtAddr,
    input [4:0] RsAddr,
    output reg [1:0] Forward_A,
    output reg [1:0] Forward_B
);
    wire load_EX_MEM = (EX_MEMReg_w&&EX_MEMRdAddr!=5'd0);
    wire load_MEM_WB = (MEM_WBReg_w&&MEM_WBRdAddr!=5'd0);
    // EX and MEM Hazard
    always @(*) begin
        if(load_EX_MEM && (EX_MEMRdAddr==RsAddr)) Forward_A = 2'b10;
        else if(load_MEM_WB && (MEM_WBRdAddr==RsAddr)) Forward_A = 2'b01;
        else Forward_A = 2'b00;

        if(load_EX_MEM && (EX_MEMRdAddr==RtAddr)) Forward_B = 2'b10;
        else if(load_MEM_WB && (MEM_WBRdAddr==RtAddr)) Forward_B = 2'b01;
        else Forward_B = 2'b00;
    end
endmodule
