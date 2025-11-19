`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/16/2025 06:51:00 PM
// Design Name: 
// Module Name: vga_controller_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`timescale 1ns / 1ps
module vga_controller_tb;
    reg clk_100MHz = 0;
    reg reset = 1;
    wire h_sync, v_sync;
    wire [3:0] red, green, blue;

    top_vga dut (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .red(red),
        .green(green),
        .blue(blue)
    );

    always #5 clk_100MHz = ~clk_100MHz; // 100 MHz

    initial begin
        #100 reset = 0;
        #10000000 $finish; // Run for ~10ms
    end

    initial begin
        $dumpfile("vga_ludo.vcd");
        $dumpvars(0, vga_controller_tb);
    end
endmodule
