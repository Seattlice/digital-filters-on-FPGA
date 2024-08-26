function Qy=E5_32_QuantIIRDirectArith(Qb,Qa,din,Qcoe,Qout); 
%直接型 IIR 滤波器系数及运算字长量化仿真
%a=直接型 IIR 滤波器分母系数向量
%b=直接型 IIR 滤波器分子系数向量
%din=输入原始数据
%Qcoe=IIR 滤波器系数的量化位数
%Qout=IIR 滤波器的输出数据量化位数
%Qy=IIR 滤波器量化输出
%输出数据清零
Qy=zeros(1,length(din)); 
%根据直接型 IIR 滤波器求取量化后的输出
for i=1:length(din) 
 for j=1:length(Qb) 
 if i<j 
 Rb=0; 
 else 
 Rb=din(i-j+1); 
 end 
 if i<j+1 
 Ra=0; 
 else 
 Ra=Qy(i-j); 
 end 
 if j==length(Qa)
     Qy(i)=Qy(i)+Qb(j)*Rb; 
 else 
 Qy(i)=Qy(i)+Qb(j)*Rb-Qa(j+1)*Ra; 
 end 
 end 
 Qy(i)=Qy(i)/Qa(1); 
 Qy(i)=floor(Qy(i)*(2^(Qout-1)-1))/(2^(Qout-1)-1); %直接截尾
end 