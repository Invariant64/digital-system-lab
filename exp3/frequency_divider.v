module frequency_divider (
	input clk_50mhz, 
	input rst,
	output reg clk
);

    parameter N = 50000;
	
	reg[31:0] cnt1;
	
	always @ (posedge clk_50mhz)
		if (rst) begin
			cnt1 <= 1'b0;
			clk <= 1'b0;
		end else begin
			if (cnt1 < N/2-1)
				cnt1 <= cnt1 + 1'b1;
			else begin
				cnt1 <= 1'b0;
			    clk <= ~clk;
			end
	    end
endmodule 