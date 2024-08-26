%%
clc;
clear all;

% 设定参数
Fs = 100000; % 采样频率 10kHz
T = 1e-2; % 总时长 1秒
t = 0:1/Fs:T-1/Fs; % 时间向量

% 生成信号（这里使用之前的合成信号）
f1 = 1000; % 频率 1kHz
signal1 = sin(2*pi*f1*t);
f2 = 2000; % 频率 2kHz
signal2 = sin(2*pi*f2*t);
combined_signal = signal1 + signal2;

% 设计滤波器的脉冲响应
% 例如，使用fir1函数设计一个FIR滤波器
filter_order = 500; % 滤波器阶数
cutoff_freq = 1500; % 截止频率 1.5kHz
h = fir1(filter_order, cutoff_freq/(Fs/2)); % 得到滤波器的脉冲响应

% 进行卷积
filtered_signal = conv(combined_signal, h, 'same'); % 'same'选项确保输出信号与原始信号长度相同

figure;
plot(t, combined_signal);

% 绘制滤波后的信号
figure;
plot(t, filtered_signal);
title('Filtered Signal using Convolution');
xlabel('Time (seconds)');
ylabel('Amplitude');
grid on;