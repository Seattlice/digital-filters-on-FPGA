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
// Last modified Date:     2024/08/25 22:22:54
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/25 22:22:54
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              signal_before.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\10.filter\ch3\signal_before.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module signal_before(
    input  wire                         sys_clk                    ,
    input  wire                         sys_rst_n                  ,

    output             [  11: 0]        signal                      
);









blk_mem_gen_0 blk_mem_gen_0_inst
(
    .clka                               (sys_clk                   ),// input wire clka
    .addra                              (addra                     ),// input wire [3 : 0] addra
    .douta                              (signal                    ) // output wire [2 : 0] douta
);






                                                                   
endmodule