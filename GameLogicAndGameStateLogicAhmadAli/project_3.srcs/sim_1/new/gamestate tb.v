`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 03:33:44 PM
// Design Name: 
// Module Name: gamestate tb
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

//`timescale 1ns / 1ps

//module tb_game_state;

//    // Testbench signals
//    reg clk, reset;
//    reg [1:0] current_player_in;
//    reg [4:0] new_pos;
//    reg move_valid;
//    reg [2:0] dice_value;
//    wire goti_beaten, goti_home;
//    wire [1:0] current_player_out;
//    wire game_won;

//    // Instantiate the DUT (Device Under Test)
//    game_state dut (
//        .clk(clk), .reset(reset), .current_player_in(current_player_in),
//        .new_pos(new_pos), .move_valid(move_valid), .dice_value(dice_value),
//        .goti_beaten(goti_beaten), .goti_home(goti_home),
//        .current_player_out(current_player_out), .game_won(game_won)
//    );

//    // Clock generation
//    initial clk = 0;
//    always #5 clk = ~clk;  // Clock toggles every 5 ns

//    // Helper task for a synchronous move
//    task sync_move;
//        input [1:0] player;
//        input [4:0] pos;
//        input [2:0] dice;
//        begin
//            current_player_in = player;
//            new_pos = pos;
//            dice_value = dice;
//            move_valid = 1;
//            @(posedge clk); // Wait for the next clock cycle
//            move_valid = 0;
//            @(posedge clk); // Wait for the next clock cycle
//        end
//    endtask

//    // Initial block
//    initial begin
//        // Reset initialization
//        reset = 1;
//        current_player_in = 0;  // Red starts the game
//        new_pos = 0;
//        move_valid = 0;
//        dice_value = 0;
//        #10;  // Wait for reset to propagate
//        reset = 0;
//        #10;  // Allow some time for reset to take effect

//        // ---- Test 1: Red Player Moves to Position 1 (First Goti) ----
//        $display("Test 1: Red Player moves to position 1");
//        sync_move(0, 1, 6); // Red rolls a 6, exits home to pos 1

//        // ---- Test 2: Green Player Moves to Position 10 ----
//        $display("Test 2: Green Player moves to position 12");
//        sync_move(1, 12, 6); // Green rolls a 6, exits home to pos 12

//        // ---- Test 3: Red Moves Goti from 1 to 2 (Normal Move) ----
//        $display("Test 3: Red Player moves Goti from 1 to 2");
//        sync_move(0, 2, 1); 

//        // ---- Test 4: Green Moves Goti from 12 to 14 (Normal Move) ----
//        $display("Test 4: Green Player moves Goti from 12 to 14");
//        sync_move(1, 14, 2);

//        // ---- Test 5: Red Moves Goti from 2 to 4 (Normal Move) ----
//        $display("Test 5: Red Player moves Goti from 2 to 4");
//        sync_move(0, 4, 2);
        
//        // ---- Test 6: Red Moves to Position 14 (Kicks Green's Goti) ----
//        $display("Test 6: Red Player moves to position 14 (kicking Green's goti back home)");
//        sync_move(1, 15, 1); // Green's turn, skip
//        sync_move(0, 14, 10); // Red moves Goti from 4 (4+10=14)
        
//        // Check if Green's goti is sent back to home
//        if (goti_beaten == 1)
//            $display("  PASS: Green's goti has been beaten and sent home.\n");
//        else
//            $display("  FAIL: Goti beaten condition not triggered.\n");

//        // ---- Test 7: Red Reaches Home (Position 23) ----
//        $display("Test 7: Red Player moves to position 23 (goti home)");
//        // Need to move Red goti 14 to 23 (14 + 9 = 23)
//        sync_move(1, 15, 1); // Green's turn, skip
//        sync_move(0, 23, 9);
//        // Check if Red's goti has reached home
//        if (goti_home == 1)
//            $display("  PASS: Red's goti has reached home.\n");
//        else
//            $display("  FAIL: Goti home condition not triggered.\n");

//        // ---- Test 8: Red Wins (Both Gotis Reach Position 23) ----
//        $display("Test 8: Red Player wins by moving both gotis to position 23");
//        // Move Red goti 1 (currently home at 15) to 23. Must exit first.
        
//        // Move Goti 1 out (15->1)
//        sync_move(1, 15, 1); // Green's turn, skip
//        sync_move(0, 1, 6);
        
