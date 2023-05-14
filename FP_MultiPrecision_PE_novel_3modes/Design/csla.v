`timescale 1ns / 1ps

module ha(a,b,sum,cout);
    input a,b;
    output sum,cout;
    assign sum=a ^ b;
    assign cout=a & b;
endmodule



module pha(a,b,sum1,sum0,cout1,cout0);
    input a,b;
    output sum1,sum0;
    output cout1,cout0;
    assign sum0= a^b;
    assign sum1= ~(a^b);
    assign cout0=a & b;
    assign cout1=a | b;
endmodule



module pfa(a,b,sum1,sum0,cout1,cout0,cin1,cin0);
    input a,b,cin1,cin0;
    output sum1,sum0;
    output cout1,cout0;
    wire s1,s0;
    wire c1,c0;
    
    assign s0= a^b;
    assign s1= ~(a^b);
    assign c0=a & b;
    assign c1=a|b;
    assign cout1=cin1?c1:c0;
    assign cout0=cin0?c1:c0;
    assign sum1=cin1?s1:s0;
    assign sum0=cin0?s1:s0;
endmodule



module rca(a,b,sum,cout);
    input [1:0] a,b;
    output [1:0] sum;
    output cout;
     
    ha a0(a[0],b[0],sum[0],c);
    fa a1(sum[1],cout,a[1],b[1],c);
endmodule



module do_rca(a,b,sum1,sum0,cout1,cout0);
    input [7:0] a,b;
    output [7:0] sum1,sum0;
    output cout1,cout0;
    wire cout01, cout00, cout11, cout10, cout21, cout20, cout30, cout31, cout40, cout41, cout50, cout51, cout60, cout61, cout70, cout71;
    
    pha a0(a[0],b[0],sum1[0],sum0[0],cout01,cout00);
    pfa a1(a[1],b[1],sum1[1],sum0[1],cout11,cout10,cout01,cout00);
    pfa a2(a[2],b[2],sum1[2],sum0[2],cout21,cout20,cout11,cout10);
    pfa a3(a[3],b[3],sum1[3],sum0[3],cout31,cout30,cout21,cout20);
    pfa a4(a[4],b[4],sum1[4],sum0[4],cout41,cout40,cout31,cout30);
    pfa a5(a[5],b[5],sum1[5],sum0[5],cout51,cout50,cout41,cout40);
    pfa a6(a[6],b[6],sum1[6],sum0[6],cout61,cout60,cout51,cout50);
    pfa a7(a[7],b[7],sum1[7],sum0[7],cout71,cout70,cout61,cout60);
    
    assign cout1=cout71;
    assign cout0=cout70;
endmodule


module fa(sum,cout,a,b,cin);
    output sum,cout;
    input a,b,cin;
    assign sum=(a^b)^cin;
    assign cout=((a^b) & cin) | (a & b) ;
endmodule


module csla(a,b,sum);
    input [65:0] a,b;
    output [65:0] sum;
    
    wire [63:0] sum0,sum1;
    wire c2,c10,c18,c26,c34,c42,c50,c58, c10_1, c10_0, c18_1, c18_0, c26_0, c26_1, c34_0, c34_1, c42_0, c42_1, c50_0, c50_1, c58_0, c58_1, c66_0, c66_1;
    
    rca a0(a[1:0],b[1:0],sum[1:0],c2);
    do_rca a1(a[9:2],b[9:2],sum1[7:0],sum0[7:0],c10_1,c10_0);
    do_rca a2(a[17:10],b[17:10],sum1[15:8],sum0[15:8],c18_1,c18_0);
    do_rca a3(a[25:18],b[25:18],sum1[23:16],sum0[23:16],c26_1,c26_0);
    do_rca a4(a[33:26],b[33:26],sum1[31:24],sum0[31:24],c34_1,c34_0);
    do_rca a5(a[41:34],b[41:34],sum1[39:32],sum0[39:32],c42_1,c42_0);
    do_rca a6(a[49:42],b[49:42],sum1[47:40],sum0[47:40],c50_1,c50_0);
    do_rca a7(a[57:50],b[57:50],sum1[55:48],sum0[55:48],c58_1,c58_0);
    do_rca a8(a[65:58],b[65:58],sum1[63:56],sum0[63:56],c66_1,c66_0);
    
    assign sum[9:2]=c2?sum1[7:0]:sum0[7:0];
    assign c10=c2?c10_1:c10_0;
    
    assign sum[17:10]=c10?sum1[15:8]:sum0[15:8];
    assign c18=c10?c18_1:c18_0;
    
    assign sum[25:18]=c18?sum1[23:16]:sum0[23:16];
    assign c26=c18?c26_1:c26_0;
    
    assign sum[33:26]=c26?sum1[31:24]:sum0[31:24];
    assign c34=c26?c34_1:c34_0;
    
    assign sum[41:34]=c34?sum1[39:32]:sum0[39:32];
    assign c42=c34?c42_1:c42_0;
    
    assign sum[49:42]=c42?sum1[47:40]:sum0[47:40];
    assign c50=c42?c50_1:c50_0;
    
    assign sum[57:50]=c50?sum1[55:48]:sum0[55:48];
    assign c58=c50?c58_1:c58_0;

    assign sum[65:58]=c58?sum1[63:56]:sum0[63:56];
endmodule