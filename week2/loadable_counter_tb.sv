`timescale 1ns/1ps              // 时间单位:#1 = 1ns

module loadable_counter_tb;              // testbench 自己是个模块,但【没有端口】——它是顶层

    // ① 声明连到 DUT 的信号(testbench 这边的"线和开关")
    logic       clk;
    logic       rst;
    logic       load;
    logic [3:0] data;
    logic [3:0] count;

   // ② 例化 DUT(loadable counter例化)
    loadable_counter #(.WIDTH(4)) dut(
        .clk    (clk),
        .rst    (rst),
        .load   (load),
        .data   (data),
        .count  (count)
    );

    // ③ 造时钟
    initial clk = 0;        // 时钟初值
    always #5 clk = ~clk;   // 每 5ns 翻转 → 10ns 周期

    // ④ 波形记录
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0,loadable_counter_tb);
    end

    // ⑤ 激励
    initial begin
        rst = 1; load = 0; data = 0; 
        #12
        rst = 0;
        #40
        load = 1; data = 10;
        #50 
        load = 0; data = 10;
        #70;
        rst = 1; data = 10;
        #80
        load = 1; data = 15;
        #20
        $finish;
    end
endmodule

