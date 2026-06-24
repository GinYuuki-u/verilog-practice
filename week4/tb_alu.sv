// tb_alu.sv —— ALU 自动对拍 testbench（修正版：用 $fscanf 逐行读，不会错位）
// 流程：打开 vectors.hex → 每次读一行的 6 个字段 → 喂给 alu → 比对 → 统计 pass/fail
`timescale 1ns/1ps

module tb_alu;

    localparam WIDTH = 16;

    // ---- 连到 alu 的信号 ----
    logic [WIDTH-1:0] a, b;
    logic [2:0]       op;
    logic             cin;
    logic [WIDTH-1:0] result;
    logic             zero, carry, overflow, negative;

    // ---- 实例化被测对象 ----
    alu #(.WIDTH(WIDTH)) dut (
        .a(a), .b(b), .op(op), .cin(cin),
        .result(result), .zero(zero), .carry(carry),
        .overflow(overflow), .negative(negative)
    );

    // ---- 读文件用的变量 ----
    integer fd;          // 文件句柄
    integer code;        // $fscanf 返回值（成功读到几个字段）
    integer line_no;     // 当前是第几行（从 0 数）
    integer pass_cnt, fail_cnt;

    // 从文件每行读出来的 6 个字段（用大一点的位宽接，避免截断）
    logic [WIDTH-1:0] f_a, f_b;
    logic [2:0]       f_op;
    logic             f_cin;
    logic [WIDTH-1:0] exp_result;   // 期望的 result（标准答案）
    logic             exp_carry;    // 期望的 carry（标准答案）

    initial begin
        fd = $fopen("vectors.hex", "r");
        if (fd == 0) begin
            $display("ERROR: 打不开 vectors.hex，确认它和 tb 在同一目录");
            $finish;
        end

        pass_cnt = 0;
        fail_cnt = 0;
        line_no  = 0;

        $display("==== ALU 对拍开始 ====");

        // 每行格式： a b op cin exp_result exp_carry （全部十六进制，空格分隔）
        // %h 读十六进制；一次读 6 个；返回值 code=6 表示这行读全了
        while (!$feof(fd)) begin
            code = $fscanf(fd, "%h %h %h %h %h %h",
                           f_a, f_b, f_op, f_cin, exp_result, exp_carry);
            if (code == 6) begin
                // ---- 喂给 alu ----
                a   = f_a;
                b   = f_b;
                op  = f_op;
                cin = f_cin;
                #1;   // 等组合逻辑稳定

                // ---- 判卷：比对 result 和 carry ----
                if (result === exp_result && carry === exp_carry) begin
                    pass_cnt = pass_cnt + 1;
                end else begin
                    fail_cnt = fail_cnt + 1;
                    $display("ERROR @line %0d | a=%h b=%h op=%h cin=%b",
                             line_no, f_a, f_b, f_op, f_cin);
                    $display("        result: got=%h exp=%h %s",
                             result, exp_result, (result===exp_result)?"":"<-- MISMATCH");
                    $display("        carry : got=%b exp=%b %s",
                             carry, exp_carry, (carry===exp_carry)?"":"<-- MISMATCH");
                end
                line_no = line_no + 1;
            end
        end

        $fclose(fd);

        $display("==== 对拍结束 ====");
        $display("PASS: %0d / %0d", pass_cnt, line_no);
        $display("FAIL: %0d / %0d", fail_cnt, line_no);
        if (fail_cnt == 0)
            $display(">>> 全部通过！ALU 验证成功 <<<");
        else
            $display(">>> 有 %0d 条失败，看上面 ERROR 定位 <<<", fail_cnt);

        $finish;
    end

endmodule