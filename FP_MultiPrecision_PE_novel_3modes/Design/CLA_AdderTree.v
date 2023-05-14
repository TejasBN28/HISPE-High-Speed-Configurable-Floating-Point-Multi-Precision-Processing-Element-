`timescale 1ns / 1ps

module CLA_4bit(input [3:0]a, input [3:0]b, input c0, output [3:0]Sum, output Cout);
    wire P0, P1, P2, P3, G0, G1, G2, G3, c1, c2, c3;
    
    assign P0 = a[0]^b[0];
    assign P1 = a[1]^b[1];
    assign P2 = a[2]^b[2];
    assign P3 = a[3]^b[3];
    
    assign G0 = a[0]&b[0];
    assign G1 = a[1]&b[1];
    assign G2 = a[2]&b[2];
    assign G3 = a[3]&b[3];
    
    assign Sum[0] = P0^c0;
    assign Sum[1] = P1^c1;
    assign Sum[2] = P2^c2;
    assign Sum[3] = P3^c3;
    
    assign c1 = (c0&P0)|G0;
    assign c2 = (c1&P1)|G1;
    assign c3 = (c2&P2)|G2;
    assign Cout = (c3&P3)|G3;
    
endmodule

module CLA_AdderTree(input [23:0]A, input [23:0]B, output [23:0]product);
    wire gndd, c1, c2, c3, c4, c5, c6;
    assign gndd = 1'b0;
    CLA_4bit a1(A[3:0], B[3:0], gndd, product[3:0], c1);
    CLA_4bit a2(A[7:4], B[7:4], c1, product[7:4], c2);
    CLA_4bit a3(A[11:8], B[11:8], c2, product[11:8], c3);
    CLA_4bit a4(A[15:12], B[15:12], c3, product[15:12], c4);
    CLA_4bit a5(A[19:16], B[19:16], c4, product[19:16], c5);
    CLA_4bit a6(A[23:20], B[23:20], c5, product[23:20], c6);
endmodule
