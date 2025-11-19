`timescale 1ns / 1ps
module top_vga (
    input clk_100MHz,
    input reset,
    output h_sync,
    output v_sync,
    output [3:0] red,
    output [3:0] green,
    output [3:0] blue
);

    // 25 MHz clock generation
    wire clk_25MHz;
    clk_div u_clk_div (
        .clk_100MHz(clk_100MHz),
        .reset(reset),
        .clk_25MHz(clk_25MHz)
    );

    // Horizontal and Vertical counters
    wire [9:0] h_count, v_count;
    wire h_sync_end = (h_count == 799);

    h_counter u_h_counter (
        .clk_25MHz(clk_25MHz),
        .reset(reset),
        .h_count(h_count)
    );

    v_counter u_v_counter (
        .clk_25MHz(clk_25MHz),
        .reset(reset),
        .h_sync_end(h_sync_end),
        .v_count(v_count)
    );

    // VGA Sync + Pixel coordinates
    wire video_on;
    wire [9:0] pixel_x, pixel_y;

    vga_sync u_vga_sync (
        .h_count(h_count),
        .v_count(v_count),
        .h_sync(h_sync),
        .v_sync(v_sync),
        .video_on(video_on),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y)
    );

    // Ludo Board Pixel Generator
    pixel_gen_ludo u_pixel_gen (
        .clk_d(clk_25MHz),
        .pixel_x(pixel_x),
        .pixel_y(pixel_y),
        .video_on(video_on),
        .red(red),
        .green(green),
        .blue(blue)
    );

endmodule
