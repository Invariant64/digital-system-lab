module clock (
    input clk_1khz,
    input rst,
    input set_en,
    input switch,
    input add,
    input [4*8-1:0] alarm_set,
    output reg alarm_ringing,
    output [4*8-1:0] out
);

    reg [15:0] tick;

    reg [6:0] rsec, rmin, rhr;
    reg [6:0] rsec_set, rmin_set, rhr_set;

    parameter S_CLOCK = 2'b00;
    parameter S_SET_MIN = 2'b01;
    parameter S_SET_HR = 2'b10;

    reg [1:0] state;

    always @(posedge switch) begin
        if (rst) begin
            state <= S_CLOCK;
        end else if (~set_en) begin
            state <= S_CLOCK;
        end else if (set_en) begin
            case (state)
                S_CLOCK: begin
                    state <= S_SET_MIN;
                end
                S_SET_MIN: begin
                    state <= S_SET_HR;
                end
                S_SET_HR: begin
                    state <= S_CLOCK;
                end
            endcase
        end
    end

    always @(posedge clk_1khz) begin
        if (rst) begin
            tick <= 0;
            rsec <= 0;
            rmin <= 0;
            rhr <= 0;
        end else if (~set_en || state == S_CLOCK) begin
            tick <= tick + 1;
            if (tick == 1000) begin
                tick <= 0;
                rsec <= rsec + 1;
                if (rsec == 60) begin
                    rsec <= 0;
                    rmin <= rmin + 1;
                    if (rmin == 60) begin
                        rmin <= 0;
                        rhr <= rhr + 1;
                        if (rhr == 24) begin
                            rhr <= 0;
                        end
                    end
                end
            end
        end else if (set_en && state != S_CLOCK) begin
            tick <= 0;
            case (state)
                S_SET_MIN: begin
                    rmin <= rmin_set;
                end
                S_SET_HR: begin
                    rhr <= rhr_set;
                end
            endcase
        end
    end

    always @(posedge add) begin
        if (rst) begin
            rsec_set <= 0;
            rmin_set <= 0;
            rhr_set <= 0;
        end else if (~set_en) begin
            rsec_set <= rsec;
            rmin_set <= rmin;
            rhr_set <= rhr;
        end else if (set_en) begin
            case (state)
                S_SET_MIN: begin
                    rmin_set <= rmin_set == 59 ? 0 : rmin + 1;
                end
                S_SET_HR: begin
                    rhr_set <= rhr_set == 23 ? 0 : rhr + 1;
                end
            endcase
        end
    end

    wire [4*8-1:0] time_out;

    assign time_out[3:0] = rsec % 10;
    assign time_out[7:4] = rsec / 10;
    assign time_out[11:8] = 4'b1110;
    assign time_out[15:12] = rmin % 10;
    assign time_out[19:16] = rmin / 10;
    assign time_out[23:20] = 4'b1110;
    assign time_out[27:24] = rhr % 10;
    assign time_out[31:28] = rhr / 10;

    reg [15:0] cnt;
    reg [31:0] mask;

    always @(posedge clk_1khz or posedge rst) begin
        if (rst) begin
            cnt <= 0;
        end else if (set_en) begin
            cnt <= cnt + 1;
            if (cnt >= 500) begin
                cnt <= 0;
                case (state)
                    S_CLOCK: begin
                        mask <= 32'h00000000;
                    end
                    S_SET_MIN: begin
                        mask <= { 12'h0000, ~mask[19:12], 12'h0000 };
                    end
                    S_SET_HR: begin
                        mask <= { ~mask[31:24], 24'h000000 };
                    end
                endcase
            end
        end
    end

    assign out = set_en ? time_out | mask : time_out;

    always @(posedge clk_1khz) begin
        if (rst) begin
            alarm_ringing <= 0;
        end else if (out == alarm_set) begin
            alarm_ringing <= 1;
        end else if (~switch) begin
            alarm_ringing <= 0;
        end
    end
    
endmodule