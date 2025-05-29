module Hazard_Detection_Unit(
    input [4:0] RsAddr,
    input [4:0] RtAddr,
    input [4:0] RdAddr,
    input Mem_r,
    output reg PC_Write = 1'b1
);
    
    always @(*) begin
        if(Mem_r&&((RdAddr==RsAddr)||(RdAddr==RtAddr))) PC_Write = 1'b0;
        else PC_Write = 1'b1;
    end

endmodule

