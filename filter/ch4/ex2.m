%%
clc;
clear all;


%E5_31_DirectArith.m; 
fs=2000; %抽样频率
fc=500; %阻带截止频率
Rs=60; %阻带衰减（dB）
N=7; %IIR 滤波器阶数
Qcoe=[8 12]; %IIR 滤波器系数字长
Qout=[12 24]; %IIR 滤波器输出字长
delta=[1,zeros(1,511)]; %单位冲激信号作为输入信号
[b,a]=cheby2(N,Rs,2*fc/fs); %设计切比雪夫 II 型低通 IIR 滤波器
%对 IIR 滤波器系数进行量化，四舍五入截尾
m=max(max(abs(a),abs(b))); %获取 IIR 滤波器系数向量中绝对值最大的数
Qm=floor(log2(m/a(1))); %取系数中最大值与 a(1)的整数倍
if Qm<log2(m/a(1)) 
 Qm=Qm+1; 
end 
Qm=2^Qm; %获取量化基准值，使得量化后的 Qa[1]为 2 的整数幂次方 
Qb8=round(b/Qm*(2^(Qcoe(1)-1)-1)) 
Qa8=round(a/Qm*(2^(Qcoe(1)-1)-1)) 
Qb12=round(b/Qm*(2^(Qcoe(2)-1)-1)) 
Qa12=round(a/Qm*(2^(Qcoe(2)-1)-1)) 
%求理想幅度响应
y=filter(b,a,delta); 
%求量化后的幅度响应，E5_32_QuantIIRDirectArith 为自编的根据系数及输出数据位数的量化函数
%IIR 滤波器输出的函数
c8o12=E5_32_QuantIIRDirectArith(Qb8,Qa8,delta,Qcoe(1),Qout(1));
c8o24=E5_32_QuantIIRDirectArith(Qb8,Qa8,delta,Qcoe(1),Qout(2));
c12o12=E5_32_QuantIIRDirectArith(Qb12,Qa12,delta,Qcoe(2),Qout(1)); 
c12o24=E5_32_QuantIIRDirectArith(Qb12,Qa12,delta,Qcoe(2),Qout(2)); 
%求 IIR 滤波器输出幅频响应
Fy=20*log10(abs(fft(y))); Fy=Fy-max(Fy); 
Fc8o12=20*log10(abs(fft(c8o12))); Fc8o12=Fc8o12-max(Fc8o12); 
Fc8o24=20*log10(abs(fft(c8o24))); Fc8o24=Fc8o24-max(Fc8o24); 
Fc12o12=20*log10(abs(fft(c12o12))); Fc12o12=Fc12o12-max(Fc12o12); 
Fc12o24=20*log10(abs(fft(c12o24))); Fc12o24=Fc12o24-max(Fc12o24); 
 %设置幅频响应的横坐标，单位为 Hz 
 x_f=[0:(fs/length(delta)):fs-1]; 
 figure(1); 
 plot(x_f,Fy,'-',x_f,Fc8o12,'.',x_f,Fc8o24,'-.'); 
 axis([0 fs/2 -100 5]); %只显示正频率部分的幅频响应 
 xlabel('频率(Hz)');ylabel('幅度(dB)'); 
 legend('理想输出','8 比特系数及 12 比特输出量化结果','8 比特系数 24 比特输出量化结果'); grid; 
 figure(2); 
 plot(x_f,Fy,'-',x_f,Fc12o12,'.',x_f,Fc12o24,'-.'); 
 axis([0 fs/2 -100 5]); %只显示正频率部分的幅频响应 
 xlabel('频率(Hz)');ylabel('幅度(dB)'); 
 legend('理想输出','12 比特系数及 12 比特输出量化结果','12 比特系数 24 比特输出量化结果'); grid; 