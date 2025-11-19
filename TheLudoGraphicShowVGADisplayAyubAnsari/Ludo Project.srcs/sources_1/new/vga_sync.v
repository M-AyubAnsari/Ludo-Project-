`timescale 1ns / 1ps
module vga_sync (
    input [9:0] h_count,
    input [9:0] v_count,
    output h_sync,
    output v_sync,
    output video_on,
    output [9:0] pixel_x,
    output [9:0] pixel_y
);
    localparam HD = 640;  // Display area
    localparam HF = 16;   // Front porch
    localparam HB = 48;   // Back porch
    localparam HR = 96;   // Retrace

    localparam VD = 480;
    localparam VF = 10;
    localparam VB = 33;
    localparam VR = 2;

    assign pixel_x = h_count;
    assign pixel_y = v_count;
    assign video_on = (h_count < HD) && (v_count < VD);

    // Active-low sync pulses
    assign h_sync = ~((h_count >= (HD + HF)) && (h_count < (HD + HF + HR)));
    assign v_sync = ~((v_count >= (VD + VF)) && (v_count < (VD + VF + VR)));
endmodule
