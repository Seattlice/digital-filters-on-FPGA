`timescale 1ns / 1ps
//****************************************VSCODE PLUG-IN**********************************//
//----------------------------------------------------------------------------------------
// IDE :                   VSCODE     
// VSCODE plug-in version: Verilog-Hdl-Format-2.8.20240817
// VSCODE plug-in author : Jiang Percy
//----------------------------------------------------------------------------------------
//****************************************Copyright (c)***********************************//
// Copyright(C)            XDU
// All rights reserved     
// File name:              
// Last modified Date:     2024/08/24 16:08:55
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/24 16:08:55
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              ex1_tb.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\10.filter\ch3\ex1_tb.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module ex1_tb();
reg clk;
reg [3:0] d1;
reg [3:0] d2;
wire [3:0] signed_out;
wire [3:0] unsigned_out;



initial clk = 1'b0;
always #10 clk <= ~clk; 

initial begin
    d1 = 4'd0;
    d2 = 4'd0;

    #200 begin
    d1 <= 4'd1;
    d2 <= 4'd1;      
    end
    #200 begin
    d1 = 4'd2;
    d2 = 4'd1;      
    end
        #200 begin
    d1 = 4'd3;
    d2 = 4'd1;      
    end
        #200 begin
    d1 = 4'd4;
    d2 = 4'd1;      
    end
        #200 begin
    d1 = 4'd5;
    d2 = 4'd1;      
    end

        #200 begin
    d1 = 4'd6;
    d2 = 4'd1;      
    end
        #200 begin
    d1 = 4'd7;
    d2 = 4'd1;      
    end
        #200 begin
    d1 = 4'd7;
    d2 = 4'd2;      
    end

        #200 begin
    d1 = 4'd7;
    d2 = 4'd3;      
    end
        #200 begin
    d1 = 4'd7;
    d2 = 4'd4;      
    end
        #200 begin
    d1 = 4'd4;
    d2 = 4'd6;      
    end
    $stop;
end
    



SymbExam SymbExam_inst
(
    .d1                      (d1),
    .d2                      (d2),

    .signed_out              (signed_out),
    .unsigned_out            (unsigned_out)
    );







                                                                   
endmodule