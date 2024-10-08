//FourthTap.v 的程序清单
module FourthTap (rst,clk,Xin,Yout); 
 
 input rst; //复位信号，高电平有效
 input clk; //FPGA 系统时钟，频率为 2 kHz 
 input signed [10:0] Xin; //数据输入频率为 2 kHz 
 output signed [11:0] Yout; //滤波后的输出数据
 
 //零点系数的实现代码
 reg signed[10:0] Xin1; 
 always @(posedge clk or posedge rst) 
 if (rst) 
 //初始化寄存器的值为 0 
 Xin1 <= 11'd0; 
 else 
 Xin1 <= Xin; 
 //采用移位运算及加法运算实现乘法运算
wire signed [21:0] XMult_zer; 
 wire signed [21:0] XMUlt_fir; 
 assign XMult_zer = {Xin,11'd0}; //*2048 
 assign XMUlt_fir = {Xin1,11'd0}; //*2048 
 //对 IIR 滤波器系数与输入数据乘法结果进行累加
 wire signed [22:0] Xout; 
 assign Xout = {XMult_zer[21],XMult_zer} + {XMUlt_fir[21],XMUlt_fir}; 
 
 //极点系数的实现代码
 wire signed[11:0] Yin; 
 reg signed[11:0] Yin1; 
 always @(posedge clk or posedge rst) 
 if (rst) 
 //初始化寄存器的值为 0 
 Yin1 <= 12'd0; 
 else 
 Yin1 <= Yin; 
 //采用移位运算及加法运算实现乘法运算
 wire signed [23:0] YMult1; 
 wire signed [23:0] Ysum; 
 wire signed [23:0] Ydiv; 
 assign YMult1 = {{4{Yin1[11]}},Yin1,8'd0}+{{8{Yin1[11]}},Yin1,4'd0}+ 
 {{10{Yin1[11]}},Yin1,2'd0}; //*276 
 assign Ysum = Xout + YMult1; 
 assign Ydiv = {{11{Ysum[23]}},Ysum[23:11]}; 
 
 //根据仿真结果可知，第 4 级 IIR 滤波器的输出范围可用 12 比特表示
 assign Yin = (rst ? 12'd0 : Ydiv[11:0]); 
 assign Yout = Yin; 
 
endmodule