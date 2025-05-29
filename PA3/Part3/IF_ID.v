module IF_ID(
    input clk,
    input IF_ID_write,
    input [31:0] Instr_in,
    output reg [31:0] Instr_out
);

    always @(posedge clk) begin
        if(IF_ID_write) Instr_out <= Instr_in;
        else;
    end
endmodule