module display (
    input clk_1khz,
    input rst,

    input [1:0] mode,
    input [4*8*4-1:0] in,

    output [7:0] decodeout,
    output [7:0] ds
);

    wire [3:0] display_in[7:0];
    wire [3:0] set_in[7:0];
    wire [3:0] timer_in[7:0];
    wire [3:0] alarm_set_in[7:0];

    genvar i;

    generate
        for (i = 0; i < 8; i = i + 1) begin: u1
            assign display_in[i]   = in[i*4+3  : i*4];
            assign set_in[i]       = in[i*4+35 : i*4+32];
            assign timer_in[i]     = in[i*4+67 : i*4+64];
            assign alarm_set_in[i] = in[i*4+99 : i*4+96];
        end
    endgenerate

    wire [3:0] display_out[7:0];

    generate
        for (i = 0; i < 8; i = i + 1) begin: u2
            assign display_out[i] = (mode == 2'b00) ? display_in[i] :
                                    (mode == 2'b01) ? set_in[i] :
                                    (mode == 2'b10) ? timer_in[i] :
                                    (mode == 2'b11) ? alarm_set_in[i] :
                                    4'b1111;
        end
    endgenerate

    reg [3:0] sel;

    always @(posedge clk_1khz) begin
        if (rst) begin
            sel <= 0;
        end else begin
            sel <= (sel == 7) ? 0 : sel + 1;
        end
    end

    generate
        for (i = 0; i < 8; i = i + 1) begin : u3
            assign ds[i] = (i == sel) ? 1'b0 : 1'b1;
        end
    endgenerate

    bcd_decode bcd_decode_inst (
        .indec(display_out[sel]),
        .decodeout(decodeout[6:0]),
        .dotout(decodeout[7])
    );

endmodule