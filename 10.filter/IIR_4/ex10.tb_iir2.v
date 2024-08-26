`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/08/26 18:43:42
// Design Name: 
// Module Name: tb_IIRCas
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


module tb_IIRCas();

    reg                                 clk                        ;
    wire               [  11: 0]        din                        ;
    reg                                 rst                        ;
    wire               [  11: 0]        dout                       ;

IIRCas IIRCas_inst
(
    .rst                                (rst                       ),
    .clk                                (clk                       ),
    .din                                (din                       ),
    .dout                               (dout                      ) 
);

    parameter                           clk_period                = 626   ; //设置时钟信号周期
    parameter                           clk_half_period           = clk_period/2; 
    parameter                           data_num                  = 2000  ; //仿真数据长度
    parameter                           time_sim                  = data_num*clk_period/2; //仿真时间

    initial 
        begin 
            //设置时钟信号的初值
            clk=1; 
            //设置复位信号
            rst=1; 
            #20 rst=0; 
            // //设置仿真时间
            // #time_sim $finish; 

        end 


        //产生时钟信号
        always #clk_half_period clk=~clk; 

//从外部文本文件读入数据作为测试激励
    reg                [  11: 0]        matlab_signal                 [0:1023]  ;
    reg                [   9: 0]        addr                       ;
    reg                [  11: 0]        data_out                   ;
    assign                              din                       = data_out;

initial
begin
  $readmemh("C:/Users/Administrator/Desktop/SORCE/matlab/filter/mix_Data.txt",matlab_signal);
  addr  = 10'd0;
end

//#20为并行滤波器可用
//#320为串行滤波器可用
//#20
always #clk_half_period
begin
  data_out  =  matlab_signal[addr][11:0] ;
  addr = addr + 10'd1;
  
  if (addr == 10'd1023)
    $stop;
  
end


endmodule
