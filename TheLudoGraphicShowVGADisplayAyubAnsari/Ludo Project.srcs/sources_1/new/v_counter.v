`timescale 1ns / 1ps
module v_counter (
    input clk_25MHz,
    input reset,
    input h_sync_end,
    output reg [9:0] v_count = 0
);
    always @(posedge clk_25MHz or posedge reset) begin
        if (reset)
            v_count <= 0;
        else if (h_sync_end) begin
            if (v_count == 524)
                v_count <= 0;
            else
                v_count <= v_count + 1;
        end
    end
endmodule