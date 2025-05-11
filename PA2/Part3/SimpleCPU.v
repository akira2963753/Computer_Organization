module SimpleCPU(
    //Output
    output reg [31:0] Output_Addr,
    //Input
    input wire [31:0] Input_Addr,
    input wire clk
);
    // Net -------------------------------------------------------------------------------------------------------
    wire [31:0] Instruction,Rs_Data,Rt_Data,ALU_Result,Rd_Data_in,MemReadData;
    wire [31:0] Addr,beq_Addr,Immediate,ALU_Src2;
    wire RegWrite,Reg_dst,Branch;
    wire ALU_src,Mem_w,Mem_r,Mem_to_reg,Jump,Zero_Flag;
    wire [5:0] funct;
    wire [1:0] ALU_OP;
    wire [4:0] Rd_Addr_in;
    wire [31:0] Immediate_shift;

    // Assignment ------------------------------------------------------------------------------------------------
    assign Rd_Addr_in = (Reg_dst)? Instruction[15:11] : Instruction[20:16];
    assign Rd_Data_in = (Mem_to_reg)? MemReadData : ALU_Result;
    assign Immediate = {{16{Instruction[15]}},Instruction[15:0]};
    assign ALU_Src2 = (ALU_src)? Immediate : Rt_Data;
    assign Immediate_shift = {Immediate[29:0],2'd0};

    always @(*) begin
        if(Jump) Output_Addr = {Addr[31:28],Instruction[25:0],2'd0};
        else if(Branch&&Zero_Flag) Output_Addr = beq_Addr;
        else Output_Addr = Addr;
    end

    // Module Connection -----------------------------------------------------------------------------------------
    
    // Adder Module
    assign Addr = Input_Addr + 32'd4;
    Adder Instruction_Adder(Addr,Immediate_shift,beq_Addr);

    // Instruction Memory Module
    IM Instr_Memory(
        .Instr(Instruction),
        .InstrAddr(Input_Addr));

    // Register File Module
    RF Register_File(
        .RsData(Rs_Data),
        .RtData(Rt_Data),
        .RsAddr(Instruction[25:21]),
        .RtAddr(Instruction[20:16]),
        .RdAddr(Rd_Addr_in),
        .RdData(Rd_Data_in),
        .RegWrite(RegWrite),
        .clk(clk));

    // ArithmicLogicUnit Module
    ALU ArithmicLogicUnit(Rs_Data,ALU_Src2,Instruction[10:6],funct,ALU_Result,Zero_Flag);

    // ArithmicLogicUnit Control Module
    ALU_Control ALU_Control_base(ALU_OP,Instruction[5:0],funct);

    // Control Module
    Control Control_base(Instruction[31:26],Reg_dst,Branch,RegWrite,ALU_OP,ALU_src,Mem_w,Mem_r,Mem_to_reg,Jump);

    // Data Memory Module
    DM Data_Memory(
        .MemReadData(MemReadData),
        .MemAddr(ALU_Result),
        .MemWriteData(Rt_Data),
        .MemWrite(Mem_w),
        .MemRead(Mem_r),
        .clk(clk));

endmodule
