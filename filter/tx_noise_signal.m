
%%
clc;
clear all;
%% 滤波
f1 = 200;
f2 = 800;
fs = 2000;
N = 2 ^ 11 ;%采样点数
T = N * 1 / fs; % 总时长 1秒
t = 0:1/fs:T-1/fs; % 时间向量

N1 = 11;%量化位数



noise =  0.25 * randn(1,length(t)); %产生高斯白噪声信号序列


s = round( 2 ^ N1 *  + noise  ) ;

for i=1:N
       if s(i) == 2048
           s(i) = 2047;
       end
end

%% 低通滤波器
N_F =15;       %滤波器阶数
W_F = 500;    %滤波器截止频率
WN_f = 0.4;%W_F / fs;
%b=fir1(N_F,W_F); 
b = fir1(N_F,WN_f,'low') ;
% figure;
% plot(20*log(abs(fftshift(fft(b))))/log(10));

re = conv(s , b, 'same');

B = 2^12 * b - 1 ;

%% 计算频谱
% 计算FFT
N = length(s); % 信号长度
Y = fft(s, N); % 计算FFT
Y = fftshift(Y); % 移动FFT的零频分量至中间
% 计算频率轴
F = fs*(-N/2:N/2-1)/N;

RE = fft(re, N); % 计算FFT
RE = fftshift(RE); % 移动FFT的零频分量至中间



%% 信号图
figure;
% 创建子图
subplot(2,2,1); % 2行1列的子图布局，当前激活第1个子图
plot(t,s);    % 绘制y2
title('原信号');

subplot(2,2,2); % 激活第2个子图
plot(t,re);    % 绘制y1
title('滤波后信号');


%% 频谱图
% 创建子图
subplot(2,2,3); % 2行1列的子图布局，当前激活第1个子图
plot(F,abs(Y));    % 绘制y1
title('频谱图');

subplot(2,2,4); % 激活第2个子图
plot(F,abs(RE));    % 绘制y2
title('频谱图');

%% 写TXT文件
data_txt=zeros(1,N);
data_txt=string(data_txt);
for i=1:N
       data_txt(i) = dec2hex(s(i));
       %data_txt{i}=dec2bin(s(i));
       %data_txt(i) = s(i) ;
end


fid=fopen('mix_Data.txt','w'); 
fprintf(fid,'%s\r\n',data_txt); 
fclose(fid);


% %% COE文件
% %% 创建coe文件
% fild = fopen("mix_800_200hz_signal.coe","wt");
% %写入coe文件头
% fprintf(fild,"%s\n","MEMORY_INITIALIZATION_RADIX=10;"); %10进制数
% fprintf(fild,"%s\n","MEMORY_INITIALIZATION_VECTOR=");
% for i = 1:N
%     s0(i) = round(s(i)+2 ^ 11  - 1);   %四舍五入取整数
%         if s0(i)<0          %负数强制变成0，范围在0-255
%             s0(i) = 0
%         end
%         if i == N
%             fprintf(fild,"%d",s0(i)); %数据写入
%              fprintf(fild,"%s",";"); %最后一个数据使用分号
%         else
%             fprintf(fild,"%d",s0(i)); %数据写入
%              fprintf(fild,"%s\n",","); %最后一个数据使用分号
%         end
% 
% end
% fclose(fild);