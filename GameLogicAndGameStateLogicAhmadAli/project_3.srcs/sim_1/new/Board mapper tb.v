`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 03:20:17 PM
// Design Name: 
// Module Name: Board mapper tb
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

module tb_board_mapper;

    reg  [26:0] sensor_inputs;     // Control all 27 sensor inputs
    wire goti_detected;            // Output: Indicates if a goti is detected
    wire [4:0] pos_index;          // Output: The index of the detected goti
    wire [1:0] x_coord;            // Output: X coordinate of the goti in the 4x4 grid
    wire [1:0] y_coord;            // Output: Y coordinate of the goti in the 4x4 grid

    board_mapper dut (             // Instantiating the board_mapper
        .sensor_inputs(sensor_inputs),
        .goti_detected(goti_detected),
        .pos_index(pos_index),
        .x_coord(x_coord),
        .y_coord(y_coord)
    );

    initial begin
        $display("\n Ludo Board\n");

        // Test 1: No goti present (all sensor inputs are 0)
        sensor_inputs = 27'd0;     // Here we set all sensors to 0 (no goti detected)
        #10;                       // Wait for output to update
        $display("Test 1: No goti detected");
        $display("  goti_detected = %b, pos_index = %d", goti_detected, pos_index);
        if (goti_detected == 0 && pos_index == 0)  // Here we check that no goti is detected
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 2: Goti at index 0
        sensor_inputs = 27'b1;     // Here we place goti only at index 0
        #10;
        $display("Test 2: Goti at index 0");
        $display("  pos_index = %d, x_coord = %d, y_coord = %d", pos_index, x_coord, y_coord);
        if (pos_index == 0 && x_coord == 0 && y_coord == 0)  // We check the position and coordinates are correct for index 0
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 3: Goti at index 15
        sensor_inputs = 27'd0;     // Here we clear all bits
        sensor_inputs[15] = 1;     // Place goti at index 15
        #10;
        $display("Test 3: Goti at index 15");
        $display("  pos_index = %d, x_coord = %d, y_coord = %d", pos_index, x_coord, y_coord);
        if (pos_index == 15 && x_coord == 3 && y_coord == 3)  // Here we check the coordinates for index 15 (3, 3)
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 4: Goti at home (index 18)
        sensor_inputs = 27'd0;     // Clear all bits
        sensor_inputs[18] = 1;     // Place goti at home safe (index 18)
        #10;
        $display("Test 4: Goti at index 18 (Home Safe)");
        $display("  pos_index = %d (x,y not used)", pos_index);  // No need to check x,y for home position
        if (pos_index == 18)  // We expect pos_index to be 18
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 5: Multiple gotis (Red at 5, Green at 20)
        sensor_inputs = 27'd0;     // Then we clear all bits
        sensor_inputs[5] = 1;      // Place Red goti at index 5
        sensor_inputs[20] = 1;     // then Place Green goti at index 20
        #10;
        $display("Test 5: Multiple gotis (5 and 20)");
        $display("  First detected index = %d", pos_index);
        if (pos_index == 5)  // Here we check that the first goti detected is at index 5
            $display("  PASS (correctly picked lowest index)\n");
        else
            $display("  FAIL (expected 5)\n");

        $finish;
    end
endmodule
