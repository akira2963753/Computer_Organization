module ALU_Control(
    //Input
    input [1:0] ALU_OP,
    input [5:0] funct_ctrl,
    //Output
    output reg [5:0] funct
);
    always @(*) begin
        case(ALU_OP)
            2'b00: funct = 6'b001001; // I-Format Add
            2'b01: funct = 6'b001010; // I-Format Sub
            2'b10:begin // R-Format
                case(funct_ctrl)
                    6'b100001: funct = 6'b001001;
                    6'b100011: funct = 6'b001010;
                    6'b000000: funct = 6'b100001;
                    6'b100101: funct = 6'b100101;
                    default:;
                endcase
            end
            2'b11: funct = 6'b100101; // I/J-Format Or
        endcase
    end
endmodule
