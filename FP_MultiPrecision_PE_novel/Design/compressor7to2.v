`timescale 1ns / 1ps

module ele7to2(I0, I1, I2, I3, I4, I5, I6, Cin1, Cin2, Cout1, Cout2, Sum, Carry);
    input I0, I1, I2, I3, I4, I5, I6, Cin1, Cin2;
    output Cout1, Cout2, Sum, Carry;
    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15, w16, w17, w18, w19, w20, PA, PB, S, A, B, C, D;
    
    assign w1 = I0^I1;                  //1
    assign w2 = I2^I3;                  //2
    assign PA = w1^w2;                  //3
    assign w3 = I4^I5;                  //4
    assign PB = w3^I6;                  //5
    assign S = PA^PB;                   //6
    assign w4 = Cin1^S;                 //7
    assign Sum = w4^Cin2;               //8  
    
    assign w5 = Cin1^S;                 //9
    assign w6 = ~(w5&Cin2);             //10
    assign w7 = ~(Cin1&S);              //11
    assign Carry = ~(w6&w7);            //12
    
    assign w15 = ~(I0&I1);              //13
    assign w16 = ~(I2&I3);              //14
    assign w19 = w15&w16;               //15
    assign w17 = ~(I0|I1);              //16
    assign w18 = ~(I2|I3);              //17
    assign w20 = w17|w18;               //18
    assign A = ~(w19&w20);              //19
    
    assign w10 = ~(I0&I1&I2&I3);        //20
    assign w11 = ~(PA&PB);              //21
    assign C = ~(w10&w11);              //22
    
    assign w12 = I5|I4;                 //23
    assign w13 = ~(w12&I6);             //24
    assign w14 = ~(I4&I5);              //25
    assign B = ~(w13&w14);              //26
    
    assign D = A^B;                     //27
    assign w8 = ~(D&C);                 //28
    assign w9 = ~(A&B);                 //29
    assign Cout2 = ~(w8&w9);            //30
    
    assign Cout1 = D^C;                 //31
        
endmodule



module compressor7to2(input [23:0]P0, input [23:0]P1, input [23:0]P2, input [23:0]P3, input [23:0]P4, input [23:0]P5, input [23:0]P6,
                      output [23:0]carry, output [23:0]sum);
    
    wire gnd;
    wire [23:0]Cout1, Cout2;
    
    assign gndd = 1'b0;
    
    ele7to2 u0(P0[0], P1[0], P2[0], P3[0], P4[0], P5[0], P6[0], gndd, gndd, Cout1[0], Cout2[0], sum[0], carry[0]);
    ele7to2 u1(P0[1], P1[1], P2[1], P3[1], P4[1], P5[1], P6[1], gndd, Cout1[0], Cout1[1], Cout2[1], sum[1], carry[1]);
    ele7to2 u2(P0[2], P1[2], P2[2], P3[2], P4[2], P5[2], P6[2], Cout2[0], Cout1[1], Cout1[2], Cout2[2], sum[2], carry[2]);
    ele7to2 u3(P0[3], P1[3], P2[3], P3[3], P4[3], P5[3], P6[3], Cout2[1], Cout1[2], Cout1[3], Cout2[3], sum[3], carry[3]);
    ele7to2 u4(P0[4], P1[4], P2[4], P3[4], P4[4], P5[4], P6[4], Cout2[2], Cout1[3], Cout1[4], Cout2[4], sum[4], carry[4]);
    ele7to2 u5(P0[5], P1[5], P2[5], P3[5], P4[5], P5[5], P6[5], Cout2[3], Cout1[4], Cout1[5], Cout2[5], sum[5], carry[5]);
    ele7to2 u6(P0[6], P1[6], P2[6], P3[6], P4[6], P5[6], P6[6], Cout2[4], Cout1[5], Cout1[6], Cout2[6], sum[6], carry[6]);
    ele7to2 u7(P0[7], P1[7], P2[7], P3[7], P4[7], P5[7], P6[7], Cout2[5], Cout1[6], Cout1[7], Cout2[7], sum[7], carry[7]);
    ele7to2 u8(P0[8], P1[8], P2[8], P3[8], P4[8], P5[8], P6[8], Cout2[6], Cout1[7], Cout1[8], Cout2[8], sum[8], carry[8]);
    ele7to2 u9(P0[9], P1[9], P2[9], P3[9], P4[9], P5[9], P6[9], Cout2[7], Cout1[8], Cout1[9], Cout2[9], sum[9], carry[9]);
    ele7to2 u10(P0[10], P1[10], P2[10], P3[10], P4[10], P5[10], P6[10], Cout2[8], Cout1[9], Cout1[10], Cout2[10], sum[10], carry[10]);
    ele7to2 u11(P0[11], P1[11], P2[11], P3[11], P4[11], P5[11], P6[11], Cout2[9], Cout1[10], Cout1[11], Cout2[11], sum[11], carry[11]);
    ele7to2 u12(P0[12], P1[12], P2[12], P3[12], P4[12], P5[12], P6[12], Cout2[10], Cout1[11], Cout1[12], Cout2[12], sum[12], carry[12]);
    ele7to2 u13(P0[13], P1[13], P2[13], P3[13], P4[13], P5[13], P6[13], Cout2[11], Cout1[12], Cout1[13], Cout2[13], sum[13], carry[13]);
    ele7to2 u14(P0[14], P1[14], P2[14], P3[14], P4[14], P5[14], P6[14], Cout2[12], Cout1[13], Cout1[14], Cout2[14], sum[14], carry[14]);
    ele7to2 u15(P0[15], P1[15], P2[15], P3[15], P4[15], P5[15], P6[15], Cout2[13], Cout1[14], Cout1[15], Cout2[15], sum[15], carry[15]);
    ele7to2 u16(P0[16], P1[16], P2[16], P3[16], P4[16], P5[16], P6[16], Cout2[14], Cout1[15], Cout1[16], Cout2[16], sum[16], carry[16]);
    ele7to2 u17(P0[17], P1[17], P2[17], P3[17], P4[17], P5[17], P6[17], Cout2[15], Cout1[16], Cout1[17], Cout2[17], sum[17], carry[17]);
    ele7to2 u18(P0[18], P1[18], P2[18], P3[18], P4[18], P5[18], P6[18], Cout2[16], Cout1[17], Cout1[18], Cout2[18], sum[18], carry[18]);
    ele7to2 u19(P0[19], P1[19], P2[19], P3[19], P4[19], P5[19], P6[19], Cout2[17], Cout1[18], Cout1[19], Cout2[19], sum[19], carry[19]);
    ele7to2 u20(P0[20], P1[20], P2[20], P3[20], P4[20], P5[20], P6[20], Cout2[18], Cout1[19], Cout1[20], Cout2[20], sum[20], carry[20]);
    ele7to2 u21(P0[21], P1[21], P2[21], P3[21], P4[21], P5[21], P6[21], Cout2[19], Cout1[20], Cout1[21], Cout2[21], sum[21], carry[21]);
    ele7to2 u22(P0[22], P1[22], P2[22], P3[22], P4[22], P5[22], P6[22], Cout2[20], Cout1[21], Cout1[22], Cout2[22], sum[22], carry[22]);
    ele7to2 u23(P0[23], P1[23], P2[23], P3[23], P4[23], P5[23], P6[23], Cout2[21], Cout1[22], Cout1[23], Cout2[23], sum[23], carry[23]);
    
endmodule
