fs=8000; %抽样频率
fc=[1000 1500]; %过渡带
mag=[1 0]; %窗函数的理想滤波器幅度
dev=[0.01 0.05]; %纹波
[n,wn,beta,ftype]=kaiserord(fc,mag,dev,fs) %获取凯塞窗函数参数
fpm=[0 fc(1)*2/fs fc(2)*2/fs 1]; %firpm 函数的频段向量
magpm=[1 1 0 0]; %firpm 函数的幅值向量
%设计凯塞窗及海明窗滤波器
h_kaiser=fir1(n,wn,ftype,kaiser(n+1,beta)); 
h_hamm=fir1(n,fc(2)*2/fs); 
%设计最优滤波器
h_pm=firpm(n,fpm,magpm); 
%求滤波器的幅频响应
m_kaiser=20*log10(abs(fft(h_kaiser,1024))); 
m_hamm=20*log10(abs(fft(h_hamm,1024))); 
m_pm=20*log10(abs(fft(h_pm,1024))); 
%设置幅频响应的横坐标单位为 Hz 
x_f=[0:(fs/length(m_kaiser)):fs/2]; 
%只显示正频率部分的幅频响应
m1=m_kaiser(1:length(x_f)); 
m2=m_hamm(1:length(x_f)); 
m3=m_pm(1:length(x_f)); 
%绘制幅频响应曲线
plot(x_f,m1,'-',x_f,m2,'-.',x_f,m3,'--'); 
xlabel('频率(Hz)');ylabel('幅度(dB)'); 
legend('凯塞窗滤波器','海明窗滤波器','最优滤波器'); grid;