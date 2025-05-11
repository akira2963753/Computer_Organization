//======================================================
// 32‑bit Adder ─ 4‑bit Carry‑Look‑Ahead blocks
//======================================================
module Adder (
    input  [31:0] Src_1,
    input  [31:0] Src_2,
    output [31:0] adder_out
);

    wire [7:0] carry;             // 每 4‑bit 區塊的進位

    // 8 個 4‑bit CLA 依序串接
    CLA_4bit cla0 (Src_1[3:0]  , Src_2[3:0]  , 1'b0     , adder_out[3:0]  , carry[0]);
    CLA_4bit cla1 (Src_1[7:4]  , Src_2[7:4]  , carry[0] , adder_out[7:4]  , carry[1]);
    CLA_4bit cla2 (Src_1[11:8] , Src_2[11:8] , carry[1] , adder_out[11:8] , carry[2]);
    CLA_4bit cla3 (Src_1[15:12], Src_2[15:12], carry[2] , adder_out[15:12], carry[3]);
    CLA_4bit cla4 (Src_1[19:16], Src_2[19:16], carry[3] , adder_out[19:16], carry[4]);
    CLA_4bit cla5 (Src_1[23:20], Src_2[23:20], carry[4] , adder_out[23:20], carry[5]);
    CLA_4bit cla6 (Src_1[27:24], Src_2[27:24], carry[5] , adder_out[27:24], carry[6]);
    CLA_4bit cla7 (Src_1[31:28], Src_2[31:28], carry[6] , adder_out[31:28], carry[7]);

endmodule



//======================================================
// 4‑bit Carry‑Look‑Ahead Adder
//======================================================
module CLA_4bit (
    input  [3:0] A,
    input  [3:0] B,
    input        Cin,
    output [3:0] Sum,
    output       Cout
);

    // 單位產生與傳遞
    wire [3:0] G = A & B;     // Generate
    wire [3:0] P = A ^ B;     // Propagate

    // 位元內部進位
    wire [3:0] C;
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & C[0]);
    assign C[2] = G[1] | (P[1] & C[1]);
    assign C[3] = G[2] | (P[2] & C[2]);
    assign Cout = G[3] | (P[3] & C[3]);

    // 求和
    assign Sum = P ^ C;

endmodule
