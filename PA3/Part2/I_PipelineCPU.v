module I_PipelineCPU(
	// Outputs
	output        PC_Write,
	output [31:0] Output_Addr,
	// Inputs
	input  [31:0] Input_Addr,
	input         clk
);
	wire [31:0] Instr,Instr_out;
	wire Reg_w,Mem_to_reg,Mem_w,Mem_r,Reg_dst,ALU_src;
	wire Reg_w1,Mem_to_reg1,Mem_w1,Mem_r1,Reg_dst1,ALU_src1;
	wire Reg_w2,Mem_to_reg2,Mem_w2,Mem_r2,Reg_dst2,ALU_src2;
	wire Reg_w3,Mem_to_reg3,Mem_w3;
	wire Reg_w4,Mem_to_reg4;
	wire [1:0] ALU_op,ALU_op1,ALU_op2;

	wire [31:0] ISE1,ISE2;						
	wire [31:0] RtData,RtData1,RtData2,RtData3;			
	wire [31:0] RsData,RsData1;					
	wire [31:0] RdData;							

	wire [4:0] RdAddr,RdAddr1,RdAddr2,RdAddr3;
	wire [4:0] RsAddr,RsAddr1;
	wire [4:0] RtAddr,RtAddr1;
	wire [31:0] ALU_Result,ALU_Result1,ALU_Result2;
	wire [31:0] MemReadData,MemReadData1;
	wire [1:0] Forward_A,Forward_B;
	wire [31:0] Src_1,Src_2;
	wire [5:0] Funct;

	assign ISE1 = {{16{Instr_out[15]}},Instr_out[15:0]};
	assign RdAddr2 = (Reg_dst2)? RdAddr1 : RtAddr1;
	assign RdData = (Mem_to_reg4)? MemReadData1 : ALU_Result2;
	
	assign Output_Addr = {Input_Addr[31:8],Input_Addr[7:2]+1'b1,2'b00};
	
	// Forward A
	assign Src_1 = (Forward_A==2'b00)? RsData1 : (Forward_A==2'b01)? RdData : ALU_Result1;
	// Forward B
	assign RtData2 = (Forward_B==2'b00)? RtData1 : (Forward_B==2'b01)? RdData : ALU_Result1;

	assign Src_2 = (ALU_src2)? ISE2 : RtData2; 

	assign Reg_w1 = (PC_Write)? Reg_w : 1'b0;
	assign Mem_to_reg1 = (PC_Write)? Mem_to_reg : 1'b0;
	assign Mem_w1 = (PC_Write)? Mem_w : 1'b0;
	assign Mem_r1 = (PC_Write)? Mem_r : 1'b0;
	assign Reg_dst1 = (PC_Write)? Reg_dst : 1'b0;
	assign ALU_op1 = (PC_Write)? ALU_op : 2'b0;
	assign ALU_src1 = (PC_Write)? ALU_src : 1'b0;

	IF_ID stage0(
		.clk(clk),
		.IF_ID_write(PC_Write),
		.Instr_in(Instr),
		.Instr_out(Instr_out));

	ID_EX stage1(
		.clk(clk),
		.Reg_w_in(Reg_w1),
		.Mem_to_reg_in(Mem_to_reg1),
		.Mem_w_in(Mem_w1),
		.Mem_r_in(Mem_r1),
		.Reg_dst_in(Reg_dst1),
		.ALU_op_in(ALU_op1),
		.ALU_src_in(ALU_src1),
		.RsData_in(RsData),
		.RtData_in(RtData),
		.RtAddr_in(Instr_out[20:16]),
		.RdAddr_in(Instr_out[15:11]),
		.RsAddr_in(Instr_out[25:21]),
		.Reg_w_out(Reg_w2),
		.Mem_to_reg_out(Mem_to_reg2),
		.Mem_w_out(Mem_w2),
		.Mem_r_out(Mem_r2),
		.Reg_dst_out(Reg_dst2),
		.ALU_op_out(ALU_op2),
		.ALU_src_out(ALU_src2),
		.RsData_out(RsData1),
		.RtData_out(RtData1),
		.RtAddr_out(RtAddr1),
		.RdAddr_out(RdAddr1),
		.RsAddr_out(RsAddr1));

	EX_MEM stage2(
		.clk(clk),
		.Reg_w_in(Reg_w2),
    	.Mem_to_reg_in(Mem_to_reg2),
		.Mem_w_in(Mem_w2),
		.ALU_Result_in(ALU_Result),
		.RtData_in(RtData2),
		.RdAddr_in(RdAddr2),
		.ISE_in(ISE1),
		.ISE_out(ISE2),
    	.Reg_w_out(Reg_w3),
    	.Mem_to_reg_out(Mem_to_reg3),
     	.Mem_w_out(Mem_w3),
    	.ALU_Result_out(ALU_Result1),
    	.RtData_out(RtData3),
    	.RdAddr_out(RdAddr3));

	MEM_WB stage3(
		.clk(clk),
		.Reg_w_in(Reg_w3),
		.Mem_to_reg_in(Mem_to_reg3),
		.ALU_Result_in(ALU_Result1),
		.MemReadData_in(MemReadData),
		.RdAddr_in(RdAddr3),
		.Reg_w_out(Reg_w4),
		.Mem_to_reg_out(Mem_to_reg4),
		.ALU_Result_out(ALU_Result2),
		.MemReadData_out(MemReadData1),
		.RdAddr_out(RdAddr)
	);

	IM Instr_Memory(
		.Instr(Instr),
		.InstrAddr(Input_Addr));

	RF Register_File(
		.RsData(RsData),
		.RtData(RtData),
		.RsAddr(Instr_out[25:21]),
		.RtAddr(Instr_out[20:16]),
		.RdAddr(RdAddr),
		.RdData(RdData),
		.RegWrite(Reg_w4),
		.clk(clk));

	ALU ArithmicLogicUnit(
		.RsData(Src_1),
		.RtData(Src_2),
		.Shamt(ISE2[10:6]),
		.Funct(Funct),
		.RdData(ALU_Result));
	
	ALU_Control ALU_Control_base(
		.ALU_op(ALU_op2),
		.Funct_ctrl(ISE2[5:0]),
		.Funct(Funct));

	DM Data_Memory(
        .MemReadData(MemReadData),
        .MemAddr(ALU_Result1),
        .MemWriteData(RtData3),
        .MemWrite(Mem_w3),
        .clk(clk));

	Forwarding_Unit FU(
		.EX_MEMRdAddr(RdAddr3),
		.EX_MEMReg_w(Reg_w3),
		.MEM_WBRdAddr(RdAddr),
		.MEM_WBReg_w(Reg_w4),
		.RtAddr(RtAddr1),
		.RsAddr(RsAddr1),
		.Forward_A(Forward_A),
		.Forward_B(Forward_B));	
	
	Hazard_Detection_Unit HDU(
		.RsAddr(Instr_out[25:21]),
		.RtAddr(Instr_out[20:16]),
		.RdAddr(RtAddr1),
		.Mem_r(Mem_r2),
		.PC_Write(PC_Write)
		);
	
	Control Control_Unit(
		.OpCode(Instr_out[31:26]),
		.Reg_dst(Reg_dst),
		.Reg_w(Reg_w),
		.ALU_op(ALU_op),
		.ALU_src(ALU_src),
		.Mem_w(Mem_w),
		.Mem_r(Mem_r),
		.Mem_to_reg(Mem_to_reg));

endmodule
