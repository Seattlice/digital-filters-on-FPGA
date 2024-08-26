function hn=E4_6_FilterCoeQuant; 
fs=8000; %抽样频率
fc=[1000 1500]; %过渡带
mag=[0 1]; %窗函数的理想滤波器幅值
dev=[0.001 0.01]; %纹波
[n,wn,beta,ftype]=kaiserord(fc,mag,dev,fs) %获取 kaiserord()函数参数
fpm=[0 fc(1)*2/fs fc(2)*2/fs 1]; %firpm()函数的频段向量
magpm=[0 0 1 1]; %firpm()函数的幅值向量
%设计最优滤波器
h_pm=firpm(n,fpm,magpm); 
%对滤波器系数进行量化
h_pm12=round(h_pm/max(abs(h_pm))*(2^11-1)); %12 比特量化
h_pm14=round(h_pm/max(abs(h_pm))*(2^13-1)); %14 比特量化
hn=h_pm14; 
%进制转换
q14_hex_pm=dec2hex(h_pm14+2^14*(h_pm14<0)); 

%将生成的滤波器系数写入 FPGA 所需的文件中
fid=fopen('C:\Users\Administrator\Desktop\SORCE\matlab\滤波器\ch3\test.txt','w'); 
fprintf(fid,'%8d\r\n',h_pm);fprintf(fid,';'); 
fclose(fid); 

m_pm=20*log(abs(fft(h_pm,1024)))/log(10); m_pm=m_pm-max(m_pm); 
m_pm12=20*log(abs(fft(h_pm12,1024)))/log(10); m_pm12=m_pm12-max(m_pm12); 
m_pm14=20*log(abs(fft(h_pm14,1024)))/log(10); m_pm14=m_pm14-max(m_pm14); 
%设置幅频响应的横坐标单位为 Hz 
x_f=[0:(fs/length(m_pm)):fs/2]; 
%只显示正频率部分的幅频响应
mf_pm=m_pm(1:length(x_f)); 
mf_pm12=m_pm12(1:length(x_f)); 
mf_pm14=m_pm14(1:length(x_f)); 
%绘制幅频响应曲线
plot(x_f,mf_pm,'-',x_f,mf_pm12,'-.',x_f,mf_pm14,'--'); 
xlabel('频率(Hz)');ylabel('幅度(dB)'); 
legend('未量化','12 比特量化','14 比特量化'); 
grid;