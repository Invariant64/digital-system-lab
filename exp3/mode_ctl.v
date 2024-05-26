module mode_ctl (
    input switch,
    input alarm_ringing,
    output reg [1:0] mode
);

    parameter M_DISPLAY   = 2'b00;
    parameter M_SET       = 2'b01;
    parameter M_TIMER     = 2'b10;
    parameter M_ALARM_SET = 2'b11;

    initial begin
        mode <= M_DISPLAY;
    end

    always @(posedge switch) begin
        case (mode)
            M_DISPLAY: begin
                if (!alarm_ringing) begin
                    mode <= M_SET;
                end
            end
            M_SET: begin
                mode <= M_TIMER;
            end
            M_TIMER: begin
                mode <= M_ALARM_SET;
            end
            M_ALARM_SET: begin
                mode <= M_DISPLAY;
            end
        endcase
    end
endmodule