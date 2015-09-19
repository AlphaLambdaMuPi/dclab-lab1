`timescale 1ns/100ps

module tb;
	localparam CLK = 10;
	localparam HCLK = CLK/2;

	logic clk, key;
	logic [3:0] result;
	initial clk = 0;
	always #HCLK clk = ~clk;

	Top top0(
		.i_clk(clk),
		.i_start(key),
		.o_random_out(result)
	);

	task EnableKey;
		input int n_clk;
		begin
			for (int i = 0; i < n_clk; i++) begin
				@(posedge clk);
			end
			key = 1;
			@(posedge clk)
			key = 0;
		end
	endtask

	initial begin
		$fsdbDumpfile("lab1.fsdb");
		$fsdbDumpvars;
		top0.counter_r = 0;
		key = 0;
		EnableKey(10);
		EnableKey(100);
		#(1000*CLK)
		$finish;
	end

endmodule
