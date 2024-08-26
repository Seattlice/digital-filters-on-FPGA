//IIRDirect.v 的程序清单
module IIRDirect (rst,clk,din,dout); 
 
    input                               rst                        ;//复位信号，高电平有效
    input                               clk                        ;//FPGA 系统时钟，频率为 2 kHz 
    input       signed [  11: 0]        din                        ;//数据输入频率为 2 kHz
    output      signed [  11: 0]        dout                       ;//滤波后的输出数据
 
        //实例化 IIR 滤波器零点系数及极点系数运算模块
            wire     signed    [  20: 0]        Xout                       ;
            wire     signed    [  11: 0]        Yin                        ;
            wire     signed    [  25: 0]        Yout                       ;
        ZeroParallel U0 (
            .rst                                (rst                       ),
            .clk                                (clk                       ),
            .Xin                                (din                       ),
            .Xout                               (Xout)                     );
        


        PoleParallel U1 (
            .rst                                (rst                       ),
            .clk                                (clk                       ),
            .Yin                                (Yin                       ),
            .Yout                               (Yout)                     );
        
            wire     signed    [  25: 0]        Ysum                       ;
            assign                              Ysum                      = {{5{Xout[20]}},Xout} - Yout;
        
        //因为 IIR 滤波器系数中 a(1)=512，需将加法结果除以 512，采用右移 9 比特的方法实现除法运算
            wire     signed    [  25: 0]        Ydiv                       ;
            assign                              Ydiv                      = {{9{Ysum[25]}},Ysum[25:9]};
        
        //根据仿真结果可知，IIR 滤波器的输出范围与输入范围相同，因此可直接进行截尾输出
            assign                              Yin                       = (rst ? 12'd0 : Ydiv[11:0]);
            assign                              dout                      = Yin;
endmodule