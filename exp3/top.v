module top (
    input clk_50mhz,
    input rst,

    input all_switch,
    input switch,
    input add,

    output [7:0] decodeout,
    output [7:0] ds,
    output buzzer
);

    wire fd_all_switch;
    wire fd_switch;
    wire fd_add;

    fd fd_all_switch_inst (
        .clk(clk_50mhz),
        .in(all_switch),
        .out(fd_all_switch)
    );

    fd fd_switch_inst (
        .clk(clk_50mhz),
        .in(switch),
        .out(fd_switch)
    );

    fd fd_add_inst (
        .clk(clk_50mhz),
        .in(add),
        .out(fd_add)
    );

    wire clk_1khz;

    frequency_divider frequency_divider_inst (
        .clk_50mhz(clk_50mhz),
        .rst(rst),
        .clk(clk_1khz)
    );

    wire [1:0] mode;

    mode_ctl mode_ctl_inst (
        .all_switch(fd_all_switch),
        .rst(rst),
        .alarm_ringing(1'b0),
        .mode(mode)
    );

    wire [4*8-1:0] clock_out;
    wire [4*8-1:0] alarm_set_out;

    wire alarm_ringing;

    clock clock_inst (
        .clk_1khz(clk_1khz),
        .rst(rst),
        .set_en(mode == 2'b01),
        .switch(fd_switch),
        .add(fd_add),
        .alarm_set(alarm_set_out),
        .alarm_ringing(alarm_ringing),
        .out(clock_out)
    );

    wire [4*8-1:0] timer_out;

    timer timer_inst (
        .clk_1khz(clk_1khz),
        .rst_n(fd_switch),
        .en(mode == 2'b10),
        .pause(fd_add),
        .out(timer_out)
    );

    wire [4*8-1:0] alarm_display_out;

    alarm_set alarm_set_inst (
        .clk_1khz(clk_1khz),
        .rst(rst),
        .en(mode == 2'b11),
        .switch(fd_switch),
        .add(fd_add),
        .display_out(alarm_display_out),
        .alarm_set_out(alarm_set_out)
    );

    wire [4*8*4-1:0] display_in;

    assign display_in = { alarm_display_out, timer_out, clock_out, clock_out };

    display display_inst (
        .clk_1khz(clk_1khz),
        .rst(rst),
        .mode(mode),
        .in(display_in),
        .decodeout(decodeout),
        .ds(ds)
    );

    buzzer buzzer_inst (
        .en(alarm_ringing),
        .clk_50mhz(clk_50mhz),
        .N(17'd50000),
        .out_buzzer(buzzer)
    );

endmodule