module frequency (
    input      [3:0]  data,
    output reg [16:0] N
);

    always @ (*) begin
		 case (data)
			  0: N <= 56818;
			  1: N <= 50618;
			  2: N <= 47774;
			  3: N <= 42568;
			  4: N <= 37919;
			  5: N <= 35791;
			  6: N <= 31888;
			  7: N <= 28409;
			  8: N <= 25309;
			  9: N <= 23912;
			  10: N <= 21282;
			  11: N <= 18961;
			  12: N <= 17897;
			  13: N <= 15944;
			  14: N <= 14205;
			  15: N <= 12655;
		 endcase
	 end

endmodule