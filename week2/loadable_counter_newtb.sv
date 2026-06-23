`timescale 1ns/1ps

module loadable_counter_tb;

    logic       clk, rst, load;
    logic [3:0] data, count;
    logic [3:0] expected;        // ← 新增:你维护的"标准答案"
    integer     errors = 0;      // ← 新增:记录出了几个错

    loadable_counter #(.WIDTH(4)) dut(  //之前设定过parameter，现在赋值
        .clk(clk), .rst(rst), .load(load), .data(data), .count(count)
    );

    // 时钟
    initial clk = 0;
    always #5 clk = ~clk;

    // 波形(留着也好)
    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, loadable_counter_tb);
    end

    // 一个"检查任务":等一个时钟沿,然后比对 count 和 expected
    task check;
        begin
            @(posedge clk);
            #1;
            if (count !== expected) begin
                $display("ERROR t=%0t: count=%0d expected=%0d", $time, count, expected);
                errors = errors + 1;
            end 
            else begin
                $display("PASS  t=%0t: count=%0d", $time, count);
            end
        end
    endtask

    // 激励 + 检查
    initial begin
        // ① 复位:rst=1,期望 count 变成几?
        rst = 1; load = 0; data = 0;
        expected = 0;       // ← 填:复位后 count 应该是?
        check;

        // ② 松开复位,正常计数3拍
        rst = 0;
        expected = 1;  check;    // 下一拍 count 该是?
        expected = 2;  check;
        expected = 3;  check;

        // ③ load拍
        load = 1; data = 4'd9;
        expected = 4'd9;  check;    // load 后 count 该是?

        // ④ 松开load继续计数
        load = 0;
        expected = 4'd10;  check;
        expected = 4'd11;  check;

        // 结尾:报告总成绩
        if (errors == 0) $display(">>> ALL PASS! <<<");
        else             $display(">>> %0d ERRORS <<<", errors);
        $finish;
    end

endmodule