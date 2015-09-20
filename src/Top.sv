module Top(
	input i_clk,
	input i_start,
	output [3:0] o_random_out
);

reg [31:0] s_clock;
reg [3:0] cur_number;
reg [3:0] ticks_cnt;
reg [31:0] cur_tick_clocks;
wire [3:0] random;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter total_ticks_cnt = 4'd15;
parameter init_tick_clocks = (1 << 23);

wire tick_ended, process_ended;
assign tick_ended = (s_clock == cur_tick_clocks);
assign process_ended = (tick_ended && ticks_cnt == total_ticks_cnt);

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
        ticks_cnt <= '0;
        cur_tick_clocks <= init_tick_clocks;
    end
    else begin
        if (cur_state == START) begin
            // If started

            s_clock <= s_clock + 1;

            if (tick_ended) begin
                // if ended 

                cur_number <= random;
                ticks_cnt <= ticks_cnt + 1;
                s_clock <= 0;
                cur_tick_clocks <= (cur_tick_clocks >> 3) * 9;
            end 
            if (process_ended) begin
                // If s_clock contains a single '1' yi-zi

                cur_state <= IDLE;
            end
        end
    end
end

assign o_random_out = cur_number;

endmodule
