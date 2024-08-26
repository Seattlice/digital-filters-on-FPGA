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
// Last modified Date:     2024/08/25 23:26:27
// Last Version:           V1.0
// Descriptions:           
//----------------------------------------------------------------------------------------
// Created by:             Li Hualou
// Created date:           2024/08/25 23:26:27
// mail      :             Please Write mail 
// Version:                V1.0
// TEXT NAME:              tb_fir.v
// PATH:                   C:\Users\Administrator\Desktop\SORCE\verilog\stu\10.filter\ch3\tb_fir.v
// Descriptions:           
//                         
//----------------------------------------------------------------------------------------
//****************************************************************************************//

module tb_fir();

    reg                                 sys_rst_n                  ;
    reg                                 sys_clk                    ;

    wire               [  11: 0]        signal                     ;
    wire               [  28: 0]        fir_seri_data              ;
    wire               [  28: 0]        fir_para_data              ;

initial sys_clk = 1'd1;
always #20 sys_clk = ~sys_clk;

initial begin
sys_rst_n <= 1'd1;
#20 sys_rst_n <= 1'd0;
end

    reg                [  11: 0]        matlab_signal                 [0:1023]  ;
    reg                [   9: 0]        addr                       ;
    reg                [  11: 0]        data_out                   ;

initial
begin
  $readmemh("C:/Users/Administrator/Desktop/SORCE/matlab/filter/mix_Data.txt",matlab_signal);
  addr  = 10'd0;
end

//#20为并行滤波器可用
//#320为串行滤波器可用
//#20
always #20
begin
  data_out  =  matlab_signal[addr][11:0] ;
  addr = addr + 10'd1;
  
  if (addr == 10'd1023)
    $stop;
  
end

assign signal  = data_out ;

FirFullSerial FirFullSerial_inst
(
    .rst                                (sys_rst_n                 ),
    .clk                                (sys_clk                   ),
    .Xin                                (signal                    ),
    .Yout                               (fir_seri_data             ) 
    );

FirParallel FirParallel_inst
(
    .rst                                (sys_rst_n                 ),
    .clk                                (sys_clk                   ),
    .Xin                                (signal                    ),
    .Yout                               (fir_para_data             ) 
    );


wire s_axis_data_tready;
wire signed [31:0] m_axis_data_tdata;
wire m_axis_data_tvalid;
wire [23:0] FIR_IP_BUS;
wire [15:0] signal_ip;

assign signal_ip = {{4{signal[11]}},signal};
assign FIR_IP_BUS = m_axis_data_tdata[23:0];

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
FIR_IP FIR_IP_inst (
    .aclk                               (sys_clk                   ),// input wire aclk
    .s_axis_data_tvalid                 (1'b1                      ),// input wire s_axis_data_tvalid
    .s_axis_data_tready                 (s_axis_data_tready        ),// output wire s_axis_data_tready
    .s_axis_data_tdata                  ( signal_ip                 ),// input wire [15 : 0] s_axis_data_tdata
    .m_axis_data_tvalid                 (m_axis_data_tvalid        ),// output wire m_axis_data_tvalid
    .m_axis_data_tdata                  (m_axis_data_tdata         ) // output wire [31 : 0] m_axis_data_tdata
);
                                                                   
endmodule