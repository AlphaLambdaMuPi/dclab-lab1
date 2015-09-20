module Top(
	input i_clk,
	input i_start,
	output [3:0] o_random_out
);

reg [27:0] s_clock;
reg [3:0] counter;
wire [3:0] random;

parameter IDLE = 2'b00;
parameter START = 2'b01;

// current state = {IDLE, START}
reg [1:0] cur_state;

RngGen rngGen(
    .i_clk(i_clk),
    .o_rnd(random),
);

always @(posedge i_clk or posedge i_start) begin
    if (i_start == 1) begin 
        // User push button

        cur_state <= START;
        s_clock <= '0;
    end
    else begin
        if (cur_state == START) begin
            // If started

            s_clock <= s_clock + 1;

            if (s_clock == (28'b1 << 27)) begin
                // if ended 

                cur_state <= IDLE;
            end 
            else if (s_clock == (s_clock & (-s_clock))) begin
                // If s_clock contains a single '1' yi-zi

                counter <= random;
            end
        end
    end
end

assign o_random_out = counter;

endmodule
