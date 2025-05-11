`define ADD 6'b001001
`define SUB 6'b001010
`define SHIFT 6'b100001
`define OR 6'b100101

module ALU(
    //Input
    input wire [31:0] Rs_Data,
    input wire [31:0] Rt_Data,
    input wire [4:0] shamt,
    input wire [5:0] funct,
    //Output
    output reg [31:0] Rd_Data,
    output Zero_Flag
);
    
    always @(*) begin
        case(funct)
            `ADD: Rd_Data = Rs_Data + Rt_Data;
            `SUB: Rd_Data = Rs_Data - Rt_Data;
            `SHIFT: Rd_Data = Rs_Data << shamt; 
            `OR: Rd_Data = Rs_Data | Rt_Data; 
            default:;
        endcase
    end
    assign Zero_Flag = (Rd_Data==32'd0);

endmodule
