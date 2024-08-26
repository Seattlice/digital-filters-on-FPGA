function [b0,B,A]=E5_51_dir2cas(b,a); 
%将直接型 IIR 滤波器系数转换为级联型 IIR 滤波器系数
%b0：增益系数
%B：包含因子系数 bk 的 K 行 3 列矩阵
%A：包含因子系数 ak 的 K 行 3 列矩阵
%a：直接型 IIR 滤波器分母系数向量
%b：直接型 IIR 滤波器分子系数向量
%计算增益系数
b0=b(1);b=b/b0; 
a0=a(1);a=a/a0; b0=b0/a0; 
%将分子、分母系数的长度补齐并进行计算
M=length(b);N=length(a); 
if N>M 
 b=[b zeros(1,N-M)]; 
elseif M>N 
 a=[a zeros(1,M-N)]; N=M; 
else 
 N=M; 
end 
%级联型 IIR 滤波器系数向量的初始化
K=floor(N/2);B=zeros(K,3);A=zeros(K,3); 
if K*2==N 
 b=[b 0]; a=[a 0]; 
end 
%根据多项式系数，利用 roots 函数求出所有的根
%利用 cplxpair 函数按实部从小到大的顺序成对排序
broots=cplxpair(roots(b)); aroots=cplxpair(roots(a)); 
%取出复共轭对的根，并变换成多项式系数
for i=1:2:2*K 
 Brow=broots(i:1:i+1,:); 
 Brow=real(poly(Brow)); 
 B(fix(i+1)/2,:)=Brow; 
 Arow=aroots(i:1:i+1,:); 
 Arow=real(poly(Arow)); 
 A(fix(i+1)/2,:)=Arow; 
end 