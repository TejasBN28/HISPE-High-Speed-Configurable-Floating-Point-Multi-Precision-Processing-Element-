`timescale 1ns / 1ps

module tb_FP_MultiPrecision_PE_novel();
    reg [159:0]A,B;
    reg [2:0]mode;
    reg clk, clk_cntr;
    wire [63:0]out;
    wire [9:0]exp;
    wire [6:0]position;
    
    FP_MultiPrecision_PE_novel dut(A, B, mode, clk, clk_cntr, out);
    
    always #10 clk=~clk;
    
    initial
    begin
        #245
        clk = 0;
        clk_cntr = 0;
        A = {32'h43280000, 32'h4335ae14, 32'h40751eb8, 32'h35ae7ba9, 32'h00000000};
        B = {32'h3f800000, 32'h420551ec, 32'h42899eb8, 32'h4b895440, 32'h461c4000};
        mode = 3'b001;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = 160'h406514467381D7DC;
        B = 160'h4066BA2E87D2C7B9;
        mode = 3'b010;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {32'h43280000, 32'hc335ae14, 32'h40751eb8, 32'h35ae7ba9, 32'h00000000};
        B = {32'h3f800000, 32'h420551ec, 32'h42899eb8, 32'h4b895440, 32'h461c4000};
        mode = 3'b001;
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {16'h4500, 16'h3E66, 16'h3F33, 16'h4200, 16'h3E00, 16'hC800, 16'hD640, 16'hCFC0, 16'h0, 16'h0};
        //
        B = {16'h3C00, 16'h4600, 16'h3C00, 16'h3C00, 16'h4800, 16'h3E66, 16'h3E00, 16'h4200, 16'h5500, 16'h0};
        mode = 3'b000;                      //FP16
        
        #20
        clk_cntr = 0;
        A = {16'h40A0, 16'h3FCC, 16'h3FE6, 16'h4040, 16'h3FC0, 16'hC100, 16'hC2C8, 16'hC1F8, 16'h0, 16'h0};
        //5, 1.59375, 1.796875, 3, 1.5, -8, -100, -31, 0, 0
        B = {16'h3F80, 16'h40C0, 16'h3F80, 16'h3F80, 16'h4100, 16'h3FCC, 16'h3FC0, 16'h4040, 16'h42A0, 16'h0};
        //1, 6, 1, 1, 8, 1.5975, 1.5, 3, 80, 0
        mode = 3'b011;                      //BF16
        //Solution = -224.4
        
        #20
        clk_cntr = 0;
        A = {16'h40A0, 16'h3FCC, 16'h3FE6, 16'h4040, 16'h3FC0, 16'hC100, 16'hC2C8, 16'hC1F8, 16'hc120, 16'h4129};
        //5, 1.59375, 1.796875, 3, 1.5, -8, -100, -31, -10, 10.5625
        B = {16'h3F80, 16'h40C0, 16'h3F80, 16'h3F80, 16'h4100, 16'h3FCC, 16'h3FC0, 16'h4040, 16'h42A0, 16'h46f5};
        //1, 6, 1, 1, 8, 1.5975, 1.5, 3, 80, 31360
        mode = 3'b011;                      //BF16
        //Solution = 330137.2
        
        #20
        clk_cntr = 0;
        A = 160'h3F2D9089A585B60D;          //0.00022556
        B = 160'hC04BC8624DD2F1AA;          //-55.5655        //Solution = -0.0125333   
        mode = 3'b010;                      //FP64
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = 160'hC081B4AF1A9FBE77;          //-566.5855
        B = 160'h3BADB424B636F811;          //3.145e-21         //Solution = 1.781911398e-18
        mode = 3'b010;                      //FP64
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {32'hC285A148, 32'h67103515, 32'h3FC6872B, 32'h40A00000, 32'h40C00000}; // -66.815, 6.81e23, 1.551, 5, 6
        B = {32'h404978D5, 32'h2707D41D, 32'hC572E000, 32'h41200000, 32'hC0A00000}; // 3.148, 1.885e-15, -3.886e3, 10, -5       //Solution = 1283678782
        mode = 3'b001;                              //FP32
        #20 clk_cntr = 1;
        
        #20
        clk_cntr = 0;
        A = {141'b0, 19'b0100000001100000000};
        B = {141'b0, 19'b1011111110000000000};
        mode = 3'b100;                              //TF
        
        #20
        clk_cntr = 0;
        A = {19'b0100000001100000000};
        B = {19'b0011111110000000000};
        mode = 3'b100;                              //TF
        
        #20
        clk_cntr = 0;
        A = 160'h3442CAFACBC7D955;                  //5.98776e-57
        B = 160'h45703BC161BA75B7;                  //3.14e26           //Solution = 1.8801566e-30
        mode = 3'b010;                              //FP64
        #20 clk_cntr = 1;
        
        #180 $finish;
    end

endmodule
