module alarm_set (
    input clk_1khz,
    input rst,
    input en,

    input switch,
    input add,

    output [4*8-1:0] display_out,
    output [4*8-1:0] alarm_set_out
);

    reg [3:0] rsec, rmin, rhr;

    parameter S_IDLE    = 2'b00;
    parameter S_SET_MIN = 2'b01;
    parameter S_SET_HR  = 2'b10;

    reg [1:0] state;

    always @(posedge switch or posedge rst) begin
        if (rst) begin
            state <= S_IDLE;
        end else if (en) begin
            case (state)
                S_IDLE: begin
                    if (add) begin
                        state <= S_SET_MIN;
                    end
                end
                S_SET_MIN: begin
                    if (add) begin
                        state <= S_SET_HR;
                    end
                end
                S_SET_HR: begin
                    if (add) begin
                        state <= S_IDLE;
                    end
                end
            endcase
        end
    end

    reg [15:0] cnt;
    reg [31:0] mask;

    always @(posedge clk_1khz or posedge rst) begin
        if (rst) begin
            cnt <= 0;
        end else if (en) begin
            cnt <= cnt + 1;
            if (cnt >= 300) begin
                cnt <= 0;
                case (state)
                    S_IDLE: begin
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

    always @(posedge add or posedge rst) begin
        if (rst) begin
            rsec <= 0;
            rmin <= 0;
            rhr <= 0;
        end else if (en) begin
            case (state)
                S_SET_MIN: begin
                    rmin <= rmin + 1;
                    if (rmin == 60) begin
                        rmin <= 0;
                    end
                end
                S_SET_HR: begin
                    rhr <= rhr + 1;
                    if (rhr == 24) begin
                        rhr <= 0;
                    end
                end
            endcase
        end
    end

    assign alarm_set_out[3:0] = rsec % 10;
    assign alarm_set_out[7:4] = rsec / 10;
    assign alarm_set_out[11:8] = 4'b1110;
    assign alarm_set_out[15:12] = rmin % 10;
    assign alarm_set_out[19:16] = rmin / 10;
    assign alarm_set_out[23:20] = 4'b1110;
    assign alarm_set_out[27:24] = rhr % 10;
    assign alarm_set_out[31:28] = rhr / 10;

    assign display_out = alarm_set_out | mask;

endmodule


