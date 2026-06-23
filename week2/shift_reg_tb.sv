`timescale 1ns/1ps

module shift_reg_tb;

    logic rst, clk, en;
    logic [3:0] q;
    logic [3:0] expected;
    logic serial_in, serial_out;
    integer errors = 0;

    shift_reg #(.WIDTH(4)) dut(     //例化 给参数WIDTH赋值
        .clk        (clk),
        .rst        (rst),
        .en         (en),
        .q          (q),
        .serial_in  (serial_in),
        .serial_out (serial_out)

    );

    initial clk = 0;  //造时钟
    always #5 clk = ~clk;

    initial begin   //看波形
        $dumpfile("wave.vcd");
        $dumpvars(0,shift_reg_tb);
    end


    task check;    //给激励设置检查任务
        begin
            @(posedge clk);
            #1;
            if(expected !== q) begin
                $display("error t = %t: q = %d, expected = %d",$time, q, expected);
                errors = errors + 1;
            end

            else begin
                $display("PASS t = %t: q = %d",$time, q);
            end
        end
    endtask

    
    initial begin
        rst = 1; en = 0; serial_in = 0;
        expected = 0; check;

        rst = 0; serial_in = 1;
        expected = 0; check;

        en = 1; serial_in = 1;
        expected = 4'b1000; check;

        serial_in = 0;
        expected = 4'b0100; check;

        expected = 4'b0010; check;

        serial_in = 1;
        expected = 4'b1001; check;

        $finish;
    end
endmodule




                





