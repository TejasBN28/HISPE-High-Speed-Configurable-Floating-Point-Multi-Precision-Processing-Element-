`timescale 1ns / 1ps


module Alignment_Shifter(input [23:0]n, input [7:0]diff, input [5:0]p_shift, output [60:0]out);
    wire [60:0]num;
    wire [60:0]inter1, inter2;
    assign num = {37'b0, n};
    assign inter1 = num << p_shift;
    assign out = inter1 >> diff;
endmodule 





module complement2ss1(sum, sign, out);
    input[60:0]sum;
    input sign;
    output [60:0]out;
    wire [60:0]usum;
    wire [60:0]check;
    
    assign usum[0] = sum[0];
    assign check[0] = sum[0];
    genvar i;
    generate
        for(i=1; i<61; i = i+1)
        begin
            assign usum[i] = check[i-1]?(~sum[i]):sum[i];
            assign check[i] = check[i-1]|sum[i];
        end 
    endgenerate
    
    assign out = sign?usum:sum;
endmodule