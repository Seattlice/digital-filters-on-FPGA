//--FirFullSerial.v 的程序清单
module FirFullSerial (rst,clk,Xin,Yout); 
 
    input                               rst                        ;//复位信号，高电平有效
    input                               clk                        ;// FPGA 系统时钟，频率为 16 kHz 
    input       signed [  11: 0]        Xin                        ;//数据输入频率为 2 kHz 
    output      signed [  28: 0]        Yout                       ;//滤波后的输出数据


 //实例化有符号数乘法器 IP 核 mult 
    reg      signed    [  11: 0]        coe                        ;//滤波器系数为 12 比特量化数据
    wire     signed    [  12: 0]        add_s                      ;//输入为 12 比特量化数据，两个对称系数相加需要 13 比特存储
    wire     signed    [  24: 0]        Mout                       ;

 //实例化有符号数加法器 IP 核，对输入数据进行 1 比特符号位扩展，输出结果为 13 比特数据
        mult MULT1
        (
            .CLK                                (clk                       ),// input wire CLK
            .A                                  (coe                       ),// input wire [11 : 0] A
            .B                                  (add_s                     ),// input wire [12 : 0] B
            .P                                  (Mout                      ) // output wire [24 : 0] P
        );

    reg      signed    [  12: 0]        add_a                      ;
    reg      signed    [  12: 0]        add_b                      ;


        adder Uadder (
            .A                                  (add_a                     ),// input wire [12 : 0] A
            .B                                  (add_b                     ),// input wire [12 : 0] B
            .S                                  (add_s                     ) // output wire [12 : 0] S
        );


        //3 位计数器，计数周期为 8，为输入数据速率
    reg                [   2: 0]        count                      ;

        always @(posedge clk or posedge rst)
            if (rst)
                count = 3'd0;
            else
                count = count + 1;



        //将数据存入寄存器 Xin_Reg 中
    reg                [  11: 0]        Xin_Reg[15:0]              ;
    reg                [   3: 0]        i,j                        ;

        always @(posedge clk or posedge rst) 
            if (rst) 
            //初始化寄存器的值为 0 
            begin 
                for (i=0; i<15; i=i+1) 
                    Xin_Reg[i]=12'd0; 
                end 
                else begin 
                    if (count==7) begin 
                        for (j=0; j<15; j=j+1) 
                            Xin_Reg[j+1] <= Xin_Reg[j]; 
                            Xin_Reg[0] <= Xin; 
            end 
        end 
 
            //将对称系数的输入数据相加，同时将对应的滤波器系数送入乘法器。
            //需要注意的是，下面程序只使用了一个加法器及一个乘法器资源。
            //以 8 倍数据速率调用乘法器 IP 核，由于滤波器长度为 16 比特，系数具有对称性，故可在一个数据
            //周期内完成所有 8 个滤波器系数与数据的乘法运算。
            //为了保证加法运算不溢出，输入、输出数据均扩展为 13 比特。
            always @(posedge clk or posedge rst) 
                if (rst) begin 
                    add_a <= 13'd0; 
                    add_b <= 13'd0; 
                    coe <= 12'd0;
                end 
                else begin 
                if (count==3'd0) 
                    begin 
                    add_a <= {Xin_Reg[0][11],Xin_Reg[0]}; 
                    add_b <= {Xin_Reg[15][11],Xin_Reg[15]}; 
                    coe <= 12'h000;//c0 
                    end 
                else if (count==3'd1) 
                begin 
                    add_a <= {Xin_Reg[1][11],Xin_Reg[1]}; 
                    add_b <= {Xin_Reg[14][11],Xin_Reg[14]}; 
                    coe <= 12'hffd; //c1 
                    end 
                else if (count==3'd2) 
                    begin 
                    add_a <= {Xin_Reg[2][11],Xin_Reg[2]}; 
                    add_b <= {Xin_Reg[13][11],Xin_Reg[13]}; 
                    coe <= 12'h00f; //c2 
                    end 
                else if (count==3'd3) 
                    begin 
                    add_a <= {Xin_Reg[3][11],Xin_Reg[3]}; 
                    add_b <= {Xin_Reg[12][11],Xin_Reg[12]}; 
                    coe <= 12'h02e; //c3 
                    end 
                else if (count==3'd4) 
                    begin 
                    add_a <= {Xin_Reg[4][11],Xin_Reg[4]}; 
                    add_b <= {Xin_Reg[11][11],Xin_Reg[11]}; 
                    coe <= 12'hf8b; //c4 
                    end 
                else if (count==3'd5) 
                    begin 
                    add_a <= {Xin_Reg[5][11],Xin_Reg[5]}; 
                    add_b <= {Xin_Reg[10][11],Xin_Reg[10]}; 
                    coe <= 12'hef9; //c5 
                    end 
                else if (count==3'd6) 
                    begin 
                    add_a <= {Xin_Reg[6][11],Xin_Reg[6]}; 
                    add_b <= {Xin_Reg[9][11],Xin_Reg[9]}; 
                    coe <= 12'h24e; //c6 
                    end 
                else 
                    begin 
                    add_a <= {Xin_Reg[7][11],Xin_Reg[7]};
                    add_b <= {Xin_Reg[8][11],Xin_Reg[8]}; 
                    coe <= 12'h7ff; //c7 
                    end 
                end 

        //对滤波器系数与输入数据的乘法结果进行累加，并输出滤波后的数据。
        //考虑到乘法器及累加器的延时，需要在计数器 count=2 时对累加器清零，同时输出滤波器结果。
        //类似的延时长度一方面可通过精确计算获取，但更好的方法是通过行为仿真查看。
    reg      signed    [  28: 0]        sum                        ;
    reg      signed    [  28: 0]        yout                       ;

        always @(posedge clk or posedge rst) 
            if (rst) 
                begin 
                sum = 29'd0; 
                yout <= 29'd0; 
                end 
            else 
                begin 
                if (count==2) 
                    begin 
                    yout <= sum; 
                    sum = 29'd0; 
                    sum =sum + Mout; 
                    end 
                else 
                    sum = sum + Mout; 
                    end 

    wire               [  24: 0]        Yout_bus                   ;
    assign                              Yout                      = yout;
    assign                              Yout_bus                  = Yout[24:0];

endmodule