module bcd_decode(
	input [3:0] indec,
	output reg [6:0] decodeout,	//七段输出
	output dotout
);
	assign dotout = 0;
	
	always @(indec) begin 
		case(indec)
			4'b0000 : decodeout = 7'b0111111;
			4'b0001 : decodeout = 7'b0000110;
			4'b0010 : decodeout = 7'b1011011;
			4'b0011 : decodeout = 7'b1001111;
			4'b0100 : decodeout = 7'b1100110;
			4'b0101 : decodeout = 7'b1101101;
			4'b0110 : decodeout = 7'b1111101;
			4'b0111 : decodeout = 7'b0000111;
			4'b1000 : decodeout = 7'b1111111;
			4'b1001 : decodeout = 7'b1101111;
			4'b1110 : decodeout = 7'b1000000;   // "-"符号
			4'b1111 : decodeout = 7'b0000000;	// 全黑
			default : decodeout = 7'b0000000;
		endcase
	end
endmodule