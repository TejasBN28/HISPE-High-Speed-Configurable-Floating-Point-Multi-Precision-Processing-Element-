`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 21.02.2023 19:17:19
// Design Name: 
// Module Name: tb_FP_MultiPrecision_PE_novel
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

module tb_FP_MultiPrecision_PE_novel();
    reg [159:0]A,B;
    reg [1:0]mode;
    reg clk, clk_cntr;
    wire [63:0]out;
    
    FP_MultiPrecision_PE_novel_3modes dut(A, B, mode, clk, clk_cntr, out);
    
    always #10 clk=~clk;
    
    initial
    begin
        #245
        clk = 0;
        clk_cntr = 0;
        clk_cntr = 0;
        A = {32'hc3280000, 32'hc335ae14, 32'hc0751eb8, 32'hb5ae7ba9, 32'h00000000};
        B = {32'h3f800000, 32'h420551ec, 32'h42899eb8, 32'h4b895440, 32'h461c4000};
        mode = 2'b01;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = 160'h406514467381D7DC;
        B = 160'h4066BA2E87D2C7B9;
        mode = 2'b10;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {32'h43280000, 32'hc335ae14, 32'h40751eb8, 32'h35ae7ba9, 32'h00000000};
        B = {32'h3f800000, 32'h420551ec, 32'h42899eb8, 32'h4b895440, 32'h461c4000};
        mode = 2'b01;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {16'h4500, 16'h3E66, 16'h3F33, 16'h4200, 16'h3E00, 16'hC800, 16'hD640, 16'hCFC0, 16'h0, 16'h0};
        B = {16'h3C00, 16'h4600, 16'h3C00, 16'h3C00, 16'h4800, 16'h3E66, 16'h3E00, 16'h4200, 16'h5500, 16'h0};
        mode = 2'b00;    
        
        #20
        clk_cntr = 0;
        A = {16'h40A0, 16'h3FCC, 16'h3FE6, 16'h4040, 16'h3FC0, 16'hC100, 16'hC2C8, 16'hC1F8, 16'h0, 16'h0};
        B = {16'h3F80, 16'h40C0, 16'h3F80, 16'h3F80, 16'h4100, 16'h3FCC, 16'h3FC0, 16'h4040, 16'h42A0, 16'h0};
        mode = 2'b11;
        
        #20
        clk_cntr = 0;
        A = 160'h3F2D9089A585B60D;
        B = 160'hC04BC8624DD2F1AA;
        mode = 2'b10;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = 160'hC081B4AF1A9FBE77;
        B = 160'h3BADB424B636F811;
        mode = 2'b10;
        #20 clk_cntr = 1;
        
        #180 $finish;
    end

endmodule
