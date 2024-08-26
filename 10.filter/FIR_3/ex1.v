 
// --这是 SymbExam.v 文件的程序清单
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
// Last modified Date:     2024/08/24 16:04:47
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/24 16:04:47
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              ex1.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\10.filter\ch3\ex1.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//
                                                               
module SymbExam (
    d1,
    d2,
    signed_out,
    unsigned_out);


    input              [   3: 0]        d1                         ;//输入加数 1 
    input              [   3: 0]        d2                         ;//输入加数 2 
    output             [   3: 0]        unsigned_out               ;//无符号加法输出
    output      signed [   3: 0]        signed_out                 ;//有符号加法输出
 //无符号加法运算
 assign unsigned_out = d1 + d2; 
 
 //有符号加法运算
 wire signed [3:0] s_d1; 
 wire signed [3:0] s_d2; 
 assign s_d1 = d1; 
 assign s_d2 = d2; 
 assign signed_out = s_d1 + s_d2; 
 
endmodule