`timescale 1ns / 1ps
module clk_div(
    input clk_100MHz,
    input reset,
    output clk_25MHz
);
    reg [1:0] count = 0;

    always @(posedge clk_100MHz or posedge reset) begin
        if (reset)
            count <= 0;
        else
            count <= count + 1;
    end

    BUFG bufg_inst (
        .I(count[1]),
        .O(clk_25MHz)
    );
endmodule
