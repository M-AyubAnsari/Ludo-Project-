`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/11/2025 12:12:32 PM
// Design Name: 
// Module Name: ref code
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
module board_mapper(
    input wire [26:0] sensor_inputs,   // here we get 27 bits from the sensors (1 = goti present)
    output reg goti_detected,          // here we say 1 if any goti is found
    output reg [4:0] pos_index,        // here we store the index (0 to 26) of the first goti
    output reg [1:0] x_coord,          // here we give x position (0-3) only for 4x4 grid
    output reg [1:0] y_coord           // here we give y position (0-3) only for 4x4 grid
);

    integer i;                         // here we use i for looping through 27 bits
    reg found;                         // here we use found to stop after first goti

    always @(*) begin                  // here we trigger when any sensor input changes
        goti_detected = 0;             // here we reset detection flag
        pos_index = 0;                 // here we reset position index
        x_coord = 0;                   // here we reset x coordinate
        y_coord = 0;                   // here we reset y coordinate
        found = 0;                     // here we reset found flag

        for (i = 0; i < 27 && !found; i = i + 1) begin  // here we loop from 0 to 26
            if (sensor_inputs[i]) begin                 // here we check if goti is on this square
                goti_detected = 1;                      // here we set flag: goti found
                pos_index = i[4:0];                     // here we save the index of this goti
                if (i < 16) begin                       // here we check if index is in 4x4 grid
                    x_coord = i % 4;                    // here we calculate column using modulo
                    y_coord = i / 4;                    // here we calculate row using division
                end
                found = 1;                              // here we stop loop after first goti
            end
        end
    end

endmodule