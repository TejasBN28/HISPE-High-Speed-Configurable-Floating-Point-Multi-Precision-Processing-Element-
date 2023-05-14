`timescale 1ns / 1ps


module comp(in, zero_flag);
    input [10:0]in;
    output zero_flag;
    
    assign zero_flag = in?1'b0:1'b1;
    
endmodule


module mux2x1(S, I1, I0, out);
    input S;
    input [6:0]I0, I1;
    output [6:0]out;
    assign out = S?I1:I0;
endmodule



module LZD(sum, position);
    input [65:0]sum;
    output [6:0]position;
    
    wire zf1, zf2, zf3, zf4, zf5, zf6;
    wire [6:0]p1, p2, p3, p4, p5, p6;
    wire [6:0]w2, w3, w4, w5;
    
    comp i1(sum[10:0], zf1);
    comp i2(sum[21:11], zf2);
    comp i3(sum[32:22], zf3);
    comp i4(sum[43:33], zf4);
    comp i5(sum[54:44], zf5);
    comp i6(sum[65:55], zf6);
    
    assign p6 =  sum[65]?7'd1:(sum[64]?7'd2:(sum[63]?7'd3:(sum[62]?7'd4:(sum[61]?7'd5:(sum[60]?7'd6:(sum[59]?7'd7:(sum[58]?7'd8:(sum[57]?7'd9:(sum[56]?7'd10:7'd11)))))))));
    assign p5 =  sum[54]?7'd12:(sum[53]?7'd13:(sum[52]?7'd14:(sum[51]?7'd15:(sum[50]?7'd16:(sum[49]?7'd17:(sum[48]?7'd18:(sum[47]?7'd19:(sum[46]?7'd20:(sum[45]?7'd21:7'd22)))))))));
    assign p4 =  sum[43]?7'd23:(sum[42]?7'd24:(sum[41]?7'd25:(sum[40]?7'd26:(sum[39]?7'd27:(sum[38]?7'd28:(sum[37]?7'd29:(sum[36]?7'd30:(sum[35]?7'd31:(sum[34]?7'd32:7'd33)))))))));
    assign p3 =  sum[32]?7'd34:(sum[31]?7'd35:(sum[30]?7'd36:(sum[29]?7'd37:(sum[28]?7'd38:(sum[27]?7'd39:(sum[26]?7'd40:(sum[25]?7'd41:(sum[24]?7'd42:(sum[23]?7'd43:7'd44)))))))));
    assign p2 =  sum[21]?7'd45:(sum[20]?7'd46:(sum[19]?7'd47:(sum[18]?7'd48:(sum[17]?7'd49:(sum[16]?7'd50:(sum[15]?7'd51:(sum[14]?7'd52:(sum[13]?7'd53:(sum[12]?7'd54:7'd55)))))))));
    assign p1 =  sum[10]?7'd56:(sum[9]?7'd57:(sum[8]?7'd58:(sum[7]?7'd59:(sum[6]?7'd60:(sum[5]?7'd61:(sum[4]?7'd62:(sum[3]?7'd63:(sum[2]?7'd64:(sum[1]?7'd65:7'd66)))))))));

    mux2x1 m5(~zf6, p6, w5, position);
    mux2x1 m4(~zf5, p5, w4, w5);
    mux2x1 m3(~zf4, p4, w3, w4);
    mux2x1 m2(~zf3, p3, w2, w3);
    mux2x1 m1(~zf2, p2, p1, w2);
endmodule

