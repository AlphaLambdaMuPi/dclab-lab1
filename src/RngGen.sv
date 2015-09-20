module RngGen(
    input i_clk,
    output [3:0] o_rnd
);

parameter a = 32'd22695477;
parameter b = 32'd1; 
reg [15:0] counter;
reg [31:0] state;

always @(posedge i_clk) begin
    if (counter == 32'd10007) begin
        state <= (a * state + b);
        counter <= 0;
    end
    else 
        counter <= counter + 1;
end

assign o_rnd = state[19:16];

endmodule
