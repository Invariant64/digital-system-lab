module timer (
    input clk_1khz,
    input rst_n,
    input en,
    input pause,
    output [4*8-1:0] out
);
    reg is_paused;

    reg [31:0] tick;

    reg [6:0] rmsec, rsec, rmin;
	 
	always @(posedge pause) begin
	    if (~rst_n) begin
            is_paused <= 1;
        end else begin
            if (en) begin
                is_paused <= ~is_paused;
            end
        end
	end

    always @(posedge clk_1khz) begin
        if (~rst_n) begin
            tick <= 0;
				rmsec <= 0;
            rsec <= 0;
            rmin <= 0;
        end else if (~is_paused) begin
            tick = tick + 1;
            if (tick >= 10) begin
                tick = 0;
                rmsec = rmsec + 1;
                if (rmsec == 100) begin
                    rmsec = 0;
                    rsec = rsec + 1;
                    if (rsec == 60) begin
                        rsec = 0;
                        rmin = rmin + 1;
                        if (rmin == 60) begin
                            rmin = 0;
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

    assign out[3:0] = rmsec % 10;
    assign out[7:4] = rmsec / 10;
    assign out[11:8] = 4'b1110;
    assign out[15:12] = rsec % 10;
    assign out[19:16] = rsec / 10;
    assign out[23:20] = 4'b1110;
    assign out[27:24] = rmin % 10;
    assign out[31:28] = rmin / 10;
    
endmodule