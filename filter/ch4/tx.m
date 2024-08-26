%%
clc;
clear all;

[b,a]=cheby2(7,60,0.5) ;
m=max(max(abs(a),abs(b))); %获取滤波器系数向量中绝对值最大的数
Qb=round(b/m*(2^(12-1)-1)); %四舍五入截尾
Qa=round(a/m*(2^(12-1)-1)); %四舍五入截尾

m=max(max(abs(a),abs(b))); %获取滤波器系数向量中绝对值最大的数
Qm=floor(log2(m/a(1))); %获取系数中最大值与 a(1)的整数倍
if Qm<log2(m/a(1)) 
 Qm=Qm+1; 
end 
Qm=2^Qm; %获取量化基准值 
Qb=round(b/Qm*(2^(12-1)-1)) %四舍五入截尾
Qa=round(a/Qm*(2^(12-1)-1)) %四舍五入截尾

[b,a]=cheby2(7,60,0.5); 
[b0,B,A]=E5_51_dir2cas(b,a) 