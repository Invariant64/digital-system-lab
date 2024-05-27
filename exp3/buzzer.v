module buzzer (
	input en,
	input clk_50mhz,
	input [16:0] N,
	output reg out_buzzer
);
	 reg[31:0] cnt;

    initial begin
        cnt <= 0;
        out_buzzer <= 0;
    end
	
	always @ (posedge clk_50mhz) begin
		if (en) begin
			if (cnt < N)
				cnt <= cnt + 1'b1;
			else begin
				cnt <= 1'b0;
				out_buzzer <= ~out_buzzer;
			end
		end
	end
endmodule