module timer (
    input clk_50mhz,
    input rst,
    input pause,
    output [4*8-1:0] out
);
    reg is_paused;

    reg [31:0] tick;

    reg [6:0] rsec, rmin, rhr;
	 
	always @(posedge pause) begin
	    if (rst) begin
            is_paused <= 0;
        end else begin
            is_paused <= ~is_paused;
        end
	end

    always @(posedge clk_50mhz) begin
        if (rst) begin
            tick <= 0;
            rsec <= 0;
            rmin <= 0;
            rhr <= 15;
        end else if (is_paused) begin
            tick <= tick + 1;
            if (tick >= 50000000) begin
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
        end
    end

    // assign out[0] = rsec % 10;
    // assign out[1] = rsec / 10;
    // assign out[2] = 4'b1110;
    // assign out[3] = rmin % 10;
    // assign out[4] = rmin / 10;
    // assign out[5] = 4'b1110;
    // assign out[6] = rhr % 10;
    // assign out[7] = rhr / 10;

    assign out[3:0] = rsec % 10;
    assign out[7:4] = rsec / 10;
    assign out[11:8] = 4'b1110;
    assign out[15:12] = rmin % 10;
    assign out[19:16] = rmin / 10;
    assign out[23:20] = 4'b1110;
    assign out[27:24] = rhr % 10;
    assign out[31:28] = rhr / 10;
    
endmodule