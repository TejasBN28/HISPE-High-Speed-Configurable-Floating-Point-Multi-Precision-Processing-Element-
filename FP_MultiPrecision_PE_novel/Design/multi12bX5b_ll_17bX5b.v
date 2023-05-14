`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 19:02:49
// Design Name: 
// Module Name: multi12bX5b_ll_17bX5b
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
/////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                     12b X 5b Parallel 17b X 5b                                      //
/////////////////////////////////////////////////////////////////////////////////////////////////////////

// mode = 0 means 12b X 12b; mode = 1 12b X 5b parallel with 17b X 5b
// b is passed or used only when we are performing 12b X 5b parallel with 17b X 5b

module  multi12bX5b_ll_17bX5b(input [11:0]a, input [11:0]b, input [11:0]c, input mode, output [23:0]product);    
    wire [14:0]multiplicand;
    wire [16:0]m;           // multiplier
    wire [23:0]w1i, w1, w2, w3i, w3, w4, S, C_inter, C;
    reg [23:0]partial_products[6:0];  
    
    assign m = {c[4:0], b};
    assign multiplicand = {2'b0, c, 1'b0};   
    assign w1 = w1i<<1;
    assign w3 = w3i<<1;
    assign C = C_inter<<1;
    
    compressor7to2 c1(partial_products[0], partial_products[1], partial_products[2], partial_products[3], partial_products[4], 
                      partial_products[5], partial_products[6], C_inter, S);
    CLA_AdderTree ai(S, C, product);
        
    always@(*)
    begin
    // Partial Product 1
        case(multiplicand[2:0])
            3'b000:
            begin
                partial_products[0] = 24'b0;
            end
            3'b001:
            begin
                partial_products[0] = {12'b0, a};
            end
            3'b010:
            begin
                partial_products[0] = {12'b0, a};
            end
            3'b011:
            begin
                partial_products[0] = {12'b0,a}<<1;
            end
            3'b100:
            begin
                partial_products[0] = (~({12'b0,a}<<1))+1;
            end
            3'b101:
            begin
                partial_products[0] = (~{12'b0,a})+1;
            end
            3'b110:
            begin
                partial_products[0] = (~{12'b0,a})+1;
            end
            3'b111:
            begin
                partial_products[0] = 24'b0;
            end
        endcase
        
    //Partial Product 2
        case(multiplicand[4:2])
            3'b000:
            begin
                partial_products[1] = 24'b0;
            end
            3'b001:
            begin
                partial_products[1] = {10'b0, a, 2'b0};
            end
            3'b010:
            begin
                partial_products[1] = {10'b0, a, 2'b0};
            end
            3'b011:
            begin
                partial_products[1] = {10'b0, a, 2'b0}<<1;
            end
            3'b100:
            begin
                partial_products[1] = {~({10'b0, a}<<1)+1, 2'b0};
            end
            3'b101:
            begin
                partial_products[1] = {(~{10'b0, a})+1, 2'b0};
            end
            3'b110:
            begin
                partial_products[1] = {(~{10'b0, a})+1, 2'b0};
            end
            3'b111:
            begin
                partial_products[1] = 24'b0;
            end
        endcase
  
    // Partial Product 3
        case(multiplicand[6:4])
            3'b000:
            begin
                partial_products[2] = 24'b0;
            end
            3'b001:
            begin
                partial_products[2] = {8'b0, a, 4'b0};
            end
            3'b010:
            begin
                partial_products[2] = {8'b0, a, 4'b0};
            end
            3'b011:
            begin
                partial_products[2] = {8'b0, a, 4'b0}<<1;
            end
            3'b100:
            begin
                partial_products[2] = {~({8'b0, a}<<1)+1, 4'b0};
            end
            3'b101:
            begin
                partial_products[2] = {(~{8'b0, a})+1, 4'b0};
            end
            3'b110:
            begin
                partial_products[2] = {(~{8'b0, a})+1, 4'b0};
            end
            3'b111:
            begin
                partial_products[2] = 24'b0;
            end
        endcase      

    //Partial Product 4
        case(multiplicand[8:6])
            3'b000:
            begin
                partial_products[3] = 24'b0;
            end
            3'b001:
            begin
                partial_products[3] = mode ? {7'b0, m} : {6'b0, a, 6'b0};
            end
            3'b010:
            begin
                partial_products[3] = mode ? {7'b0, m} : {6'b0, a, 6'b0};
            end
            3'b011:
            begin
                partial_products[3] = mode ? {7'b0,m}<<1 : {6'b0, a, 6'b0}<<1;
            end
            3'b100:
            begin
                partial_products[3] = mode ? (~({7'b0,m}<<1))+1 : {~({6'b0, a}<<1)+1, 6'b0};
            end
            3'b101:
            begin
                partial_products[3] = mode ? (~{7'b0,m})+1 : {(~{6'b0, a})+1, 6'b0};
            end
            3'b110:
            begin
                partial_products[3] = mode ? (~{7'b0,m})+1 : {(~{6'b0, a})+1, 6'b0};
            end
            3'b111:
            begin
                partial_products[3] = 24'b0;
            end
        endcase 

    // Partial Product 5
        case(multiplicand[10:8])
            3'b000:
            begin
                partial_products[4] = 24'b0;
            end
            3'b001:
            begin
                partial_products[4] = mode ? {5'b0, m, 2'b0} : {4'b0, a, 8'b0};
            end
            3'b010:
            begin
                partial_products[4] = mode ? {5'b0, m, 2'b0} : {4'b0, a, 8'b0};
            end
            3'b011:
            begin
                partial_products[4] = mode ? {5'b0, m, 2'b0}<<1 : {4'b0, a, 8'b0}<<1;
            end
            3'b100:
            begin
                partial_products[4] = mode ? {~({5'b0, m}<<1)+1, 2'b0} : {~({4'b0, a}<<1)+1, 8'b0};
            end
            3'b101:
            begin
                partial_products[4] = mode ? {(~{5'b0, m})+1, 2'b0} : {(~{4'b0, a})+1, 8'b0};
            end
            3'b110:
            begin
                partial_products[4] = mode ? {(~{5'b0, m})+1, 2'b0} : {(~{4'b0, a})+1, 8'b0};
            end
            3'b111:
            begin
                partial_products[4] = 24'b0;
            end
        endcase
        
    // Partial Product 6
        case(multiplicand[12:10])
            3'b000:
            begin
                partial_products[5] = 24'b0;
            end
            3'b001:
            begin
                partial_products[5] = mode ? {3'b0, m, 4'b0} : {2'b0, a, 10'b0};
            end
            3'b010:
            begin
                partial_products[5] = mode ? {3'b0, m, 4'b0} : {2'b0, a, 10'b0};
            end
            3'b011:
            begin
                partial_products[5] = mode ? {3'b0, m, 4'b0}<<1 : {2'b0, a, 10'b0}<<1;
            end
            3'b100:
            begin
                partial_products[5] = mode ? {~({3'b0, m}<<1)+1, 4'b0} : {~({2'b0, a}<<1)+1, 10'b0};
            end
            3'b101:
            begin
                partial_products[5] = mode ? {(~{3'b0, m})+1, 4'b0} : {(~{2'b0, a})+1, 10'b0};
            end
            3'b110:
            begin
                partial_products[5] = mode ? {(~{3'b0, m})+1, 4'b0} : {(~{2'b0, a})+1, 10'b0};
            end
            3'b111:
            begin
                partial_products[5] = 24'b0;
            end
        endcase

    // Partial Product 7
        case(multiplicand[14:12])
            3'b000:
            begin
                partial_products[6] = 24'b0;
            end
            3'b001:
            begin
                partial_products[6] = {a, 12'b0};
            end
            3'b010:
            begin
                partial_products[6] = {a, 12'b0};
            end
            3'b011:
            begin
                partial_products[6] = {a, 12'b0}<<1;
            end
            3'b100:
            begin
                partial_products[6] = {~(a<<1)+1, 12'b0};
            end
            3'b101:
            begin
                partial_products[6] = {(~{a})+1, 12'b0};
            end
            3'b110:
            begin
                partial_products[6] = {(~{a})+1, 12'b0};
            end
            3'b111:
            begin
                partial_products[6] = 24'b0;
            end
        endcase
    end        
endmodule


