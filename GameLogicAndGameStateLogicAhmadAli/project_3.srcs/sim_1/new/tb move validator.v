`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 03:42:36 PM
// Design Name: 
// Module Name: tb move validator
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

module tb_move_validator;

    reg clk;                                           // Create the clock signal
    reg reset;                                         // Here we create the reset signal
    reg goti_detected;                                 // Here we indicate if a goti was detected
    reg [1:0] current_player;                          // Then we set which player is currently playing
    reg dice_rolled;                                   // Here we indicate if the dice was rolled
    reg confirm_move;                                  // Here we indicate if the player confirmed their move
    reg [2:0] dice_value;                              // Here we set the dice number (1 to 6)
    wire move_valid;                                   // Output: Indicates if the move is valid
    wire [2:0] fsm_state;                              // Output: Current FSM state

    move_validator dut (                               // Here we instantiate the move_validator module for testing
        .clk(clk),                                     // Connect clock
        .reset(reset),                                 // Connect reset
        .goti_detected(goti_detected),                 // Connect goti detect signal
        .current_player(current_player),               // Connect current player
        .dice_rolled(dice_rolled),                     // Connect dice rolled signal
        .confirm_move(confirm_move),                   // Connect confirm move signal
        .dice_value(dice_value),                       // Connect dice value
        .move_valid(move_valid),                       // Connect move validity signal
        .fsm_state(fsm_state)                          // Connect FSM state
    );

    always #5 clk = ~clk;                              // Toggle the clock every 5ns

    initial begin                                      // Start the test
        $display("\n=== Move Validator Test Start ===\n");  // Display start message

        // Set all inputs to safe values first
        clk = 0;                                       // Start clock low
        reset = 1;                                     // Activate reset
        goti_detected = 0;                             // No goti detected
        current_player = 0;                            // Player 1 (Red) is active
        dice_rolled = 0;                               // No dice rolled
        confirm_move = 0;                              // No move confirmed
        dice_value = 0;                                // Set dice value to 0

        #20;                                           
        reset = 0;                                     // Deactivate reset
        #10;                                          

        // Test 1: Reset state check
        $display("Test 1: After Reset");
        $display("  fsm_state = %d, move_valid = %b", fsm_state, move_valid);
        if (fsm_state == 0 && move_valid == 0)         // Here we check that FSM is in IDLE state and move is invalid
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 2: Dice rolled transitions to WAIT
        dice_rolled = 1;                               // Indicate dice has been rolled
        #10;                                           // Wait for one clock cycle
        dice_rolled = 0;                               // Stop rolling
        #10;
        $display("Test 2: Dice Rolled");
        $display("  fsm_state = %d (should be 1)", fsm_state);
        if (fsm_state == 1)                            // Here we check if FSM moved to WAIT state
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 3: Valid move when goti is detected and dice is valid
        dice_value = 4;                                // Set valid dice value (4)
        goti_detected = 1;                             // Indicate a goti is detected
        confirm_move = 1;                              // Confirm the move
        #10;
        confirm_move = 0;
        #10;
        $display("Test 3: Valid Move (goti + dice 4)");
        $display("  move_valid = %b, fsm_state = %d", move_valid, fsm_state);
        if (move_valid == 1 && fsm_state == 3)         // We check if the move is valid and FSM is in ACCEPT state
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 4: Invalid move when no goti is detected
        #20;                                           // Wait to reset to IDLE
        dice_rolled = 1;                               // Roll the dice again
        #10;
        dice_rolled = 0;
        #10;
        goti_detected = 0;                             // No goti detected
        dice_value = 3;                                // Set dice to an invalid value (no dice 0)
        confirm_move = 1;                              // Confirm the move
        #10;
        confirm_move = 0;
        #10;
        $display("Test 4: Invalid Move (no goti)");
        $display("  move_valid = %b, fsm_state = %d", move_valid, fsm_state);
        if (move_valid == 0 && fsm_state == 4)         // We check that the move is denied and FSM is in DENY state
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        // Test 5: Invalid move with dice value 0
        #20;
        dice_rolled = 1;
        #10;
        dice_rolled = 0;
        #10;
        goti_detected = 1;                             // Goti detected
        dice_value = 0;                                // Invalid dice value (0)
        confirm_move = 1;
        #10;
        confirm_move = 0;
        #10;
        $display("Test 5: Invalid dice (0)");
        $display("  move_valid = %b, fsm_state = %d", move_valid, fsm_state);
        if (move_valid == 0 && fsm_state == 4)         // Here we check if move is rejected due to invalid dice
            $display("  PASS\n");
        else
            $display("  FAIL\n");

        #50;                                           
        $finish;                                  
    end
endmodule


       