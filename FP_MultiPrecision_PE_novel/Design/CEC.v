`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 14:51:35
// Design Name: 
// Module Name: CEC
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module three_input_ec(E0,E1,E2,Emax);
    input signed [9:0] E0,E1,E2;
    output reg signed [9:0] Emax;
    reg compare_01,compare_12,compare_20;
    
    always@(*)
    begin
        if(E0<E1)
            compare_01=0;
        else
            compare_01=1;
        if(E1<E2)
            compare_12=0;
        else
            compare_12=1;
        if(E2<E0)
            compare_20=0;
        else
            compare_20=1;    
    end
     
    always@(*)
    begin
       case( {compare_01,compare_12,compare_20} )
           3'b000: Emax=0; 
           3'b001: Emax=E2;
           3'b010: Emax=E1;
           3'b011: Emax=E1;
           3'b100: Emax=E0;
           3'b101: Emax=E2;
           3'b110: Emax=E0;
           3'b111: Emax=E0;
       endcase
    end
endmodule




module four_input_ec(E0,E1,E2,E3,Emax);
    
    input [9:0]E0,E1,E2,E3;
    output reg [9:0]Emax;
    reg compare_01,compare_12,compare_23,compare_30,compare_02,compare_13;
    
    always@(*)
    begin
        if(E0<E1)
            compare_01=0;
        else
            compare_01=1;
        if(E1<E2)
            compare_12=0;
        else
            compare_12=1;
        if(E2<E3)
            compare_23=0;
        else
            compare_23=1;
        if(E3<E0)
            compare_30=0;
        else
            compare_30=1;
        if(E0<E2)
            compare_02=0;
        else
            compare_02=1;
        if(E1<E3)
            compare_13=0;
        else
            compare_13=1;                
    end
    
    always@(*)
    begin
       case( {compare_01,compare_12,compare_23,compare_30} )
           4'b0000: Emax=0; 
           4'b0001: Emax=E3;
           4'b0010: Emax=E2;
           4'b0011: Emax=E2;
           4'b0100: Emax=E1;
           4'b0101:begin if(compare_13==0) Emax=E3; else Emax=E1; end
           4'b0110: Emax=E1;
           4'b0111: Emax=E1;
           4'b1000: Emax=E0; 
           4'b1001: Emax=E3;
           4'b1010: begin if(compare_02==0) Emax=E2; else Emax=E0; end
           4'b1011: Emax=E2;
           4'b1100: Emax=E0;
           4'b1101: Emax=E3;
           4'b1110: Emax=E0;
           4'b1111: Emax=E0;
        endcase
    end
endmodule




module CEC(exp_A_0,exp_A_1,exp_A_2,exp_A_3,exp_A_4,exp_A_5,exp_A_6,exp_A_7,exp_A_8,exp_A_9,exp_B_0,exp_B_1,exp_B_2,exp_B_3,exp_B_4,exp_B_5,exp_B_6,exp_B_7,exp_B_8,exp_B_9, mode,
    max_exp,diff_0, diff_1, diff_2,diff_3,diff_4,diff_5,diff_6,diff_7,diff_8,diff_9,exp_A,exp_B,exp);
    
    input [9:0]exp_A_0,exp_A_1,exp_A_2,exp_A_3,exp_A_4,exp_A_5,exp_A_6,exp_A_7,exp_A_8,exp_A_9;
    input [9:0]exp_B_0,exp_B_1,exp_B_2,exp_B_3,exp_B_4,exp_B_5,exp_B_6,exp_B_7,exp_B_8,exp_B_9;
    input [10:0]exp_A,exp_B;
    input [2:0]mode;
    output [9:0]max_exp;
    output [9:0]diff_0, diff_1, diff_2,diff_3,diff_4,diff_5,diff_6,diff_7,diff_8,diff_9;
    output [10:0]exp;
    
    assign exp=exp_A+exp_B-1023; 
    
    reg [9:0]E_0,E_1,E_2,E_3,E_4,E_5,E_6,E_7,E_8,E_9;
    wire [9:0]E0_max,E1_max,E2_max;   
        
    always@(*)
    begin
        if(mode == 3'b000)
        begin
            E_0= exp_A_0 + exp_B_0-15; 
            E_1= exp_A_1 + exp_B_1-15;
            E_2= exp_A_2 + exp_B_2-15;
            E_3= exp_A_3 + exp_B_3-15;
            E_4= exp_A_4 + exp_B_4-15;
            E_5= exp_A_5 + exp_B_5-15;
            E_6= exp_A_6 + exp_B_6-15;
            E_7= exp_A_7 + exp_B_7-15;
            E_8= exp_A_8 + exp_B_8-15;
            E_9= exp_A_9 + exp_B_9-15;    
        end
        else if(mode == 3'b011 || mode == 3'b100)
        begin
            E_0= exp_A_0 + exp_B_0-127; 
            E_1= exp_A_1 + exp_B_1-127;
            E_2= exp_A_2 + exp_B_2-127;
            E_3= exp_A_3 + exp_B_3-127;
            E_4= exp_A_4 + exp_B_4-127;
            E_5= exp_A_5 + exp_B_5-127;
            E_6= exp_A_6 + exp_B_6-127;
            E_7= exp_A_7 + exp_B_7-127;
            E_8= exp_A_8 + exp_B_8-127;
            E_9= exp_A_9 + exp_B_9-127;    
        end
        else if(mode == 3'b100)
        begin
            E_0= exp_A_0 + exp_B_0-127; 
            E_1= exp_A_1 + exp_B_1-127;
            E_2= exp_A_2 + exp_B_2-127;
            E_3= exp_A_3 + exp_B_3-127;
            E_4= exp_A_4 + exp_B_4-127;
            E_5= exp_A_5 + exp_B_5-127;
            E_6= exp_A_6 + exp_B_6-127;
            E_7= exp_A_7 + exp_B_7-127;
            E_8= 0;
            E_9= 0;    
        end
        else
        begin
            E_0= exp_A_0 + exp_B_0-127;
            E_1= exp_A_1 + exp_B_1-127;
            E_2= exp_A_2 + exp_B_2-127;
            E_3= exp_A_3 + exp_B_3-127;
            E_4= exp_A_4 + exp_B_4-127;
            E_5= 0;
            E_6= 0;
            E_7= 0;
            E_8= 0;
            E_9= 0;
        end
    end
    
    three_input_ec ec0(E_0,E_1,E_2,E0_max);
    three_input_ec ec1(E_3,E_4,E_5,E1_max);
    four_input_ec ec2(E_6,E_7,E_8,E_9,E2_max);
    three_input_ec ec3(E0_max,E1_max,E2_max,max_exp);
    
    assign diff_0=max_exp-E_0;
    assign diff_1=max_exp-E_1;
    assign diff_2=max_exp-E_2;
    assign diff_3=max_exp-E_3;
    assign diff_4=max_exp-E_4;
    assign diff_5=max_exp-E_5;
    assign diff_6=max_exp-E_6;
    assign diff_7=max_exp-E_7;
    assign diff_8=max_exp-E_8;
    assign diff_9=max_exp-E_9; 
          
endmodule
