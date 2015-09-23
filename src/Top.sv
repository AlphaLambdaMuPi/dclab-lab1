module Top(
    input i_clk,
    input i_start,
    output [3:0] o_random_out,
    output o_led_on
);

reg [31:0] s_clock;
reg [3:0] cur_number;
reg [3:0] final_number;
reg [3:0] ticks_cnt;
reg [31:0] cur_tick_clocks;
wire [3:0] random;

parameter IDLE = 2'b00;
parameter START = 2'b01;
parameter BLINK = 2'b11;
parameter total_ticks_cnt = 4'd15;
parameter init_tick_clocks = (1 << 23);

wire tick_ended, process_ended;
assign tick_ended = (s_clock == cur_tick_clocks);
assign process_ended = (tick_ended && ticks_cnt == total_ticks_cnt);

reg is_on;

initial begin
  is_on = 1;
end

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
        is_on <= 1;
    end
    else begin
        s_clock <= s_clock + 1;
        if (cur_state == START) begin
            // If started

            if (tick_ended) begin
                // if ended 

                cur_number <= random;
                ticks_cnt <= ticks_cnt + 1;
                s_clock <= 0;
                cur_tick_clocks <= (cur_tick_clocks >> 3) * 9;
            end 
            if (process_ended) begin
                // If s_clock contains a single '1' yi-zi
                cur_state <= BLINK;
                final_number <= random;
                s_clock <= 0;
                ticks_cnt <= 6;
                cur_tick_clocks <= (32'd1 << 25);
                is_on <= 1;
            end
        end
        else if (cur_state == BLINK) begin
            if (tick_ended) begin
                is_on <= ~is_on;
                ticks_cnt <= ticks_cnt + 1;
                s_clock <= 0;
            end
            if (process_ended) begin
                cur_state <= IDLE;
            end
        end
    end
end

assign o_random_out = cur_number;
assign o_led_on = is_on;

endmodule
