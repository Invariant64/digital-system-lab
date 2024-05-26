module top (
	input [2:0] in,
	output [7:0] out
);
	wire [7:0] nout;
	assign nout = (in == 3'b000) ? 8'b00000001 :
				 (in == 3'b001) ? 8'b00000010 :
				 (in == 3'b010) ? 8'b00000100 :
				 (in == 3'b011) ? 8'b00001000 :
				 (in == 3'b100) ? 8'b00010000 :
				 (in == 3'b101) ? 8'b00100000 :
				 (in == 3'b110) ? 8'b01000000 :
				 (in == 3'b111) ? 8'b10000000 : 8'b00000000;
	assign out = ~nout;
endmodule