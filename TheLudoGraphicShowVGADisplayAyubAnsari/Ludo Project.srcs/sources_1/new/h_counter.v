`timescale 1ns / 1ps
module h_counter (
    input clk_25MHz,
    input reset,
    output reg [9:0] h_count = 0
);
    always @(posedge clk_25MHz or posedge reset) begin
        if (reset)
            h_count <= 0;
        else if (h_count == 799)
            h_count <= 0;
        else
            h_count <= h_count + 1;
    end
endmodule
