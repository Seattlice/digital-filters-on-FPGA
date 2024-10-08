//FirParallel.v 文件的程序清单 并行FIR滤波器
module FirParallel (rst,clk,Xin,Yout);
 
    input                               rst                        ;//复位信号，高电平有效
    input                               clk                        ;//数据抽样时钟和 FPGA 系统时钟的频率为 2 kHz 
    input       signed [  11: 0]        Xin                        ;//数据输入频率为 2 kHz 
    output      signed [  28: 0]        Yout                       ;//滤波后的输出数据


 //将数据存入寄存器 Xin_Reg 中
    reg      signed    [  11: 0]        Xin_Reg[15:0]              ;
    reg                [   3: 0]        i,j                        ;


        always @(posedge clk or posedge rst)
            if (rst)
                //初始化寄存器的值为 0 
                begin
                for (i=0; i<15; i=i+1)
                Xin_Reg[i]=12'd0;
                end
            else
                begin
                //与串行结构不同，此处不需要判断计数器的状态
                for (j=0; j<15; j=j+1)
                Xin_Reg[j+1] <= Xin_Reg[j];
                Xin_Reg[0] <= Xin;
        end
        
 //将对称系数的输入数据相加，同时将对应的滤波器系数送入乘法器
 //为了进一步提高运行速度，另外增加了一级寄存器
    reg      signed    [  12: 0]        Add_Reg[7:0]               ;
        always @(posedge clk or posedge rst)
            if (rst)
                //初始化寄存器的值为 0 
                begin
                for (i=0; i<8; i=i+1)
                Add_Reg[i]=13'd0;
                end
            else
                begin
                for (i=0; i<8; i=i+1)
                Add_Reg[i]={Xin_Reg[i][11],Xin_Reg[i]} + {Xin_Reg[15-i][11],Xin_Reg[15-i]};
        end


 //与串行结构不同，另外需要实例化 8 个乘法器 IP 核
 //实例化有符号数乘法器 IP 核 mult 
    wire     signed    [  11: 0]        coe[7:0]                   ;//滤波器系数为 12 比特量化数据
    wire     signed    [  24: 0]        Mout[7:0]                  ;//乘法器输出为 25 比特数据

    assign                              coe[0]                    = 12'h000;
    assign                              coe[1]                    = 12'hffd;
    assign                              coe[2]                    = 12'h00f;
    assign                              coe[3]                    = 12'h02e;
    assign                              coe[4]                    = 12'hf8b;
    assign                              coe[5]                    = 12'hef9;
    assign                              coe[6]                    = 12'h24e;
    assign                              coe[7]                    = 12'h7ff;

        mult Umult0 (
    .CLK                                (clk                       ),
    .A                                  (coe[0]                    ),
    .B                                  (Add_Reg[0]                ),
    .P                                  (Mout[0])                  );
            
        mult Umult1 (
    .CLK                                (clk                       ),
    .A                                  (coe[1]                    ),
    .B                                  (Add_Reg[1]                ),
    .P                                  (Mout[1])                  );
            
        mult Umult2 (
    .CLK                                (clk                       ),
    .A                                  (coe[2]                    ),
    .B                                  (Add_Reg[2]                ),
    .P                                  (Mout[2])                  );

        mult Umult3 (
    .CLK                                (clk                       ),
    .A                                  (coe[3]                    ),
    .B                                  (Add_Reg[3]                ),
    .P                                  (Mout[3])                  );

        mult Umult4 (
    .CLK                                (clk                       ),
    .A                                  (coe[4]                    ),
    .B                                  (Add_Reg[4]                ),
    .P                                  (Mout[4])                  );

        mult Umult5 (
    .CLK                                (clk                       ),
    .A                                  (coe[5]                    ),
    .B                                  (Add_Reg[5]                ),
    .P                                  (Mout[5])                  );

        mult Umult6 (
    .CLK                                (clk                       ),
    .A                                  (coe[6]                    ),
    .B                                  (Add_Reg[6]                ),
    .P                                  (Mout[6])                  );

        mult Umult7 (
    .CLK                                (clk                       ),
    .A                                  (coe[7]                    ),
    .B                                  (Add_Reg[7]                ),
    .P                                  (Mout[7])                  );
 
    //将滤波器系数与输入数据的乘法结果累加，并输出滤波后的数据
    //与串行结构不同，此处在一个时钟周期内直接将所有乘法器结果相加

    reg      signed    [  28: 0]        sum                        ;
    reg      signed    [  28: 0]        yout                       ;
    reg                [   3: 0]        k                          ;

    always @(posedge clk or posedge rst)
        if (rst)
            begin
            sum = 29'd0;
            yout <= 29'd0;
            end
        else
            begin
            yout <= sum;
            sum = 29'd0;
            for (k=0; k<8; k=k+1)
                sum = sum+Mout[k];
        end

    assign                              Yout                      = yout;
 
endmodule