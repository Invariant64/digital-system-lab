module top (
    input clk_50mhz,
    input rst,

    output [7:0] decodeout,
    output [7:0] ds
);

    wire clk_1khz;

    frequency_divider frequency_divider_inst (
        .clk_50mhz(clk_50mhz),
        .rst(rst),
        .clk(clk_1khz)
    );

    wire [4*8-1:0] clock_out;

    clock clock_inst (
        .clk_50mhz(clk_50mhz),
        .rst(rst),
        .pause(0),
        .out(clock_out)
    );

    wire [4*8*4-1:0] display_in;

    assign display_in = {clock_out, clock_out, clock_out, clock_out};

    display display_inst (
        .clk_1khz(clk_1khz),
        .rst(rst),
        .mode(2'b00),
        .in(display_in),
        .decodeout(decodeout),
        .ds(ds)
    );

endmodule