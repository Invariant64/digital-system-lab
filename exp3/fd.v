module fd(
    input clk,
    input in,
    output out
);

    parameter S_IDLE = 0, S_VALID = 1, S_OUT = 2;

    reg [1:0] state;

    reg [31:0] cnt;

    initial begin
        state <= S_IDLE;
        cnt <= 0;
    end

    always @(posedge clk) begin
        case(state)
            S_IDLE: begin
                if(in) begin
                    state <= S_VALID;
                end
            end
            S_VALID: begin
                if (!in) begin
                    state <= S_OUT;
                end
            end
            S_OUT: begin
                if (in) begin
                    state <= S_VALID;
						  cnt <= 0;
                end else begin
                    cnt <= cnt + 1;
                    if (cnt >= 1000000) begin
                        state <= S_IDLE;
                        cnt <= 0;
                    end
                end
            end
        endcase
    end

    assign out = (state == S_VALID || state == S_OUT) ? 1 : 0;
	 
endmodule