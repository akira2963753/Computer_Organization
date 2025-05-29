module ALU_Control(
    //Input
    input [1:0] ALU_op,
    input [5:0] Funct_ctrl,
    //Output
    output reg [5:0] Funct
);
    always @(*) begin
        case(ALU_op)
            2'b00: Funct = 6'b001001; // I-Format Add
            //2'b01: Funct = 6'b001010; // I-Format Sub
            2'b10:begin // R-Format
                case(Funct_ctrl)
                    6'b100001: Funct = 6'b001001;
                    6'b100011: Funct = 6'b001010;
                    6'b000000: Funct = 6'b100001;
                    //6'b100101: Funct = 6'b100101;
                    default: Funct = 6'b100101;
                endcase
            end
            //2'b11: Funct = 6'b100101; // I-Format Or
            default: Funct = 6'b100101;
        endcase
    end
endmodule