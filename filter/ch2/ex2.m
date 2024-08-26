%E2_2_SignalProcess.m 文件源代码
L=128; %单位抽样响应序列的长度
Fs=1000; %抽样频率为 1 kHz 
b=[0.8 0.5 0.6]; %系统函数的分子系数向量
a=[1 0.2 0.4 -0.8]; %系统函数的分母系数向量
delta=[1 zeros(1,L-1)]; %生成长度为 L 的单位抽样响应序列
FilterOut=filter(b,a,delta); %filter 函数获取单位抽样响应序列
ImpzOut=impz(b,a,L); %impz 函数获取单位抽样响应序列 
[h,f]=freqz(b,a,L,Fs); %freqz 函数求频率响应
mag=20*log(abs(h))/log(10); %幅度转换成 dB 单位 
ph=angle(h)*180/pi; %相位值单位转换
zr=roots(b) %求系统的零点，并显示在命令行窗口
pk=roots(a) %求系统的极点，并显示在命令行窗口
g=b(1)/a(1) %求系统的增益，并显示在命令行窗口
%绘图
figure(1); 
subplot(221);stem(FilterOut); 
subplot(222);stem(ImpzOut); 
subplot(223);plot(f,mag); 
subplot(224);plot(f,ph); 
figure(2); 
freqz(b,a); %用 feqz 函数绘制系统频率响应
figure(3); 
zplane(b,a); %用 zplane 函数绘制系统零/极点图