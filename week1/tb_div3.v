module tb_div3;
    reg clk_in = 0, rst = 1;
    wire clk_div3;

    div3 u(clk_in, rst, clk_div3);
    always #5 clk_in = ~ clk_in;


    initial begin
        $dumpfile("wave.vcd");
        $dumpvars(0, tb_div3);
        #12 rst = 0;
        #200 $finish;
    end
endmodule