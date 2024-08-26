%E2_1_BasicWave.m 文件源代码
%产生方波、三角波及正弦波序列信号
%定义参数
Ps=10; %正弦波信号功率为 10 dBW 
Pn=1; %噪声信号功率为 0 dBW 
f=100; %信号频率为 100 Hz 
Fs=1000; %抽样频率为 1 kHz 
width=0.5; %函数 sawtooth()的尺度值为 0.5 
duty=50; %函数 square()的占空比参数为 50 
%产生信号
t=0:1/Fs:0.1; 
c=2*pi*f*t; 
%%
clc;
clear all;

sq=square(c,duty); %产生方波信号
tr=sawtooth(c,width); %产生三角波信号
si=sin(c); %产生正弦波信号
%产生随机信号序列
noi=rand(1,length(t)); %产生均匀分布的随机信号序列
noise=randn(1,length(t)); %产生高斯白噪声信号序列
%产生带有加性高斯白噪声的正弦波信号序列
sin_noise=sqrt(2*Ps)*si+sqrt(Pn)*noise; 
sin_noise=sin_noise/max(abs(sin_noise)); %归一化处理
%画图
subplot(321); plot(t,noi); axis([0 0.1 -1.1 1.1]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-1.3,0]); ylabel('幅度(V)','fontsize',8); 
title('均匀分布的随机信号序列','fontsize',8); 
subplot(322); plot(t,noise); axis([0 0.1 -max(abs(noise)) max(abs(noise))]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-3.2,0]); ylabel('幅度(V)','fontsize',8); 
title('高斯白噪声信号序列','fontsize',8); 
subplot(323); plot(t,sq); axis([0 0.1 -1.1 1.1]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-1.3,0]); ylabel('幅度(V)','fontsize',8); 
title('方波信号','fontsize',8); 
subplot(324); plot(t,tr); axis([0 0.1 -1.1 1.1]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-1.3,0]); ylabel('幅度(V)','fontsize',8); 
title('三角波信号','fontsize',8); 
subplot(325); plot(t,si); axis([0 0.1 -1.1 1.1]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-1.3,0]); ylabel('幅度(V)','fontsize',8); 
title('正弦波信号','fontsize',8); 
subplot(326); plot(t,sin_noise); axis([0 0.1 -1.1 1.1]); 
xlabel('时间(s)','fontsize',8,'position',[0.08,-1.3,0]); ylabel('幅度(V)','fontsize',8); 
title('SNR＝10dB 的加性高斯白噪声正弦波信号','fontsize',8); 