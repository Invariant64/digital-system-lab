module clock (
    input clk_1khz,
    input rst,
    input set_en,
    input switch,
    input add,
    output [4*8-1:0] out
);

    reg [15:0] tick;

    reg [6:0] rsec, rmin, rhr;
    reg [6:0] rsec_set, rmin_set, rhr_set;

    parameter S_CLOCK = 2'b00;
    parameter S_SET_MIN = 2'b01;
    parameter S_SET_HR = 2'b10;

    reg [1:0] state;

    always @(posedge switch or posedge rst) begin
        if (rst) begin
            state <= S_CLOCK;
        end else if (~set_en) begin
            state <= S_CLOCK;
        end else if (set_en) begin
            case (state)
                S_CLOCK: begin
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
                        state <= S_CLOCK;
                    end
                end
            endcase
        end
    end

    wire add_n;

    always @(posedge clk_1khz) begin
        if (rst) begin
            tick <= 0;
            rsec <= 0;
            rmin <= 0;
            rhr <= 0;
        end else if (~set_en) begin
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
        end else if (set_en) begin
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

    assign out[3:0] = rsec % 10;
    assign out[7:4] = rsec / 10;
    assign out[11:8] = 4'b1110;
    assign out[15:12] = rmin % 10;
    assign out[19:16] = rmin / 10;
    assign out[23:20] = 4'b1110;
    assign out[27:24] = rhr % 10;
    assign out[31:28] = rhr / 10;
    
endmodule