//PoleParallel.v 的程序清单
module PoleParallel (rst,clk,Yin,Yout); 
 
    input                               rst                        ;//复位信号，高电平有效
    input                               clk                        ;//FPGA 系统时钟，频率为 2 kHz 
    input       signed [  11: 0]        Yin                        ;//数据输入频率为 2 kHz 
    output      signed [  25: 0]        Yout                       ;//滤波后的输出数据

 //将数据存入寄存器 Yin_Reg 中
    reg      signed    [  11: 0]        Yin_Reg[6:0]               ;
    reg                [   3: 0]        i,j                        ;

 always @(posedge clk or posedge rst) 
    if (rst) 
            //初始化寄存器的值为 0 
            begin 
            for (i=0; i<7; i=i+1) 
            Yin_Reg[i]=12'd0; 
            end 
    else 
            begin 
            //与串行结构不同，此处不需要判断计数器状态
            for (j=0; j<6; j=j+1) 
            Yin_Reg[j+1] <= Yin_Reg[j]; 
            Yin_Reg[0] <= Yin; 
    end 

 //实例化有符号数乘法器 IP 核 mult 
    wire     signed    [  11: 0]        coe[7:0]                   ;//滤波器系数为 12 比特量化数据
    wire     signed    [  22: 0]        Mult_Reg[6:0]              ;//乘法器输出为 23 比特数据

 //assign coe[0]=12'd512; 
    assign                              coe[1]                    = -12'd922;
    assign                              coe[2]                    = 12'd1163;
    assign                              coe[3]                    = -12'd811;
    assign                              coe[4]                    = 12'd412;
    assign                              coe[5]                    = -12'd122;
    assign                              coe[6]                    = 12'd24;
    assign                              coe[7]                    = -12'd2;


 multc12 Umult1 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[1]                    ),
    .B                                  (Yin_Reg[0]                ),
    .P                                  (Mult_Reg[0])              );

 multc12 Umult2 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[2]                    ),
    .B                                  (Yin_Reg[1]                ),
    .P                                  (Mult_Reg[1])              );

 multc12 Umult3 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[3]                    ),
    .B                                  (Yin_Reg[2]                ),
    .P                                  (Mult_Reg[2])              );

 multc12 Umult4 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[4]                    ),
    .B                                  (Yin_Reg[3]                ),
    .P                                  (Mult_Reg[3])              );

 multc12 Umult5 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[5]                    ),
    .B                                  (Yin_Reg[4]                ),
    .P                                  (Mult_Reg[4])              );

 multc12 Umult6 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[6]                    ),
    .B                                  (Yin_Reg[5]                ),
    .P                                  (Mult_Reg[5])              );

 multc12 Umult7 (
    .CLK                                (clk                       ),// input wire CLK
    .A                                  (coe[7]                    ),
    .B                                  (Yin_Reg[6]                ),
    .P                                  (Mult_Reg[6])              );
 
 //对滤波器系数与输入数据的乘法结果进行累加，并输出滤波后的数据
 assign Yout = {{3{Mult_Reg[0][22]}},Mult_Reg[0]}+{{3{Mult_Reg[1][22]}},Mult_Reg[1]}+ 
 {{3{Mult_Reg[2][22]}},Mult_Reg[2]}+{{3{Mult_Reg[3][22]}},Mult_Reg[3]}+ 
 {{3{Mult_Reg[4][22]}},Mult_Reg[4]}+{{3{Mult_Reg[5][22]}},Mult_Reg[5]}+ 
 {{3{Mult_Reg[6][22]}},Mult_Reg[6]}; 
 
endmodule 