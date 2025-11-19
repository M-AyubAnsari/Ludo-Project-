`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 03:29:51 PM
// Design Name: 
// Module Name: gamestate
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

module game_state(
    input  wire clk,                     // Main clock signal - logic updates on clock edges
    input  wire reset,                   // Reset signal which returns the game to initial state
    input  wire [1:0] current_player_in, // 2-bit value: selects which player's turn it currently is
                                          //  0 = Red player, 1 = Green player
    input  wire [4:0] new_pos,           // Calculated destination for the current goti after move
                                          // Position range fits within 5 bits (0-31)
    input  wire move_valid,              // Indicates whether the move is allowed (based on dice + rules)
    
    input  wire goti_select,             // Selects which goti is being moved  0 for first, 1 for second
    input  wire [2:0] dice_value,        // Dice output value (1 to 6), fits within 3 bits
    output reg goti_beaten,              // Output high for one cycle when a goti is beaten (sent back to start)
    output reg goti_home,                // Output high for one cycle when a goti reaches the home cell
    output reg [1:0] current_player_out, // Player ID that should play the NEXT turn
                                          // This may switch or stay (based on dice roll)
    output reg [1:0] winner_player,      // Indicates who wins once game_won is set
                                          // 0 = Red wins, 1 = Green wins
    output reg game_won                  // Becomes 1 when either player completes all gotis
);

    // The final target position where a goti is considered "home"
    localparam HOME_POS = 23;            // 23 is used here as example final board slot

    // Arrays hold current positions of each player's 2 gotis
    // Each goti stores its position on the board or 0 if at base
    reg [4:0] red_pos[1:0];              // red_pos[0] and red_pos[1] track two red gotis
    reg [4:0] green_pos[1:0];            // green_pos[0] and green_pos[1] track two green gotis

    // Counters to track how many gotis have reached final home for each player
    reg [1:0] red_home_count;            // Each time a red goti reaches HOME_POS, this increments
    reg [1:0] green_home_count;          // Same for green gotis

    integer i;                           // Generic loop variable used in beating checks

    always @(posedge clk or posedge reset) begin
        
        if (reset) begin
            // Reset is asserted - initialize everything to start conditions
            // No beating or home events during reset
            goti_beaten <= 0;
            goti_home <= 0;
            
            // No winner at start
            game_won <= 0;
            winner_player <= 0;
            
            // Game always starts with Red player's turn
            current_player_out <= 0;
            
            // Neither player has scored homes yet
            red_home_count <= 0;
            green_home_count <= 0;

            // All gotis start at base (position 0)
            red_pos[0] <= 0;
            red_pos[1] <= 0;
            green_pos[0] <= 0;
            green_pos[1] <= 0;

        end else begin
            // Normal operation: update logic on each positive clock edge

            // By default, assume nothing was beaten or reached home in THIS clock
            goti_beaten <= 0;
            goti_home <= 0;

            // Keep same player by default - may change later if dice != 6
            current_player_out <= current_player_in;

            // Only update game state if a valid move is requested AND game isn't already over
            if (move_valid && !game_won) begin

                // Check which player's turn it is
                if (current_player_in == 0) begin
                    // Red player's move
                    
                    // Update position of the selected red goti
                    red_pos[goti_select] <= new_pos;

                    // Check if the new red position lands on that of either green goti
                    for (i = 0; i < 2; i = i + 1) begin
                        if (green_pos[i] == new_pos) begin
                            // A green goti is beaten - send to base
                            green_pos[i] <= 0;
                            goti_beaten <= 1; // Signal that beating happened this turn
                        end
                    end

                    // Check if the moved red goti reached the final home position
                    if (new_pos == HOME_POS) begin
                        red_home_count <= red_home_count + 1; // Increment red's score
                        goti_home <= 1; // Signal successful home arrival
                    end

                end else begin
                    // Green player's move
                    
                    // Update position of selected green goti
                    green_pos[goti_select] <= new_pos;

                    // Checking if this move beats any red goti
                    for (i = 0; i < 2; i = i + 1) begin
                        if (red_pos[i] == new_pos) begin
                            // A red goti is beaten - send to base
                            red_pos[i] <= 0;
                            goti_beaten <= 1; // got is beaten
                        end
                    end

                    // Then we check for home completion by green goti
                    if (new_pos == HOME_POS) begin
                        green_home_count <= green_home_count + 1;
                        goti_home <= 1; // goti is home
                    end
                end

                // After updating positions, wecheck win conditions:
                // A player wins when BOTH of their gotis reached home (count = 2)
                if (red_home_count >= 2) begin
                    game_won <= 1;        // Game ends
                    winner_player <= 0;   // Declare Red as the winner
                end else if (green_home_count >= 2) begin
                    game_won <= 1;        // Game ends
                    winner_player <= 1;   // Declare Green as the winner
                end

                // Turn switching logic:
                // In Ludo, a 6 allows the player to roll again
                // So only switch turn if dice is NOT 6
                if (dice_value != 6)
                    current_player_out <= ~current_player_in; //It  Toggles between 0 and 1

            end
        end
    end
endmodule

