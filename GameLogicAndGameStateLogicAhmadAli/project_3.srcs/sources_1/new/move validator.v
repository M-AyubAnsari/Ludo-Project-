`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/14/2025 03:41:19 PM
// Design Name: 
// Module Name: move validator
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

module move_validator(
    input clk,                             
    input reset,                           //reset signal
    input goti_detected,                   // To know if a goti was placed on board
    input [1:0] current_player,            // Current player (0 = Red, 1 = Green)
    input dice_rolled,                     // Here we know if player rolled the dice
    input confirm_move,                    //  if player confirmed their move
    input [2:0] dice_value,                // dice number (1 to 6)
    output reg move_valid,                 //  move is allowed
    output reg [2:0] fsm_state             // current state of FSM
);

    // FSM states
    localparam IDLE = 3'd0;            // Wait for dice roll
    localparam WAIT = 3'd1;            // Wait for player to confirm move
    localparam VALIDATE = 3'd2;         // Validate the move
    localparam ACCEPT = 3'd3;           // Accept the move
    localparam DENY = 3'd4;             // Deny the move

    always @(posedge clk or posedge reset) begin  // Here we run on clock edge or reset
        if (reset) begin                   // Here we check if reset is on
            fsm_state <= IDLE;             // then  go to IDLE state
            move_valid <= 0;               // no move is valid
        end
        else begin                         // run normal FSM
            case (fsm_state)
                IDLE: begin
                    if (dice_rolled) begin // Here we check if dice was rolled
                        fsm_state <= WAIT; //go to WAIT state
                    end
                end

                WAIT: begin
                    if (confirm_move) begin // Here we check if player confirmed
                        fsm_state <= VALIDATE; // validate move
                    end
                end

                VALIDATE: begin
                    if (goti_detected && dice_value >= 1 && dice_value <= 6) begin
                        // Here we check: goti detected AND dice is valid (1-6)
                        move_valid <= 1;   // move valid 
                        fsm_state <= ACCEPT; // accept move
                    end
                    else begin
                        // Here we reject if no goti or bad dice
                        move_valid <= 0;   // say move is invalid
                        fsm_state <= DENY; //reject move
                    end
                end

                ACCEPT: begin
                    fsm_state <= IDLE;         // back to IDLEstate
                end

                DENY: begin
                    fsm_state <= IDLE;         // Back to IDLE
                end

                default: begin
                    fsm_state <= IDLE;         // deafult state idle
                end
            endcase
        end
    end

endmodule
