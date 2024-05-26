module scanner(
    input            clk_1khz,
    input      [3:0] col,
    output reg [3:0] row,
    output reg [3:0] out,
	 output reg       en
);
    reg [1:0] cnt;

    initial begin
        cnt <= 0;
        row <= 4'b1110;
    end

    always @(posedge clk_1khz) begin
		  en <= 1;
        cnt <= cnt + 1;
        case(cnt)
            2'b00: row <= 4'b1110;
            2'b01: row <= 4'b1101;
            2'b10: row <= 4'b1011;
            2'b11: row <= 4'b0111;
        endcase
        case(row)
            4'b1110: begin
                case(col)
                    4'b1110: out <= 0;
                    4'b1101: out <= 1;
                    4'b1011: out <= 2;
                    4'b0111: out <= 3;
						  default: en <= 0;
                endcase
            end
            4'b1101: begin
                case(col)
                    4'b1110: out <= 4;
                    4'b1101: out <= 5;
                    4'b1011: out <= 6;
                    4'b0111: out <= 7;
						  default: en <= 0;
                endcase
            end
            4'b1011: begin
                case(col)
                    4'b1110: out <= 8;
                    4'b1101: out <= 9;
                    4'b1011: out <= 10;
                    4'b0111: out <= 11;
						  default: en <= 0;
                endcase
            end
            4'b0111: begin
                case(col)
                    4'b1110: out <= 12;
                    4'b1101: out <= 13;
                    4'b1011: out <= 14;
                    4'b0111: out <= 15;
						  default: en <= 0;
                endcase
            end
        endcase
    end
endmodule