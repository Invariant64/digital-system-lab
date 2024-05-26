module top (
    input clk,
    input rst,
    
    input [3:0] col,
    output [3:0] row,
    output out_buzzer
);
    wire [3:0] data;
    wire [16:0] N;
    wire [3:0] row_4;
    wire clk_1khz;
	wire en, en_fd;
    
    frequency_divider fqcd(
        .clk_50mhz(clk),
        .rst(rst),
        .clk(clk_1khz)
    );

    scanner sc(
        .clk_1khz(clk_1khz),
        .col(col),
        .row(row),
        .out(data),
		  .en(en)
    );

    frequency fqc (
        .data(data),
        .N(N)
    );

    fd fd_0 (
        .clk(clk),
        .in(en),
        .out(en_fd)
    );

    buzzer bz (
		.en(en_fd),
        .clk_50mhz(clk),
        .N(N),
        .out_buzzer(out_buzzer)
    );
	 
endmodule