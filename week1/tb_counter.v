module tb_counter;
	reg clk = 0, rst = 1;
	wire [3:0] q;
	counter u(clk, rst, q);
	always #5 clk = ~clk;
	
	initial begin
		$dumpfile("wave.vcd");
		$dumpvars(0, tb_counter);
		#12 rst = 0;
		#100 $finish;
	end
endmodule