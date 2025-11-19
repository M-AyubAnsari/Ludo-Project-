// DiceDisplay.v
`timescale 1ns / 1ps
module DiceDisplay(
    input  wire       clk,          // 100 MHz
    input  wire       reset,
    input  wire [3:0] dice_value,   // 1 to 6
    input  wire       player_turn,  // 0 = P1 (Red), 1 = P2 (Blue)
    output wire [6:0] seg,          // a,b,c,d,e,f,g
    output reg  [3:0] an            // digit select (active low)
);
 
    // -------------------------------------------------
    // 7-segment patterns (0-6) - common anode
    // -------------------------------------------------
    reg [6:0] seg_pattern;
    always @(*) begin
        case (dice_value)
            4'd1: seg_pattern = 7'b1111001; // 1
            4'd2: seg_pattern = 7'b0100100; // 2
            4'd3: seg_pattern = 7'b0110000; // 3
            4'd4: seg_pattern = 7'b0011001; // 4
            4'd5: seg_pattern = 7'b0010010; // 5
            4'd6: seg_pattern = 7'b0000010; // 6
            default: seg_pattern = 7'b1111111; // OFF
        endcase
    end
 
    // -------------------------------------------------
    // Multiplex 4 digits (only use 1st digit for dice)
    // -------------------------------------------------
    reg [16:0] refresh_cnt;
    always @(posedge clk or posedge reset) begin
        if (reset)
            refresh_cnt <= 0;
        else
            refresh_cnt <= refresh_cnt + 1;
    end
 
    // 100 MHz / 2^17 ? 763 Hz refresh ? smooth
    wire [1:0] digit_sel = refresh_cnt[16:15];
 
    always @(*) begin
        case (digit_sel)
            2'b00: an = 4'b0111; // Digit 0 (rightmost)
            2'b01: an = 4'b1011; // Digit 1
            2'b10: an = 4'b1101; // Digit 2
            2'b11: an = 4'b1110; // Digit 3 (leftmost)
            default: an = 4'b1111;
        endcase
    end
 
    // Show dice only on Digit 0
    assign seg = (digit_sel == 2'b00) ? ~seg_pattern : 7'b1111111;
 
    // Optional: Show player on other digits
    // P1 = "P1", P2 = "P2" (simplified)
    // Or just flash a dot for player
 
endmodule