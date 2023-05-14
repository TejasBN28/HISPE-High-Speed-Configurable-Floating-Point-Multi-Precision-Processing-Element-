`timescale 1ns / 1ps

module FP_MultiPrecision_PE_novel(input [159:0]A, input [159:0]B, input [2:0]mode, input clk, input clk_cntr, output reg [63:0]out);
    
    reg [9:0]mant_A16[0:9];
    reg [9:0]mant_B16[0:9];
    reg [4:0]exp_A16[0:9];
    reg [4:0]exp_B16[0:9];
    reg sign_A16[0:9];
    reg sign_B16[0:9];
    
    reg [22:0]mant_A32[0:4];
    reg [22:0]mant_B32[0:4];
    reg [7:0]exp_A32[0:4];
    reg [7:0]exp_B32[0:4];
    reg sign_A32[0:4];
    reg sign_B32[0:4];
    
    reg [51:0]mant_A64;
    reg [51:0]mant_B64;
    reg [10:0]exp_A64;
    reg [10:0]exp_B64;
    reg sign_A64;
    reg sign_B64;
    
    reg [6:0]mant_Ab16[0:9];
    reg [6:0]mant_Bb16[0:9];
    reg [7:0]exp_Ab16[0:9];
    reg [7:0]exp_Bb16[0:9];
    reg sign_Ab16[0:9];
    reg sign_Bb16[0:9];
        
    reg [9:0]mant_At16[0:9];
    reg [9:0]mant_Bt16[0:9];
    reg [7:0]exp_At16[0:9];
    reg [7:0]exp_Bt16[0:9];
    reg sign_At16[0:9];
    reg sign_Bt16[0:9];
    
    reg [2:0]mode_p1, mode_p2, mode_p3;
    
    reg clk_cntr_stage1;
    reg clk_cntr_stage2;
    reg clk_cntr_stage3;
    
 //                                                    Stage 1 variables                                              //
    reg [11:0]a0, a1, a2, a3, a4, a5, a6, a7, a8, a9;
    reg [11:0]b0, b1, b2, b3, b4, b5, b6, b7, b8, b9;
    reg [11:0]c6, c7, c8, c9;
    reg mode_m1, mode_m2;
    reg [23:0] ppp0, ppp1, ppp2, ppp3, ppp4, ppp5, ppp6, ppp7, ppp8, ppp9;
    wire [23:0]pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7, pp8, pp9;
    
    reg [9:0]exp_A_0,exp_A_1,exp_A_2,exp_A_3,exp_A_4,exp_A_5,exp_A_6,exp_A_7,exp_A_8,exp_A_9;
    reg [9:0]exp_B_0,exp_B_1,exp_B_2,exp_B_3,exp_B_4,exp_B_5,exp_B_6,exp_B_7,exp_B_8,exp_B_9;
    reg [9:0]mmax_exp;
    reg [9:0]ddiff_0, ddiff_1, ddiff_2, ddiff_3, ddiff_4, ddiff_5, ddiff_6, ddiff_7, ddiff_8, ddiff_9;
    reg [10:0]eexp64;
    wire [9:0]max_exp;
    wire [9:0]diff_0, diff_1, diff_2, diff_3, diff_4, diff_5, diff_6, diff_7, diff_8, diff_9;
    wire [10:0]exp64;
    
    reg sign0, sign1, sign2, sign3, sign4, sign5, sign6, sign7, sign8, sign9;
    reg ssign0, ssign1, ssign2, ssign3, ssign4, ssign5, ssign6, ssign7, ssign8, ssign9;
    wire [60:0]was_out[0:9];
    reg [60:0]aas_out[0:9];

 //                                                      Stage 2 variables                                                  //  
    reg [5:0]p_shift[0:9];
    reg [7:0]d_ddiff[0:9];
    reg s_sign[0:9];        
    wire [60:0]as_out[0:9];
    
    reg [63:0]n1, n2, n3, n4, n5, n6, n7, n8, n9, n10;
    reg [65:0]acc_in;
    wire [65:0]sum;
    wire signf;
    reg ssignf;
    reg [65:0]ssum;
    reg [10:0]eexp64_s2;
    reg [9:0]mmax_exp_s2;
    
 //                                                      Stage 3 variables                                                  //  
    wire [6:0]position;
    reg [65:0]inter;
    reg [63:0]outtt;
    reg [63:0]outt;
    reg carry_rounder;
    wire [65:0]sum_f;
       
  //                                                    Stage 1 instanciation                                              //  
    multi12bX12b m0(a0, b0, pp0);
    multi12bX12b m1(a1, b1, pp1);
    multi12bX12b m2(a2, b2, pp2);
    multi12bX12b m3(a3, b3, pp3);
    multi12bX12b m4(a4, b4, pp4);
    multi12bX12b m5(a5, b5, pp5);
    multi12bX5b_parallel m6(a6, b6, c6, mode_m1, pp6);
    multi12bX5b_parallel m7(a7, b7, c7, mode_m1, pp7);
    multi12bX5b_parallel m8(a8, b8, c8, mode_m1, pp8);
    multi12bX5b_ll_17bX5b m9(a9, b9, c9, mode_m2, pp9);
    
    CEC ec1(exp_A_0, exp_A_1, exp_A_2, exp_A_3, exp_A_4, exp_A_5, exp_A_6, exp_A_7, exp_A_8, exp_A_9,
            exp_B_0, exp_B_1, exp_B_2, exp_B_3, exp_B_4, exp_B_5, exp_B_6, exp_B_7, exp_B_8, exp_B_9, mode_p1,
            max_exp, diff_0, diff_1, diff_2, diff_3, diff_4, diff_5, diff_6, diff_7, diff_8, diff_9, exp_A64, exp_B64, exp64);
            
    Alignment_Shifter as0(pp0, d_ddiff[0], p_shift[0], was_out[0]);
    Alignment_Shifter as1(pp1, d_ddiff[1], p_shift[1], was_out[1]);
    Alignment_Shifter as2(pp2, d_ddiff[2], p_shift[2], was_out[2]);
    Alignment_Shifter as3(pp3, d_ddiff[3], p_shift[3], was_out[3]);
    Alignment_Shifter as4(pp4, d_ddiff[4], p_shift[4], was_out[4]);
    Alignment_Shifter as5(pp5, d_ddiff[5], p_shift[5], was_out[5]);
    Alignment_Shifter as6(pp6, d_ddiff[6], p_shift[6], was_out[6]);
    Alignment_Shifter as7(pp7, d_ddiff[7], p_shift[7], was_out[7]);
    Alignment_Shifter as8(pp8, d_ddiff[8], p_shift[8], was_out[8]);
    Alignment_Shifter as9(pp9, d_ddiff[9], p_shift[9], was_out[9]);
            
  //                                                    Stage 2 instanciation                                                  //
  
    complement2ss1 c2s0(aas_out[0], s_sign[0], as_out[0]);
    complement2ss1 c2s1(aas_out[1], s_sign[1], as_out[1]);
    complement2ss1 c2s2(aas_out[2], s_sign[2], as_out[2]);
    complement2ss1 c2s3(aas_out[3], s_sign[3], as_out[3]);
    complement2ss1 c2s4(aas_out[4], s_sign[4], as_out[4]);
    complement2ss1 c2s5(aas_out[5], s_sign[5], as_out[5]);
    complement2ss1 c2s6(aas_out[6], s_sign[6], as_out[6]);
    complement2ss1 c2s7(aas_out[7], s_sign[7], as_out[7]);
    complement2ss1 c2s8(aas_out[8], s_sign[8], as_out[8]);
    complement2ss1 c2s9(aas_out[9], s_sign[9], as_out[9]);
       
    Adder_Tree AT1(n1, n2, n3, n4, n5, n6, n7, n8, n9, n10, acc_in, mode_p2, clk_cntr_stage2, ssign0, sum, signf);
   
  //                                                    Stage 3 instanciation                                                  //
    data_selector ii(ssum, sum_f);
    LZD z1(sum_f, position);
        
    always@(posedge clk)
    begin
    // Segregating FP64 numbers in mode 010
        mant_A64 <= A[51:0];             exp_A64 <= A[62:52];             sign_A64 <= A[63];
        mant_B64 <= B[51:0];             exp_B64 <= B[62:52];             sign_B64 <= B[63];
    
    // Segregating FP16 numbers in mode 000
        mant_A16[0] <= A[9:0];           exp_A16[0] <= A[14:10];          sign_A16[0] <= A[15];
        mant_A16[1] <= A[25:16];         exp_A16[1] <= A[30:26];          sign_A16[1] <= A[31];
        mant_A16[2] <= A[41:32];         exp_A16[2] <= A[46:42];          sign_A16[2] <= A[47];
        mant_A16[3] <= A[57:48];         exp_A16[3] <= A[62:58];          sign_A16[3] <= A[63];
        mant_A16[4] <= A[73:64];         exp_A16[4] <= A[78:74];          sign_A16[4] <= A[79];
        mant_A16[5] <= A[89:80];         exp_A16[5] <= A[94:90];          sign_A16[5] <= A[95];
        mant_A16[6] <= A[105:96];        exp_A16[6] <= A[110:106];        sign_A16[6] <= A[111];
        mant_A16[7] <= A[121:112];       exp_A16[7] <= A[126:122];        sign_A16[7] <= A[127];
        mant_A16[8] <= A[137:128];       exp_A16[8] <= A[142:138];        sign_A16[8] <= A[143];
        mant_A16[9] <= A[153:144];       exp_A16[9] <= A[158:154];        sign_A16[9] <= A[159];
        
        mant_B16[0] <= B[9:0];           exp_B16[0] <= B[14:10];          sign_B16[0] <= B[15];
        mant_B16[1] <= B[25:16];         exp_B16[1] <= B[30:26];          sign_B16[1] <= B[31];
        mant_B16[2] <= B[41:32];         exp_B16[2] <= B[46:42];          sign_B16[2] <= B[47];
        mant_B16[3] <= B[57:48];         exp_B16[3] <= B[62:58];          sign_B16[3] <= B[63];
        mant_B16[4] <= B[73:64];         exp_B16[4] <= B[78:74];          sign_B16[4] <= B[79];
        mant_B16[5] <= B[89:80];         exp_B16[5] <= B[94:90];          sign_B16[5] <= B[95];
        mant_B16[6] <= B[105:96];        exp_B16[6] <= B[110:106];        sign_B16[6] <= B[111];
        mant_B16[7] <= B[121:112];       exp_B16[7] <= B[126:122];        sign_B16[7] <= B[127];
        mant_B16[8] <= B[137:128];       exp_B16[8] <= B[142:138];        sign_B16[8] <= B[143];
        mant_B16[9] <= B[153:144];       exp_B16[9] <= B[158:154];        sign_B16[9] <= B[159];
        
        
    // Segregating BF16 numbers in mode 011
        mant_Ab16[0] <= A[6:0];           exp_Ab16[0] <= A[14:7];           sign_Ab16[0] <= A[15];
        mant_Ab16[1] <= A[22:16];         exp_Ab16[1] <= A[30:23];          sign_Ab16[1] <= A[31];
        mant_Ab16[2] <= A[38:32];         exp_Ab16[2] <= A[46:39];          sign_Ab16[2] <= A[47];
        mant_Ab16[3] <= A[54:48];         exp_Ab16[3] <= A[62:55];          sign_Ab16[3] <= A[63];
        mant_Ab16[4] <= A[70:64];         exp_Ab16[4] <= A[78:71];          sign_Ab16[4] <= A[79];
        mant_Ab16[5] <= A[86:80];         exp_Ab16[5] <= A[94:87];          sign_Ab16[5] <= A[95];
        mant_Ab16[6] <= A[102:96];        exp_Ab16[6] <= A[110:103];        sign_Ab16[6] <= A[111];
        mant_Ab16[7] <= A[118:112];       exp_Ab16[7] <= A[126:119];        sign_Ab16[7] <= A[127];
        mant_Ab16[8] <= A[134:128];       exp_Ab16[8] <= A[142:135];        sign_Ab16[8] <= A[143];
        mant_Ab16[9] <= A[150:144];       exp_Ab16[9] <= A[158:151];        sign_Ab16[9] <= A[159];
        
        mant_Bb16[0] <= B[6:0];           exp_Bb16[0] <= B[14:7];           sign_Bb16[0] <= B[15];
        mant_Bb16[1] <= B[22:16];         exp_Bb16[1] <= B[30:23];          sign_Bb16[1] <= B[31];
        mant_Bb16[2] <= B[38:32];         exp_Bb16[2] <= B[46:39];          sign_Bb16[2] <= B[47];
        mant_Bb16[3] <= B[54:48];         exp_Bb16[3] <= B[62:55];          sign_Bb16[3] <= B[63];
        mant_Bb16[4] <= B[70:64];         exp_Bb16[4] <= B[78:71];          sign_Bb16[4] <= B[79];
        mant_Bb16[5] <= B[86:80];         exp_Bb16[5] <= B[94:87];          sign_Bb16[5] <= B[95];
        mant_Bb16[6] <= B[102:96];        exp_Bb16[6] <= B[110:103];        sign_Bb16[6] <= B[111];
        mant_Bb16[7] <= B[118:112];       exp_Bb16[7] <= B[126:119];        sign_Bb16[7] <= B[127];
        mant_Bb16[8] <= B[134:128];       exp_Bb16[8] <= B[142:135];        sign_Bb16[8] <= B[143];
        mant_Bb16[9] <= B[150:144];       exp_Bb16[9] <= B[158:151];        sign_Bb16[9] <= B[159];
        
        
    // Segregating TF numbers in mode 100 or other
        mant_At16[0] <= A[9:0];           exp_At16[0] <= A[17:10];          sign_At16[0] <= A[18];
        mant_At16[1] <= A[28:19];         exp_At16[1] <= A[36:29];          sign_At16[1] <= A[37];
        mant_At16[2] <= A[47:38];         exp_At16[2] <= A[55:48];          sign_At16[2] <= A[56];
        mant_At16[3] <= A[66:57];         exp_At16[3] <= A[74:67];          sign_At16[3] <= A[75];
        mant_At16[4] <= A[85:76];         exp_At16[4] <= A[93:86];          sign_At16[4] <= A[94];
        mant_At16[5] <= A[104:95];        exp_At16[5] <= A[112:105];        sign_At16[5] <= A[113];
        mant_At16[6] <= A[123:114];       exp_At16[6] <= A[131:124];        sign_At16[6] <= A[132];
        mant_At16[7] <= A[142:135];       exp_At16[7] <= A[150:143];        sign_At16[7] <= A[151];
        mant_At16[8] <= 0;                exp_At16[8] <= 0;                 sign_At16[8] <= 0;
        mant_At16[9] <= 0;                exp_At16[9] <= 0;                 sign_At16[9] <= 0;
        
        mant_Bt16[0] <= B[9:0];           exp_Bt16[0] <= B[17:10];          sign_Bt16[0] <= B[18];
        mant_Bt16[1] <= B[28:19];         exp_Bt16[1] <= B[36:29];          sign_Bt16[1] <= B[37];
        mant_Bt16[2] <= B[47:38];         exp_Bt16[2] <= B[55:48];          sign_Bt16[2] <= B[56];
        mant_Bt16[3] <= B[66:57];         exp_Bt16[3] <= B[74:67];          sign_Bt16[3] <= B[75];
        mant_Bt16[4] <= B[85:76];         exp_Bt16[4] <= B[93:86];          sign_Bt16[4] <= B[94];
        mant_Bt16[5] <= B[104:95];        exp_Bt16[5] <= B[112:105];        sign_Bt16[5] <= B[113];
        mant_Bt16[6] <= B[123:114];       exp_Bt16[6] <= B[131:124];        sign_Bt16[6] <= B[132];
        mant_Bt16[7] <= B[142:135];       exp_Bt16[7] <= B[150:143];        sign_Bt16[7] <= B[151];
        mant_Bt16[8] <= 0;                exp_Bt16[8] <= 0;                 sign_Bt16[8] <= 0;
        mant_Bt16[9] <= 0;                exp_Bt16[9] <= 0;                 sign_Bt16[9] <= 0;
        
        
    // Segregating FP32 numbers in mode 001
        mant_A32[0] <= A[22:0];          exp_A32[0] <= A[30:23];          sign_A32[0] <= A[31];
        mant_A32[1] <= A[54:32];         exp_A32[1] <= A[62:55];          sign_A32[1] <= A[63];
        mant_A32[2] <= A[86:64];         exp_A32[2] <= A[94:87];          sign_A32[2] <= A[95];
        mant_A32[3] <= A[118:96];        exp_A32[3] <= A[126:119];        sign_A32[3] <= A[127];
        mant_A32[4] <= A[150:128];       exp_A32[4] <= A[158:151];        sign_A32[4] <= A[159];     
        
        mant_B32[0] <= B[22:0];          exp_B32[0] <= B[30:23];          sign_B32[0] <= B[31];
        mant_B32[1] <= B[54:32];         exp_B32[1] <= B[62:55];          sign_B32[1] <= B[63];
        mant_B32[2] <= B[86:64];         exp_B32[2] <= B[94:87];          sign_B32[2] <= B[95];
        mant_B32[3] <= B[118:96];        exp_B32[3] <= B[126:119];        sign_B32[3] <= B[127];
        mant_B32[4] <= B[150:128];       exp_B32[4] <= B[158:151];        sign_B32[4] <= B[159];  
 
   // Capturing mode
        mode_p1 <= mode;
        mode_p2 <= mode_p1;
        mode_p3 <= mode_p2;
        
   // Pipeline Implementation     
        clk_cntr_stage1 <= clk_cntr;
        clk_cntr_stage2 <= clk_cntr_stage1;
        clk_cntr_stage3 <= clk_cntr_stage2;     
    
   //                                                    Stage 1 implementation                                              //
        
   // Partial Product from Multipliers
        ppp0 <= pp0;
        ppp1 <= pp1;
        ppp2 <= pp2;
        ppp3 <= pp3;
        ppp4 <= pp4;
        ppp5 <= pp5;
        ppp6 <= pp6;
        ppp7 <= pp7;
        ppp8 <= pp8;
        ppp9 <= pp9;
    
    // Exponents Comparision
        mmax_exp <= max_exp;
        eexp64 <= exp64;
        
    // Sign bit computation
        ssign0 <= sign0;
        ssign1 <= sign1;
        ssign2 <= sign2;
        ssign3 <= sign3;
        ssign4 <= sign4;
        ssign5 <= sign5;
        ssign6 <= sign6;
        ssign7 <= sign7;
        ssign8 <= sign8;
        ssign9 <= sign9;
        
        aas_out[0] <= was_out[0];
        aas_out[1] <= was_out[1];
        aas_out[2] <= was_out[2];
        aas_out[3] <= was_out[3];
        aas_out[4] <= was_out[4];
        aas_out[5] <= was_out[5];
        aas_out[6] <= was_out[6];
        aas_out[7] <= was_out[7];
        aas_out[8] <= was_out[8];
        aas_out[9] <= was_out[9];
        
                
        
   //                                                    Stage 2 implementation                                              //
        ssum <= sum;
        ssignf<= signf;
        eexp64_s2 <= eexp64;
        mmax_exp_s2 <= mmax_exp;

   //                                                    Stage 3 implementation                                              //
        out <= outt;           
    end    
    
    
  //                                                    Stage 1 implementation                                              //
    always@(*)
    begin
        if(mode_p1 == 3'b000)
        begin
            a0 = (mant_A16[0]|{5'b0, exp_A16[0]})?{1'b1, mant_A16[0]}:12'b0;
            a1 = (mant_A16[1]|{5'b0, exp_A16[1]})?{1'b1, mant_A16[1]}:12'b0;
            a2 = (mant_A16[2]|{5'b0, exp_A16[2]})?{1'b1, mant_A16[2]}:12'b0;
            a3 = (mant_A16[3]|{5'b0, exp_A16[3]})?{1'b1, mant_A16[3]}:12'b0;
            a4 = (mant_A16[4]|{5'b0, exp_A16[4]})?{1'b1, mant_A16[4]}:12'b0;
            a5 = (mant_A16[5]|{5'b0, exp_A16[5]})?{1'b1, mant_A16[5]}:12'b0;
            a6 = (mant_A16[6]|{5'b0, exp_A16[6]})?{1'b1, mant_A16[6]}:12'b0;
            a7 = (mant_A16[7]|{5'b0, exp_A16[7]})?{1'b1, mant_A16[7]}:12'b0; 
            a8 = (mant_A16[8]|{5'b0, exp_A16[8]})?{1'b1, mant_A16[8]}:12'b0;
            a9 = (mant_A16[9]|{5'b0, exp_A16[9]})?{1'b1, mant_A16[9]}:12'b0;    
            
            b0 = (mant_B16[0]|{5'b0, exp_B16[0]})?{1'b1, mant_B16[0]}:12'b0;
            b1 = (mant_B16[1]|{5'b0, exp_B16[1]})?{1'b1, mant_B16[1]}:12'b0;
            b2 = (mant_B16[2]|{5'b0, exp_B16[2]})?{1'b1, mant_B16[2]}:12'b0;
            b3 = (mant_B16[3]|{5'b0, exp_B16[3]})?{1'b1, mant_B16[3]}:12'b0;
            b4 = (mant_B16[4]|{5'b0, exp_B16[4]})?{1'b1, mant_B16[4]}:12'b0;
            b5 = (mant_B16[5]|{5'b0, exp_B16[5]})?{1'b1, mant_B16[5]}:12'b0;
            b6 = 12'b0;
            b7 = 12'b0;
            b8 = 12'b0;
            b9 = 12'b0;
            
            c6 = (mant_B16[6]|{5'b0, exp_B16[6]})?{1'b1, mant_B16[6]}:12'b0;
            c7 = (mant_B16[7]|{5'b0, exp_B16[7]})?{1'b1, mant_B16[7]}:12'b0;
            c8 = (mant_B16[8]|{5'b0, exp_B16[8]})?{1'b1, mant_B16[8]}:12'b0;
            c9 = (mant_B16[9]|{5'b0, exp_B16[9]})?{1'b1, mant_B16[9]}:12'b0;      
            
            mode_m1 = 1'b0;
            mode_m2 = 1'b0;                        
        end
        
        else if(mode_p1 == 3'b100)
        begin
            a0 = (mant_At16[0]|{2'b0, exp_At16[0]})?{1'b1, mant_At16[0]}:12'b0;
            a1 = (mant_At16[1]|{2'b0, exp_At16[1]})?{1'b1, mant_At16[1]}:12'b0;
            a2 = (mant_At16[2]|{2'b0, exp_At16[2]})?{1'b1, mant_At16[2]}:12'b0;
            a3 = (mant_At16[3]|{2'b0, exp_At16[3]})?{1'b1, mant_At16[3]}:12'b0;
            a4 = (mant_At16[4]|{2'b0, exp_At16[4]})?{1'b1, mant_At16[4]}:12'b0;
            a5 = (mant_At16[5]|{2'b0, exp_At16[5]})?{1'b1, mant_At16[5]}:12'b0;
            a6 = (mant_At16[6]|{2'b0, exp_At16[6]})?{1'b1, mant_At16[6]}:12'b0;
            a7 = (mant_At16[7]|{2'b0, exp_At16[7]})?{1'b1, mant_At16[7]}:12'b0; 
            a8 = (mant_At16[8]|{2'b0, exp_At16[8]})?{1'b1, mant_At16[8]}:12'b0;
            a9 = (mant_At16[9]|{2'b0, exp_At16[9]})?{1'b1, mant_At16[9]}:12'b0;    
            
            b0 = (mant_Bt16[0]|{2'b0, exp_Bt16[0]})?{1'b1, mant_Bt16[0]}:12'b0;
            b1 = (mant_Bt16[1]|{2'b0, exp_Bt16[1]})?{1'b1, mant_Bt16[1]}:12'b0;
            b2 = (mant_Bt16[2]|{2'b0, exp_Bt16[2]})?{1'b1, mant_Bt16[2]}:12'b0;
            b3 = (mant_Bt16[3]|{2'b0, exp_Bt16[3]})?{1'b1, mant_Bt16[3]}:12'b0;
            b4 = (mant_Bt16[4]|{2'b0, exp_Bt16[4]})?{1'b1, mant_Bt16[4]}:12'b0;
            b5 = (mant_Bt16[5]|{2'b0, exp_Bt16[5]})?{1'b1, mant_Bt16[5]}:12'b0;
            b6 = 12'b0;
            b7 = 12'b0;
            b8 = 12'b0;
            b9 = 12'b0;
            
            c6 = (mant_Bt16[6]|{2'b0, exp_Bt16[6]})?{1'b1, mant_Bt16[6]}:12'b0;
            c7 = (mant_Bt16[7]|{2'b0, exp_Bt16[7]})?{1'b1, mant_Bt16[7]}:12'b0;
            c8 = (mant_Bt16[8]|{2'b0, exp_Bt16[8]})?{1'b1, mant_Bt16[8]}:12'b0;
            c9 = (mant_Bt16[9]|{2'b0, exp_Bt16[9]})?{1'b1, mant_Bt16[9]}:12'b0;      
            
            mode_m1 = 1'b0;
            mode_m2 = 1'b0;                        
        end
        
        else if(mode_p1 == 3'b011)
        begin
            a0 = ({1'b0, mant_Ab16[0]}|exp_Ab16[0])?{1'b1, mant_Ab16[0], 4'b0}:12'b0;
            a1 = ({1'b0, mant_Ab16[1]}|exp_Ab16[1])?{1'b1, mant_Ab16[1], 4'b0}:12'b0;
            a2 = ({1'b0, mant_Ab16[2]}|exp_Ab16[2])?{1'b1, mant_Ab16[2], 4'b0}:12'b0;
            a3 = ({1'b0, mant_Ab16[3]}|exp_Ab16[3])?{1'b1, mant_Ab16[3], 4'b0}:12'b0;
            a4 = ({1'b0, mant_Ab16[4]}|exp_Ab16[4])?{1'b1, mant_Ab16[4], 4'b0}:12'b0;
            a5 = ({1'b0, mant_Ab16[5]}|exp_Ab16[5])?{1'b1, mant_Ab16[5], 4'b0}:12'b0;
            a6 = ({1'b0, mant_Ab16[6]}|exp_Ab16[6])?{1'b1, mant_Ab16[6], 4'b0}:12'b0;
            a7 = ({1'b0, mant_Ab16[7]}|exp_Ab16[7])?{1'b1, mant_Ab16[7], 4'b0}:12'b0; 
            a8 = ({1'b0, mant_Ab16[8]}|exp_Ab16[8])?{1'b1, mant_Ab16[8], 4'b0}:12'b0;
            a9 = ({1'b0, mant_Ab16[9]}|exp_Ab16[9])?{1'b1, mant_Ab16[9], 4'b0}:12'b0;    
            
            b0 = ({1'b0, mant_Bb16[0]}|exp_Bb16[0])?{1'b1, mant_Bb16[0], 4'b0}:12'b0;
            b1 = ({1'b0, mant_Bb16[1]}|exp_Bb16[1])?{1'b1, mant_Bb16[1], 4'b0}:12'b0;
            b2 = ({1'b0, mant_Bb16[2]}|exp_Bb16[2])?{1'b1, mant_Bb16[2], 4'b0}:12'b0;
            b3 = ({1'b0, mant_Bb16[3]}|exp_Bb16[3])?{1'b1, mant_Bb16[3], 4'b0}:12'b0;
            b4 = ({1'b0, mant_Bb16[4]}|exp_Bb16[4])?{1'b1, mant_Bb16[4], 4'b0}:12'b0;
            b5 = ({1'b0, mant_Bb16[5]}|exp_Bb16[5])?{1'b1, mant_Bb16[5], 4'b0}:12'b0;
            b6 = 12'b0;
            b7 = 12'b0;
            b8 = 12'b0;
            b9 = 12'b0;
            
            c6 = ({1'b0, mant_Bb16[6]}|exp_Bb16[6])?{1'b1, mant_Bb16[6], 4'b0}:12'b0;
            c7 = ({1'b0, mant_Bb16[7]}|exp_Bb16[7])?{1'b1, mant_Bb16[7], 4'b0}:12'b0;
            c8 = ({1'b0, mant_Bb16[8]}|exp_Bb16[8])?{1'b1, mant_Bb16[8], 4'b0}:12'b0;
            c9 = ({1'b0, mant_Bb16[9]}|exp_Bb16[9])?{1'b1, mant_Bb16[9], 4'b0}:12'b0;      
            
            mode_m1 = 1'b0;
            mode_m2 = 1'b0;                        
        end
        
        else if(mode_p1 == 3'b001)
        begin
            if(clk_cntr_stage1 == 1'b0)
            begin
               {a1, a0} = (mant_A32[0]|{15'b0, exp_A32[0]})?{1'b1, mant_A32[0]}:24'b0; 
               {a3, a2} = (mant_A32[1]|{15'b0, exp_A32[1]})?{1'b1, mant_A32[1]}:24'b0; 
               {a5, a4} = (mant_A32[2]|{15'b0, exp_A32[2]})?{1'b1, mant_A32[2]}:24'b0; 
               {a7, a6} = (mant_A32[3]|{15'b0, exp_A32[3]})?{1'b1, mant_A32[3]}:24'b0; 
               {a9, a8} = (mant_A32[4]|{15'b0, exp_A32[4]})?{1'b1, mant_A32[4]}:24'b0; 
               
                b0 = mant_B32[0][11:0];
                b1 = mant_B32[0][11:0];
                b2 = mant_B32[1][11:0];
                b3 = mant_B32[1][11:0];
                b4 = mant_B32[2][11:0];
                b5 = mant_B32[2][11:0];
                b6 = 12'b0;
                b7 = 12'b0;
                b8 = 12'b0;
                b9 = 12'b0;
                
                c6 = mant_B32[3][11:0];
                c7 = mant_B32[3][11:0];
                c8 = mant_B32[4][11:0];
                c9 = mant_B32[4][11:0];
                
                mode_m1 = 1'b0;
                mode_m2 = 1'b0;
            end
            
            else
            begin
               {a1, a0} = (mant_A32[0]|{15'b0, exp_A32[0]})?{1'b1, mant_A32[0]}:24'b0; 
               {a3, a2} = (mant_A32[1]|{15'b0, exp_A32[1]})?{1'b1, mant_A32[1]}:24'b0; 
               {a5, a4} = (mant_A32[2]|{15'b0, exp_A32[2]})?{1'b1, mant_A32[2]}:24'b0; 
               {a7, a6} = (mant_A32[3]|{15'b0, exp_A32[3]})?{1'b1, mant_A32[3]}:24'b0; 
               {a9, a8} = (mant_A32[4]|{15'b0, exp_A32[4]})?{1'b1, mant_A32[4]}:24'b0; 
               
                b0 = (mant_B32[0]|{15'b0, exp_B32[0]})?{1'b1,mant_B32[0][22:12]}:12'b0;
                b1 = (mant_B32[0]|{15'b0, exp_B32[0]})?{1'b1,mant_B32[0][22:12]}:12'b0;
                b2 = (mant_B32[1]|{15'b0, exp_B32[1]})?{1'b1,mant_B32[1][22:12]}:12'b0;
                b3 = (mant_B32[1]|{15'b0, exp_B32[1]})?{1'b1,mant_B32[1][22:12]}:12'b0;
                b4 = (mant_B32[2]|{15'b0, exp_B32[2]})?{1'b1,mant_B32[2][22:12]}:12'b0;
                b5 = (mant_B32[2]|{15'b0, exp_B32[2]})?{1'b1,mant_B32[2][22:12]}:12'b0;
                b6 = 12'b0;
                b7 = 12'b0;
                b8 = 12'b0;
                b9 = 12'b0;
                
                c6 = (mant_B32[3]|{15'b0, exp_B32[3]})?{1'b1,mant_B32[3][22:12]}:12'b0;
                c7 = (mant_B32[3]|{15'b0, exp_B32[3]})?{1'b1,mant_B32[3][22:12]}:12'b0;
                c8 = (mant_B32[4]|{15'b0, exp_B32[4]})?{1'b1,mant_B32[4][22:12]}:12'b0;
                c9 = (mant_B32[4]|{15'b0, exp_B32[4]})?{1'b1,mant_B32[4][22:12]}:12'b0;
                
                mode_m1 = 1'b0;
                mode_m2 = 1'b0;
            end
        end
        
        else
        begin
            if(clk_cntr_stage1 == 1'b0)
            begin
                 a0 = mant_A64[11:0];
                 a1 = mant_A64[11:0];
                 a2 = mant_A64[23:12];
                 a3 = mant_A64[11:0];
                 a4 = mant_A64[35:24];
                 a5 = mant_A64[23:12];
                 a6 = mant_A64[11:0];
                 a7 = mant_A64[23:12];
                 a8 = mant_A64[35:24];
                 a9 = mant_A64[47:36];
                 
                 b0 = mant_B64[11:0];
                 b1 = mant_B64[23:12];
                 b2 = mant_B64[11:0];
                 b3 = mant_B64[35:24];
                 b4 = mant_B64[11:0];
                 b5 = mant_B64[23:12];
                 b6 = 12'b0;
                 b7 = 12'b0;
                 b8 = 12'b0;
                 b9 = 12'b0;
                 
                 c6 = mant_B64[47:36];
                 c7 = mant_B64[35:24];
                 c8 = mant_B64[23:12];
                 c9 = mant_B64[11:0];
               
                 mode_m1 = 1'b0;
                 mode_m2 = 1'b0;
            end
            else
            begin
                 b0 = mant_A64[23:12];
                 b1 = mant_A64[47:36];
                 b2 = mant_A64[35:24];
                 b3 = mant_A64[35:24];
                 b4 = mant_A64[47:36];
                 b5 = mant_A64[47:36];
                 b6 = mant_A64[11:0];
                 b7 = mant_A64[23:12];
                 b8 = mant_A64[35:24];
                 b9 = mant_A64[47:36];
                 
                 a0 = mant_B64[47:36];
                 a1 = mant_B64[23:12];
                 a2 = mant_B64[35:24];
                 a3 = mant_B64[47:36];
                 a4 = mant_B64[35:24];
                 a5 = mant_B64[47:36];
                 a6 = mant_B64[11:0];
                 a7 = mant_B64[23:12];
                 a8 = mant_B64[35:24];
                 a9 = mant_B64[47:36];
                 
                 c6 = {1'b0, (mant_B64|{41'b0, exp_B64})?{1'b1, mant_B64[51:48]}:{5'b0}, 1'b0, (mant_A64|{41'b0, exp_A64})?{1'b1, mant_A64[51:48]}:{5'b0}};
                 c7 = {1'b0, (mant_B64|{41'b0, exp_B64})?{1'b1, mant_B64[51:48]}:{5'b0}, 1'b0, (mant_A64|{41'b0, exp_A64})?{1'b1, mant_A64[51:48]}:{5'b0}};
                 c8 = {1'b0, (mant_B64|{41'b0, exp_B64})?{1'b1, mant_B64[51:48]}:{5'b0}, 1'b0, (mant_A64|{41'b0, exp_A64})?{1'b1, mant_A64[51:48]}:{5'b0}};
                 c9 = {1'b0, (mant_B64|{41'b0, exp_B64})?{1'b1, mant_B64[51:48]}:{5'b0}, 1'b0, (mant_A64|{41'b0, exp_A64})?{1'b1, mant_A64[51:48]}:{5'b0}};
                 
                 mode_m1 = 1'b1;
                 mode_m2 = 1'b1;
            end
        end
        
        if(mode_p1 == 3'b000)
        begin
            exp_A_0 = exp_A16[0];               exp_B_0 = exp_B16[0];
            exp_A_1 = exp_A16[1];               exp_B_1 = exp_B16[1];
            exp_A_2 = exp_A16[2];               exp_B_2 = exp_B16[2];
            exp_A_3 = exp_A16[3];               exp_B_3 = exp_B16[3];
            exp_A_4 = exp_A16[4];               exp_B_4 = exp_B16[4];
            exp_A_5 = exp_A16[5];               exp_B_5 = exp_B16[5];
            exp_A_6 = exp_A16[6];               exp_B_6 = exp_B16[6];
            exp_A_7 = exp_A16[7];               exp_B_7 = exp_B16[7];
            exp_A_8 = exp_A16[8];               exp_B_8 = exp_B16[8];
            exp_A_9 = exp_A16[9];               exp_B_9 = exp_B16[9];
        end
        
        else if(mode_p1 == 3'b100)
        begin
            exp_A_0 = exp_At16[0];               exp_B_0 = exp_Bt16[0];
            exp_A_1 = exp_At16[1];               exp_B_1 = exp_Bt16[1];
            exp_A_2 = exp_At16[2];               exp_B_2 = exp_Bt16[2];
            exp_A_3 = exp_At16[3];               exp_B_3 = exp_Bt16[3];
            exp_A_4 = exp_At16[4];               exp_B_4 = exp_Bt16[4];
            exp_A_5 = exp_At16[5];               exp_B_5 = exp_Bt16[5];
            exp_A_6 = exp_At16[6];               exp_B_6 = exp_Bt16[6];
            exp_A_7 = exp_At16[7];               exp_B_7 = exp_Bt16[7];
            exp_A_8 = exp_At16[8];               exp_B_8 = exp_Bt16[8];
            exp_A_9 = exp_At16[9];               exp_B_9 = exp_Bt16[9];
        end
        
        else if(mode_p1 == 3'b011)
        begin
            exp_A_0 = exp_Ab16[0];               exp_B_0 = exp_Bb16[0];
            exp_A_1 = exp_Ab16[1];               exp_B_1 = exp_Bb16[1];
            exp_A_2 = exp_Ab16[2];               exp_B_2 = exp_Bb16[2];
            exp_A_3 = exp_Ab16[3];               exp_B_3 = exp_Bb16[3];
            exp_A_4 = exp_Ab16[4];               exp_B_4 = exp_Bb16[4];
            exp_A_5 = exp_Ab16[5];               exp_B_5 = exp_Bb16[5];
            exp_A_6 = exp_Ab16[6];               exp_B_6 = exp_Bb16[6];
            exp_A_7 = exp_Ab16[7];               exp_B_7 = exp_Bb16[7];
            exp_A_8 = exp_Ab16[8];               exp_B_8 = exp_Bb16[8];
            exp_A_9 = exp_Ab16[9];               exp_B_9 = exp_Bb16[9];
        end
        
        else
        begin
            exp_A_0 = exp_A32[0];               exp_B_0 = exp_B32[0];
            exp_A_1 = exp_A32[1];               exp_B_1 = exp_B32[1];
            exp_A_2 = exp_A32[2];               exp_B_2 = exp_B32[2];
            exp_A_3 = exp_A32[3];               exp_B_3 = exp_B32[3];
            exp_A_4 = exp_A32[4];               exp_B_4 = exp_B32[4];
            exp_A_5 = 0;                        exp_B_5 = 0;
            exp_A_6 = 0;                        exp_B_6 = 0;
            exp_A_7 = 0;                        exp_B_7 = 0;
            exp_A_8 = 0;                        exp_B_8 = 0;
            exp_A_9 = 0;                        exp_B_9 = 0;
        end
        
        if(mode_p1 == 3'b000)
        begin
            sign0 = sign_A16[0]^sign_B16[0];
            sign1 = sign_A16[1]^sign_B16[1];
            sign2 = sign_A16[2]^sign_B16[2];
            sign3 = sign_A16[3]^sign_B16[3];
            sign4 = sign_A16[4]^sign_B16[4];
            sign5 = sign_A16[5]^sign_B16[5];
            sign6 = sign_A16[6]^sign_B16[6];
            sign7 = sign_A16[7]^sign_B16[7];
            sign8 = sign_A16[8]^sign_B16[8];
            sign9 = sign_A16[9]^sign_B16[9];
        end
        else if(mode_p1 == 3'b100)
        begin
            sign0 = sign_At16[0]^sign_Bt16[0];
            sign1 = sign_At16[1]^sign_Bt16[1];
            sign2 = sign_At16[2]^sign_Bt16[2];
            sign3 = sign_At16[3]^sign_Bt16[3];
            sign4 = sign_At16[4]^sign_Bt16[4];
            sign5 = sign_At16[5]^sign_Bt16[5];
            sign6 = sign_At16[6]^sign_Bt16[6];
            sign7 = sign_At16[7]^sign_Bt16[7];
            sign8 = sign_At16[8]^sign_Bt16[8];
            sign9 = sign_At16[9]^sign_Bt16[9];
        end
        else if(mode_p1 == 3'b011)
        begin
            sign0 = sign_Ab16[0]^sign_Bb16[0];
            sign1 = sign_Ab16[1]^sign_Bb16[1];
            sign2 = sign_Ab16[2]^sign_Bb16[2];
            sign3 = sign_Ab16[3]^sign_Bb16[3];
            sign4 = sign_Ab16[4]^sign_Bb16[4];
            sign5 = sign_Ab16[5]^sign_Bb16[5];
            sign6 = sign_Ab16[6]^sign_Bb16[6];
            sign7 = sign_Ab16[7]^sign_Bb16[7];
            sign8 = sign_Ab16[8]^sign_Bb16[8];
            sign9 = sign_Ab16[9]^sign_Bb16[9];
        end
        else if(mode_p1 == 3'b001)
        begin
            sign0 = sign_A32[0]^sign_B32[0];
            sign1 = sign_A32[1]^sign_B32[1];
            sign2 = sign_A32[2]^sign_B32[2];
            sign3 = sign_A32[3]^sign_B32[3];
            sign4 = sign_A32[4]^sign_B32[4];
            {sign5, sign6, sign7, sign8, sign9} = 5'b0;
        end
        else
        begin
            sign0 = sign_A64^sign_B64;
            {sign1, sign2, sign3, sign4, sign5, sign6, sign7, sign8, sign9} = 9'b0;
        end
        
        
        if(mode_p1 == 3'b000)
        begin
           p_shift[0] = 6'b0;                  d_ddiff[0] = diff_0;                                
           p_shift[1] = 6'b0;                  d_ddiff[1] = diff_1;                    
           p_shift[2] = 6'b0;                  d_ddiff[2] = diff_2;                    
           p_shift[3] = 6'b0;                  d_ddiff[3] = diff_3;                    
           p_shift[4] = 6'b0;                  d_ddiff[4] = diff_4;                   
           p_shift[5] = 6'b0;                  d_ddiff[5] = diff_5;                   
           p_shift[6] = 6'b0;                  d_ddiff[6] = diff_6;                     
           p_shift[7] = 6'b0;                  d_ddiff[7] = diff_7;                     
           p_shift[8] = 6'b0;                  d_ddiff[8] = diff_8;                     
           p_shift[9] = 6'b0;                  d_ddiff[9] = diff_9;                    
        end
        else if(mode_p1 == 3'b100)
        begin
           p_shift[0] = 6'b0;                  d_ddiff[0] = diff_0;                              
           p_shift[1] = 6'b0;                  d_ddiff[1] = diff_1;                     
           p_shift[2] = 6'b0;                  d_ddiff[2] = diff_2;                   
           p_shift[3] = 6'b0;                  d_ddiff[3] = diff_3;                    
           p_shift[4] = 6'b0;                  d_ddiff[4] = diff_4;                    
           p_shift[5] = 6'b0;                  d_ddiff[5] = diff_5;                    
           p_shift[6] = 6'b0;                  d_ddiff[6] = diff_6;                    
           p_shift[7] = 6'b0;                  d_ddiff[7] = diff_7;                   
           p_shift[8] = 6'b0;                  d_ddiff[8] = diff_8;                    
           p_shift[9] = 6'b0;                  d_ddiff[9] = diff_9;                   
        end
        else if(mode_p1 == 3'b011)
        begin
           p_shift[0] = 6'b0;                  d_ddiff[0] = diff_0;                      
           p_shift[1] = 6'b0;                  d_ddiff[1] = diff_1;                    
           p_shift[2] = 6'b0;                  d_ddiff[2] = diff_2;                   
           p_shift[3] = 6'b0;                  d_ddiff[3] = diff_3;                   
           p_shift[4] = 6'b0;                  d_ddiff[4] = diff_4;                    
           p_shift[5] = 6'b0;                  d_ddiff[5] = diff_5;                    
           p_shift[6] = 6'b0;                  d_ddiff[6] = diff_6;                    
           p_shift[7] = 6'b0;                  d_ddiff[7] = diff_7;                    
           p_shift[8] = 6'b0;                  d_ddiff[8] = diff_8;                    
           p_shift[9] = 6'b0;                  d_ddiff[9] = diff_9;                    
        end
        else if(mode_p1 == 3'b001)
        begin
            if(clk_cntr_stage1 == 1'b0)
            begin
                p_shift[0] = 6'b0;                  d_ddiff[0] = diff_0;               
                p_shift[1] = 6'd12;                 d_ddiff[1] = diff_0;              
                p_shift[2] = 6'b0;                  d_ddiff[2] = diff_1;              
                p_shift[3] = 6'd12;                 d_ddiff[3] = diff_1;               
                p_shift[4] = 6'b0;                  d_ddiff[4] = diff_2;              
                p_shift[5] = 6'd12;                 d_ddiff[5] = diff_2;               
                p_shift[6] = 6'b0;                  d_ddiff[6] = diff_3;               
                p_shift[7] = 6'd12;                 d_ddiff[7] = diff_3;               
                p_shift[8] = 6'b0;                  d_ddiff[8] = diff_4;              
                p_shift[9] = 6'd12;                 d_ddiff[9] = diff_4;               
            end
            else
            begin   
                p_shift[0] = 6'd12;                 d_ddiff[0] = diff_0;               
                p_shift[1] = 6'd24;                 d_ddiff[1] = diff_0;              
                p_shift[2] = 6'd12;                 d_ddiff[2] = diff_1;              
                p_shift[3] = 6'd24;                 d_ddiff[3] = diff_1;               
                p_shift[4] = 6'd12;                 d_ddiff[4] = diff_2;              
                p_shift[5] = 6'd24;                 d_ddiff[5] = diff_2;              
                p_shift[6] = 6'd12;                 d_ddiff[6] = diff_3;              
                p_shift[7] = 6'd24;                 d_ddiff[7] = diff_3;               
                p_shift[8] = 6'd12;                 d_ddiff[8] = diff_4;              
                p_shift[9] = 6'd24;                 d_ddiff[9] = diff_4;               
            end
        end
        else
        begin
            if(clk_cntr_stage1 == 1'b0)
            begin
                p_shift[0] = 6'd00;                 d_ddiff[0] = 8'b0;               
                p_shift[1] = 6'd12;                 d_ddiff[1] = 8'b0;              
                p_shift[2] = 6'd12;                 d_ddiff[2] = 8'b0;              
                p_shift[3] = 6'd24;                 d_ddiff[3] = 8'b0;              
                p_shift[4] = 6'd24;                 d_ddiff[4] = 8'b0;             
                p_shift[5] = 6'd24;                 d_ddiff[5] = 8'b0;              
                p_shift[6] = 6'd36;                 d_ddiff[6] = 8'b0;               
                p_shift[7] = 6'd36;                 d_ddiff[7] = 8'b0;               
                p_shift[8] = 6'd36;                 d_ddiff[8] = 8'b0;              
                p_shift[9] = 6'd36;                 d_ddiff[9] = 8'b0;             
            end
            else
            begin
                p_shift[0] = 6'd00;                 d_ddiff[0] = 8'b0;               
                p_shift[1] = 6'd00;                 d_ddiff[1] = 8'b0;               
                p_shift[2] = 6'd00;                 d_ddiff[2] = 8'b0;               
                p_shift[3] = 6'd12;                 d_ddiff[3] = 8'b0;              
                p_shift[4] = 6'd12;                 d_ddiff[4] = 8'b0;              
                p_shift[5] = 6'd24;                 d_ddiff[5] = 8'b0;              
                p_shift[6] = 6'd00;                 d_ddiff[6] = 8'b0;               
                p_shift[7] = 6'd12;                 d_ddiff[7] = 8'b0;              
                p_shift[8] = 6'd24;                 d_ddiff[8] = 8'b0;             
                p_shift[9] = 6'd36;                 d_ddiff[9] = 8'b0;               
            end
        end
    end    

  //                                                    Stage 2 implementation                                              //
    always@(*)
    begin
        if(mode_p2 == 3'b000)
        begin
           s_sign[0] = ssign0;            
           s_sign[1] = ssign1; 
           s_sign[2] = ssign2; 
           s_sign[3] = ssign3; 
           s_sign[4] = ssign4; 
           s_sign[5] = ssign5; 
           s_sign[6] = ssign6; 
           s_sign[7] = ssign7; 
           s_sign[8] = ssign8; 
           s_sign[9] = ssign9; 
        end
        else if(mode_p2 == 3'b100)
        begin
           s_sign[0] = ssign0;            
           s_sign[1] = ssign1; 
           s_sign[2] = ssign2; 
           s_sign[3] = ssign3; 
           s_sign[4] = ssign4; 
           s_sign[5] = ssign5; 
           s_sign[6] = ssign6; 
           s_sign[7] = ssign7; 
           s_sign[8] = ssign8; 
           s_sign[9] = ssign9; 
        end
        else if(mode_p2 == 3'b011)
        begin
           s_sign[0] = ssign0;            
           s_sign[1] = ssign1; 
           s_sign[2] = ssign2; 
           s_sign[3] = ssign3; 
           s_sign[4] = ssign4; 
           s_sign[5] = ssign5; 
           s_sign[6] = ssign6; 
           s_sign[7] = ssign7; 
           s_sign[8] = ssign8; 
           s_sign[9] = ssign9; 
        end
        else if(mode_p2 == 3'b001)
        begin
            if(clk_cntr_stage2 == 1'b0)
            begin
                s_sign[0] = ssign0;
                s_sign[1] = ssign0;
                s_sign[2] = ssign1;
                s_sign[3] = ssign1;
                s_sign[4] = ssign2;
                s_sign[5] = ssign2;
                s_sign[6] = ssign3;
                s_sign[7] = ssign3;
                s_sign[8] = ssign4;
                s_sign[9] = ssign4;
            end
            else
            begin   
                s_sign[0] = ssign0;
                s_sign[1] = ssign0;
                s_sign[2] = ssign1;
                s_sign[3] = ssign1;
                s_sign[4] = ssign2;
                s_sign[5] = ssign2;
                s_sign[6] = ssign3;
                s_sign[7] = ssign3;
                s_sign[8] = ssign4;
                s_sign[9] = ssign4;
            end
        end
        else
        begin
            if(clk_cntr_stage2 == 1'b0)
            begin
                s_sign[0] = 1'b0;
                s_sign[1] = 1'b0;
                s_sign[2] = 1'b0;
                s_sign[3] = 1'b0;
                s_sign[4] = 1'b0;
                s_sign[5] = 1'b0;
                s_sign[6] = 1'b0;
                s_sign[7] = 1'b0;
                s_sign[8] = 1'b0;
                s_sign[9] = 1'b0; 
            end
            else
            begin
                s_sign[0] = 1'b0;
                s_sign[1] = 1'b0;
                s_sign[2] = 1'b0;
                s_sign[3] = 1'b0;
                s_sign[4] = 1'b0;
                s_sign[5] = 1'b0;
                s_sign[6] = 1'b0;
                s_sign[7] = 1'b0;
                s_sign[8] = 1'b0;
                s_sign[9] = 1'b0;
            end
        end
        
        
        if(mode_p2 == 3'b000)
        begin
            n1 = {as_out[0][60], as_out[0][60], as_out[0][60], as_out[0]};
            n2 = {as_out[1][60], as_out[1][60], as_out[1][60], as_out[1]};
            n3 = {as_out[2][60], as_out[2][60], as_out[2][60], as_out[2]};
            n4 = {as_out[3][60], as_out[3][60], as_out[3][60], as_out[3]};
            n5 = {as_out[4][60], as_out[4][60], as_out[4][60], as_out[4]};
            n6 = {as_out[5][60], as_out[5][60], as_out[5][60], as_out[5]};
            n7 = {as_out[6][60], as_out[6][60], as_out[6][60], as_out[6]};
            n8 = {as_out[7][60], as_out[7][60], as_out[7][60], as_out[7]};
            n9 = {as_out[8][60], as_out[8][60], as_out[8][60], as_out[8]};
            n10 ={as_out[9][60], as_out[9][60], as_out[9][60], as_out[9]};  
            acc_in = 0;
        end
        
        else if(mode_p2 == 3'b100)
        begin
            n1 = {as_out[0][60], as_out[0][60], as_out[0][60], as_out[0]};
            n2 = {as_out[1][60], as_out[1][60], as_out[1][60], as_out[1]};
            n3 = {as_out[2][60], as_out[2][60], as_out[2][60], as_out[2]};
            n4 = {as_out[3][60], as_out[3][60], as_out[3][60], as_out[3]};
            n5 = {as_out[4][60], as_out[4][60], as_out[4][60], as_out[4]};
            n6 = {as_out[5][60], as_out[5][60], as_out[5][60], as_out[5]};
            n7 = {as_out[6][60], as_out[6][60], as_out[6][60], as_out[6]};
            n8 = {as_out[7][60], as_out[7][60], as_out[7][60], as_out[7]};
            n9 = {as_out[8][60], as_out[8][60], as_out[8][60], as_out[8]};
            n10 ={as_out[9][60], as_out[9][60], as_out[9][60], as_out[9]};  
            acc_in = 0;
        end
        
        else if(mode_p2 == 3'b011)
        begin
            n1 = {as_out[0][60], as_out[0][60], as_out[0][60], as_out[0]};
            n2 = {as_out[1][60], as_out[1][60], as_out[1][60], as_out[1]};
            n3 = {as_out[2][60], as_out[2][60], as_out[2][60], as_out[2]};
            n4 = {as_out[3][60], as_out[3][60], as_out[3][60], as_out[3]};
            n5 = {as_out[4][60], as_out[4][60], as_out[4][60], as_out[4]};
            n6 = {as_out[5][60], as_out[5][60], as_out[5][60], as_out[5]};
            n7 = {as_out[6][60], as_out[6][60], as_out[6][60], as_out[6]};
            n8 = {as_out[7][60], as_out[7][60], as_out[7][60], as_out[7]};
            n9 = {as_out[8][60], as_out[8][60], as_out[8][60], as_out[8]};
            n10 ={as_out[9][60], as_out[9][60], as_out[9][60], as_out[9]};  
            acc_in = 0;
        end
        
        else if(mode_p2 == 3'b001)
        begin
            if(clk_cntr_stage2 == 1'b0)
            begin
                n1 = {as_out[0][60], as_out[0][60], as_out[0][60], as_out[0]};
                n2 = {as_out[1][60], as_out[1][60], as_out[1][60], as_out[1]};
                n3 = {as_out[2][60], as_out[2][60], as_out[2][60], as_out[2]};
                n4 = {as_out[3][60], as_out[3][60], as_out[3][60], as_out[3]};
                n5 = {as_out[4][60], as_out[4][60], as_out[4][60], as_out[4]};
                n6 = {as_out[5][60], as_out[5][60], as_out[5][60], as_out[5]};
                n7 = {as_out[6][60], as_out[6][60], as_out[6][60], as_out[6]};
                n8 = {as_out[7][60], as_out[7][60], as_out[7][60], as_out[7]};
                n9 = {as_out[8][60], as_out[8][60], as_out[8][60], as_out[8]};
                n10 ={as_out[9][60], as_out[9][60], as_out[9][60], as_out[9]};  
                acc_in = 0; 
            end
            
            else
            begin
                n1 = {as_out[0][60], as_out[0][60], as_out[0][60], as_out[0]};
                n2 = {as_out[1][60], as_out[1][60], as_out[1][60], as_out[1]};
                n3 = {as_out[2][60], as_out[2][60], as_out[2][60], as_out[2]};
                n4 = {as_out[3][60], as_out[3][60], as_out[3][60], as_out[3]};
                n5 = {as_out[4][60], as_out[4][60], as_out[4][60], as_out[4]};
                n6 = {as_out[5][60], as_out[5][60], as_out[5][60], as_out[5]};
                n7 = {as_out[6][60], as_out[6][60], as_out[6][60], as_out[6]};
                n8 = {as_out[7][60], as_out[7][60], as_out[7][60], as_out[7]};
                n9 = {as_out[8][60], as_out[8][60], as_out[8][60], as_out[8]};
                n10 ={as_out[9][60], as_out[9][60], as_out[9][60], as_out[9]};  
                acc_in = ssum;
            end            
        end
        
        else
        begin
            if(clk_cntr_stage2 == 1'b0)
            begin
                n1 = {3'b0, as_out[0]};
                n2 = {3'b0, as_out[1]};
                n3 = {3'b0, as_out[2]};
                n4 = {3'b0, as_out[3]};
                n5 = {3'b0, as_out[4]};
                n6 = {3'b0, as_out[5]};
                n7 = {3'b0, as_out[6]};
                n8 = {3'b0, as_out[7]};
                n9 = {3'b0, as_out[8]};
                n10 ={3'b0, as_out[9]};  
                acc_in = 0; 
            end
            
            else
            begin
                n1 = {3'b0, as_out[0]};
                n2 = {3'b0, as_out[1]};
                n3 = {3'b0, as_out[2]};
                n4 = {3'b0, as_out[3]};
                n5 = {3'b0, as_out[4]};
                n6 = {3'b0, as_out[5]};
                n7 = {3'b0, as_out[6]};
                n8 = {3'b0, as_out[7]};
                n9 = {3'b0, as_out[8][60:16], ssum[63:48]};  
                n10 ={3'b0, as_out[9]};  
                acc_in = 0;
            end 
        end
    end
    
  //                                                    Stage 3 implementation                                              //
    always@(*)
    begin
        if(mode_p3 == 3'b000)
        begin
            inter = sum_f<<position;
            {carry_rounder, outtt[9:0]} = inter[65:56]+inter[55];
            outt[9:0] = carry_rounder?{carry_rounder, outtt[9:1]}:outtt[9:0];
            outtt[63:10] = 0;
            if(sum_f == 0)
            begin
                outt[14:10] = 0;
            end
            else if(position>=46)
            begin
                outt[14:10] = mmax_exp_s2-(position-46);
            end
            else
            begin
                outt[14:10] = mmax_exp_s2+(46-position);
            end
            outt[15] = ssignf;
            outt[63:16] = 0;
        end
        
        else if(mode_p3 == 3'b100) /////////////////////////////////////
        begin
            inter = sum_f<<position;
            {carry_rounder, outtt[9:0]} = inter[65:56]+inter[55];
            outt[9:0] = carry_rounder?{carry_rounder, outtt[9:1]}:outtt[9:0];
            outtt[63:10] = 0;
            $display("position = %0d", position);
            if(sum_f == 0)
            begin
                outt[17:10] = 0;
            end
            else if(position>=46)
            begin
                outt[17:10] = mmax_exp_s2-(position-46);
            end
            else
            begin
                outt[17:10] = mmax_exp_s2+(46-position);
            end
            outt[18] = ssignf;
            outt[63:19] = 0;
        end
        
        
        else if(mode_p3 == 3'b011) 
        begin
            inter = sum_f<<position;
            {carry_rounder, outtt[6:0]} = inter[65:59]+inter[58];
            outt[6:0] = carry_rounder?{carry_rounder, outtt[6:1]}:outtt[6:0];
            outtt[63:7] = 0;
            if(sum_f == 0)
            begin
                outt[14:7] = 0;
            end
            else if(position>=44)
            begin
                outt[14:7] = mmax_exp_s2-(position-44);
            end
            else
            begin
                outt[14:7] = mmax_exp_s2+(44-position);
            end
            outt[15] = ssignf;
            outt[63:16] = 0;
        end
        
        else if(mode_p3 == 3'b001) 
        begin
            if(clk_cntr_stage3 == 0)
            begin
                inter = 0;
                carry_rounder = 0;
                outt = 0;
                outtt = 0;
            end
            
            else 
            begin
                inter = sum_f<<position;
                {carry_rounder, outtt[22:0]} = inter[65:43]+inter[42];
                outt[22:0] = carry_rounder?{carry_rounder, outtt[22:1]}:outtt[22:0];
                outtt[63:23] = 0;
                if(sum_f == 0)
                begin
                    outt[31:23] = 0;
                end
                else if(position>=20)
                begin
                    outt[30:23] = mmax_exp_s2-(position-20);
                end
                else
                begin
                    outt[30:23] = mmax_exp_s2+(20-position);
                end
                outt[31] = ssignf;
                outt[63:32] = 0;
            end    
        end
        
        else 
        begin
            if(clk_cntr_stage3 == 0)
            begin
                inter = 0;
                carry_rounder = 0;
                outt = 0;
                outtt = 0;
            end
            
            else 
            begin
                inter = sum_f<<position;
                {carry_rounder, outtt[51:0]} = inter[65:14]+inter[13];
                outt[51:0] = carry_rounder?{carry_rounder, outtt[51:1]}:outtt[51:0];
                outtt[63:52] = 0;
                if(sum_f == 0)
                begin
                    outt[62:52] = 0;
                end
                else if(position>=20)
                begin
                    outt[62:52] = eexp64_s2-(position-10);
                end
                else
                begin
                    outt[62:52] = eexp64_s2+(10-position);
                end
                outt[63] = ssignf;
            end    
        end
        
    end
endmodule