//        // Move Goti 1 from 1 to 23 (1+22=23 - need a big roll)
//        sync_move(1, 15, 1); // Green's turn, skip
//        sync_move(0, 23, 22);

//        // Check if Red wins
//        if (game_won == 1)
//            $display("  PASS: Red wins the game by reaching position 23 with both gotis.\n");
//        else
//            $display("  FAIL: Game won condition not triggered.\n");

//        $finish; // End the simulation
//    end
//endmodule















//`timescale 1ns / 1ps

//module tb_game_state;

//    reg clk, reset;
//    reg [1:0] current_player_in;
//    reg [4:0] new_pos;
//    reg move_valid;
//    reg [2:0] dice_value;
//    wire goti_beaten, goti_home;
//    wire [1:0] current_player_out;
//    wire game_won;

//    // Instantiate the DUT (Device Under Test)
//    game_state dut (
//        .clk(clk), .reset(reset), .current_player_in(current_player_in),
//        .new_pos(new_pos), .move_valid(move_valid), .dice_value(dice_value),
//        .goti_beaten(goti_beaten), .goti_home(goti_home),
//        .current_player_out(current_player_out), .game_won(game_won)
//    );

//    // Clock generation
//    initial clk = 0;
//    always #5 clk = ~clk;  // Clock toggles every 5 ns

//    initial begin
//        reset = 1;
//        current_player_in = 0;  // Red starts the game
//        new_pos = 0;
//        move_valid = 0;
//        dice_value = 0;
//        #10;  // Wait for reset to propagate
//        reset = 0;
//        #10;  // Allow some time for reset to take effect

//        // Test 1: Red Player Moves to Position 1 (First Goti)
//        $display("Test 1: Red Player moves to position 1");
//        dice_value = 6;
//        new_pos = 1;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);  // Wait for the next clock cycle

//        // Test 2: Green Player Moves to Position 10
//        $display("Test 2: Green Player moves to position 10");
//        current_player_in = 1;  // Now it's Green's turn
//        dice_value = 6;
//        new_pos = 10;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Test 3: Red Moves to Position 10 (Kicks Green's Goti)
//        $display("Test 3: Red Player moves to position 10 (kicking Green's goti back home)");
//        current_player_in = 0;
//        dice_value = 1;
//        new_pos = 10;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Check if Green's goti is sent back to home
//        if (goti_beaten == 1) 
//            $display("  PASS: Green's goti has been beaten and sent home.\n");
//        else 
//            $display("  FAIL: Goti beaten condition not triggered.\n");

//        // Test 4: Red Reaches Home (Position 23)
//        $display("Test 4: Red Player moves to position 23 (goti home)");
//        current_player_in = 0;  // Red's turn
//        dice_value = 6;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Check if Red's goti has reached home
//        if (goti_home == 1) 
//            $display("  PASS: Red's goti has reached home.\n");
//        else 
//            $display("  FAIL: Goti home condition not triggered.\n");

//        // Test 5: Red Wins (Both Gotis Reach Position 23)
//        $display("Test 5: Red Player wins by moving both gotis to position 23");
        
//        // Move first Red goti to 23
//        current_player_in = 0;
//        dice_value = 1;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Move second Red goti to 23
//        dice_value = 1;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Check if Red wins
//        if (game_won == 1) 
//            $display("  PASS: Red wins the game by reaching position 23 with both gotis.\n");
//        else 
//            $display("  FAIL: Game won condition not triggered.\n");

//        // Test 6: Green Reaches Position 23
//        $display("Test 6: Green Player reaches position 23 (goti home)");
//        current_player_in = 1;  // Green's turn
//        dice_value = 6;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Check if Green's goti has reached home
//        if (goti_home == 1) 
//            $display("  PASS: Green's goti has reached home.\n");
//        else 
//            $display("  FAIL: Goti home condition not triggered.\n");

//        // Test 7: Green Wins by Moving Both Gotis to Position 23
//        $display("Test 7: Green wins by moving both gotis to position 23");
//        current_player_in = 1;
        
//        // Move first Green goti to 23
//        dice_value = 1;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Move second Green goti to 23
//        dice_value = 1;
//        new_pos = 23;
//        move_valid = 1;
//        #10;
//        move_valid = 0;
//        @(posedge clk);

//        // Check if Green wins
//        if (game_won == 1) 
//            $display("  PASS: Green wins the game.\n");
//        else 
//            $display("  FAIL: Game won condition not triggered.\n");

//        $finish;  // End the simulation
//    end
//endmodule



