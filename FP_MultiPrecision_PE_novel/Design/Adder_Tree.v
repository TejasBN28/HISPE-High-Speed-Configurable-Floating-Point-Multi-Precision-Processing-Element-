`timescale 1ns / 1ps

module ele4to2(input P0, input P1, input P2, input P3, input carry_in, output carry_out, output carry, output sum);
    wire w1, w2, w3;
    assign w1 = P1^P0;
    assign w2 = P2^P3;
    assign w3 = w1^w2;
    assign sum = w3^carry_in;
    assign carry = w3 ? carry_in : P0;
    assign carry_out = w2 ? P1 : P3;   
endmodule

module ele3to2(input P0, input P1, input P2, input carry_in, output carry_out, output carry, output sum);
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11;
    assign w1 = ~P0;
    assign w2 = ~P1;
    assign w3 = ~P2;
    assign w4 = P2 & P1;
    assign w5 = P1 & P0;
    assign w6 = P0 & P2;
    assign w7 = w3 & P0;
    assign w8 = P1 & w1;
    assign w9 = P2 & w2;
    assign w10 = w4 | w5 | w6;
    assign w11 = w7 | w8 | w9;
    assign carry = carry_in ? w11 : w10;
    assign carry_out = P2 & P1 & P0 & carry_in;
    assign sum = P2 ^ P1 ^ P0 ^ carry_in;
endmodule

module compressor3to2ATL4(input [65:0]P0, input [65:0]P1, input [65:0]P2, output [65:0]carry, output [65:0]sum);
    wire [66:0]carry_in;
    assign carry_in[0] = 0;
    genvar i;
    generate 
        for(i=0; i<66; i=i+1)
        begin
            ele3to2 inst(.P0(P0[i]), .P1(P1[i]), .P2(P2[i]), .carry_in(carry_in[i]), .carry_out(carry_in[i+1]), .carry(carry[i]), .sum(sum[i]));
        end
    endgenerate 
endmodule

module compressor3to2ATL2(input [63:0]P0, input [63:0]P1, input [63:0]P2, output [63:0]carry, output [63:0]sum);
    wire [64:0]carry_in;
    assign carry_in[0] = 0;
    genvar i;
    generate 
        for(i=0; i<64; i=i+1)
        begin
            ele3to2 inst(.P0(P0[i]), .P1(P1[i]), .P2(P2[i]), .carry_in(carry_in[i]), .carry_out(carry_in[i+1]), .carry(carry[i]), .sum(sum[i]));
        end
    endgenerate 
endmodule

module compressor4to2ATL1(input [62:0]P0, input [62:0]P1, input [62:0]P2, input [62:0]P3, output [62:0]carry, output [62:0]sum);
    wire [63:0]carry_in;
    assign carry_in[0] = 0;
    genvar i;
    generate 
        for(i=0; i<63; i=i+1)
        begin
            ele4to2 inst(.P0(P0[i]), .P1(P1[i]), .P2(P2[i]), .P3(P3[i]), .carry_in(carry_in[i]), .carry_out(carry_in[i+1]), .carry(carry[i]), .sum(sum[i]));
        end
    endgenerate   
endmodule

module compressor4to2ATL3(input [64:0]P0, input [64:0]P1, input [64:0]P2, input [64:0]P3, output [64:0]carry, output [64:0]sum);
    wire [65:0]carry_in;
    assign carry_in[0] = 0;
    genvar i;
    generate 
        for(i=0; i<65; i=i+1)
        begin
            ele4to2 inst(.P0(P0[i]), .P1(P1[i]), .P2(P2[i]), .P3(P3[i]), .carry_in(carry_in[i]), .carry_out(carry_in[i+1]), .carry(carry[i]), .sum(sum[i]));
        end
    endgenerate   
endmodule

module complement2s(sum, usum);
    input[65:0]sum;
    output [65:0]usum;
    wire [65:0]check;
    
    assign usum[0] = sum[0];
    assign check[0] = sum[0];
    genvar i;
    generate
        for(i=1; i<66; i = i+1)
        begin
            assign usum[i] = check[i-1]?(~sum[i]):sum[i];
            assign check[i] = check[i-1]|sum[i];
        end 
    endgenerate
endmodule


module Adder_Tree(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, acc_in, mode, clk_cntr, sign64, sum, sign);
    input [62:0]n1, n2, n3, n4, n7, n8, n9, n10;
    input [63:0]n5, n6;
    input [65:0]acc_in;
    input [2:0]mode;
    input clk_cntr, sign64;
    output [65:0]sum;
    output reg sign;
    
    wire [62:0]s1_inter, c1_inter, s2_inter, c2_inter;
    wire [63:0]s1, c1, s2, c2;
    wire [63:0]s3_inter, c3_inter, s4_inter, c4_inter;
    wire [64:0]s3, c3, s4, c4;
    wire [64:0]s5_inter, c5_inter;
    wire [65:0]s5, c5;
    wire [65:0] s6_inter, c6_inter;
    wire [65:0] s6, c6;
    
    
    assign s1 = {s1_inter[62], s1_inter};
    assign s2 = {s2_inter[62], s2_inter};
    assign c1 = {c1_inter, 1'b0};
    assign c2 = {c2_inter, 1'b0}; 
    
    assign s3 = {s3_inter[63], s3_inter};
    assign s4 = {s4_inter[63], s4_inter};
    assign c3 = {c3_inter, 1'b0};
    assign c4 = {c4_inter, 1'b0};
    
    assign s5 = {s5_inter[64], s5_inter};
    assign c5 = {c5_inter, 1'b0};
    
    assign s6 = s6_inter; //
    assign c6 = c6_inter << 1;
    
    compressor4to2ATL1 CS1(n1, n2, n3, n4, c1_inter, s1_inter);
    compressor4to2ATL1 CS2(n7, n8, n9, n10, c2_inter, s2_inter);
    compressor3to2ATL2 CS3(s1, c1, n5, c3_inter, s3_inter);
    compressor3to2ATL2 CS4(n6, s2, c2, c4_inter, s4_inter);      
    compressor4to2ATL3 CS5(s3, c3, s4, c4, c5_inter, s5_inter);
    compressor3to2ATL4 CS6(s5, c5, acc_in, c6_inter, s6_inter);
    
    csla a4(s6, c6, sum);

    always@(*)
    begin
        if(mode == 3'b000)
        begin
            sign = sum[65];
        end
        else if(mode == 3'b011)
        begin
            sign = sum[65];
        end
        else if(mode == 3'b100)
        begin
            sign = sum[65];
        end
        else if(mode == 3'b001)
        begin
            if(clk_cntr == 1'b0)
            begin
                sign = sum[65];
            end
            else
            begin
                sign = sum[65];
            end
        end
        else
        begin
            sign = sign64;
        end
    end
endmodule


module data_selector(input [65:0]sum, output [65:0]final_sum);
    wire [65:0]usum;
    complement2s a5(sum, usum);
    assign final_sum = sum[65]?usum:sum;
endmodule
