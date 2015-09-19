module Top(
	input i_clk,
	input i_start,
	output [3:0] o_random_out
);

reg [25:0] s_clock;
reg [3:0] counter;

always @(posedge i_clk) begin
    s_clock <= s_clock + 1;
    if (s_clock == '1)
        counter <= counter + 1;
end

assign o_random_out = counter;

endmodule