`timescale 1ns / 1ps

module tb_game_state;

    // Testbench signals
    reg clk;                          // Clock signal for simulation
    reg reset;                        // Reset signal to initialize the game
    reg [1:0] current_player_in;      // Current player's turn: 0 = Red, 1 = Green
    reg [4:0] new_pos;                // Position where the current player moves
    reg move_valid;                   // Move validity flag (set by dice roll)
    reg [2:0] dice_value;             // Dice value (1 to 6)
    wire goti_beaten;                 // Goti sent back to home signal
    wire goti_home;                   // Goti reaches home signal (position 23)
    wire [1:0] current_player_out;    // Output for the next player's turn
    wire game_won;                    // Game won signal

    // Instantiate the DUT (Device Under Test)
    game_state dut (
        .clk(clk), 
        .reset(reset), 
        .current_player_in(current_player_in),
        .new_pos(new_pos), 
        .move_valid(move_valid), 
        .dice_value(dice_value),
        .goti_beaten(goti_beaten), 
        .goti_home(goti_home),
        .current_player_out(current_player_out), 
        .game_won(game_won)
    );

    // Clock generation: 100 MHz clock (10 ns period)
    initial clk = 0;
    always #5 clk = ~clk;  // Toggle clock every 5ns for 100MHz clock

    // Test sequence
    initial begin
        // Initialize signals
        reset = 1;
        current_player_in = 0;  // Red starts the game
        new_pos = 0;
        move_valid = 0;
        dice_value = 0;

        #10;  // Wait for reset to propagate
        reset = 0;
        #10;  // Allow some time for reset to take effect

        // Test 1: Red Player Moves to Position 1 (First Goti)
        $display("Test 1: Red Player moves to position 1");
        dice_value = 6;
        new_pos = 1;
        move_valid = 1;
        #10;  // Apply move
        move_valid = 0;
        @(posedge clk);  // Wait for the next clock cycle

        // Test 2: Green Player Moves to Position 10
        $display("Test 2: Green Player moves to position 10");
        current_player_in = 1;  // Now it's Green's turn
        dice_value = 6;
        new_pos = 10;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Test 3: Red Moves to Position 10 (Kicks Green's Goti)
        $display("Test 3: Red Player moves to position 10 (kicking Green's goti back home)");
        current_player_in = 0;
        dice_value = 1;
        new_pos = 10;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Check if Green's goti is sent back to home
        if (goti_beaten == 1) 
            $display("  PASS: Green's goti has been beaten and sent home.\n");
        else 
            $display("  FAIL: Goti beaten condition not triggered.\n");

        // Test 4: Red Reaches Home (Position 23)
        $display("Test 4: Red Player moves to position 23 (goti home)");
        current_player_in = 0;  // Red's turn
        dice_value = 6;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Check if Red's goti has reached home
        if (goti_home == 1) 
            $display("  PASS: Red's goti has reached home.\n");
        else 
            $display("  FAIL: Goti home condition not triggered.\n");

        // Test 5: Red Wins (Both Gotis Reach Position 23)
        $display("Test 5: Red Player wins by moving both gotis to position 23");
        
        // Move first Red goti to 23
        current_player_in = 0;
        dice_value = 1;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Move second Red goti to 23
        dice_value = 1;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Check if Red wins
        if (game_won == 1) 
            $display("  PASS: Red wins the game by reaching position 23 with both gotis.\n");
        else 
            $display("  FAIL: Game won condition not triggered.\n");

        // Test 6: Green Reaches Position 23
        $display("Test 6: Green Player reaches position 23 (goti home)");
        current_player_in = 1;  // Green's turn
        dice_value = 6;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Check if Green's goti has reached home
        if (goti_home == 1) 
            $display("  PASS: Green's goti has reached home.\n");
        else 
            $display("  FAIL: Goti home condition not triggered.\n");

        // Test 7: Green Wins by Moving Both Gotis to Position 23
        $display("Test 7: Green wins by moving both gotis to position 23");
        current_player_in = 1;
        
        // Move first Green goti to 23
        dice_value = 1;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Move second Green goti to 23
        dice_value = 1;
        new_pos = 23;
        move_valid = 1;
        #10;
        move_valid = 0;
        @(posedge clk);

        // Check if Green wins
        if (game_won == 1) 
            $display("  PASS: Green wins the game.\n");
        else 
            $display("  FAIL: Game won condition not triggered.\n");

        $finish;  // End the simulation
    end
endmodule


