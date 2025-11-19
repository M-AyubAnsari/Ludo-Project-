`timescale 1ns / 1ps

module LudoFull(
    input  wire       clk,
    input  wire       reset,
    input  wire       roll_btn,
    input  wire       confirm_btn,
    output reg [3:0]  dice_value,
    output reg        player_turn,
    output reg        game_over,
    output reg [1:0]  status_led,
    output [26:0]     board_next,
    // Exposed for testbench
    output reg [4:0]  p1_pos_0,
    output reg [4:0]  p1_pos_1,
    output reg [4:0]  p2_pos_0,
    output reg [4:0]  p2_pos_1
);

// =====================================================
// FSM States
// =====================================================
localparam S_IDLE=0, S_WAIT=1, S_SELECT=2, S_MOVE=3, S_CAPTURE=4, S_NEXT=5, S_OVER=6;
reg [2:0] state, next_state;

// =====================================================
// LFSR for dice
// =====================================================
//reg [5:0] lfsr;
reg [7:0] lfsr;
// =====================================================
// Steps left & selected piece
// =====================================================
reg [3:0] steps_left;
reg selected_piece;

// =====================================================
// Button edge detect
// =====================================================
reg roll_prev, confirm_prev;
wire roll_rising    = roll_btn & ~roll_prev;
wire confirm_rising = confirm_btn & ~confirm_prev;


// on every pos edge, read roll_btn and confirm_btn
always @(posedge clk) begin
    roll_prev    <= roll_btn;
    confirm_prev <= confirm_btn;
end

// =====================================================
// Reset
// =====================================================
always @(posedge clk) begin
    if(reset) begin
        p1_pos_0 <= 23; p1_pos_1 <= 24;
        p2_pos_0 <= 25; p2_pos_1 <= 26;
        player_turn <= 0;
        dice_value <= 0;
        steps_left <= 0;
        selected_piece <= 0;
        game_over <= 0;
        status_led <= 0;
        state <= S_IDLE;
        lfsr <= 6'b000001;
    end else begin
        state <= next_state;
    end
end

// =====================================================
// LFSR Dice (only rolls when roll_btn pressed in S_WAIT)
// =====================================================
//always @(posedge clk) begin
//    if(roll_rising && state==S_WAIT && !game_over) begin
//        lfsr <= {lfsr[4:0], lfsr[5]^lfsr[0]};
//        dice_value <= (lfsr % 6) + 1;
//    end
//end

// =====================================================
// LFSR Dice (only rolls when roll_btn pressed in S_WAIT)
// =====================================================
always @(posedge clk) begin
    if (reset) begin
        lfsr <= 8'hA5;     // any non-zero seed
    end else if (state==S_WAIT && roll_rising) begin
        lfsr <= {lfsr[6:0], lfsr[7] ^ lfsr[5] ^ lfsr[4] ^ lfsr[3]};
    end
end

reg [2:0] dice_raw;
always @(posedge clk) begin
    if (reset) begin
        dice_value <= 1;
    end else if (state==S_WAIT && roll_rising) begin
        dice_raw = lfsr[2:0];   // take 3 random bits (0..7)
        case (dice_raw)
            3'b000: dice_value <= 1;
            3'b001: dice_value <= 2;
            3'b010: dice_value <= 3;
            3'b011: dice_value <= 4;
            3'b100: dice_value <= 5;
            3'b101: dice_value <= 6;
            3'b110: dice_value <= 6; // mapping
            3'b111: dice_value <= 5; // mapping
            default: dice_value <= 1;
        endcase
    end
end
// =====================================================
// FSM Next State
// =====================================================
always @(*) begin
    next_state = state;
    case(state)
        S_IDLE:    next_state = S_WAIT;
        S_WAIT:    if(roll_rising) next_state = S_SELECT;
        S_SELECT:  if(confirm_rising) next_state = S_MOVE;
        S_MOVE:    if(steps_left==0) next_state = S_CAPTURE;
        S_CAPTURE: next_state = S_NEXT;
        S_NEXT:    next_state = game_over ? S_OVER : S_WAIT;
        S_OVER:    next_state = S_OVER;
    endcase
end

// =====================================================
// Can move logic
// =====================================================
wire can_move_p1_0 = (p1_pos_0==22)?0:((p1_pos_0>=23)?(dice_value==6):1);
wire can_move_p1_1 = (p1_pos_1==22)?0:((p1_pos_1>=23)?(dice_value==6):1);
wire can_move_p2_0 = (p2_pos_0==22)?0:((p2_pos_0>=23)?(dice_value==6):1);
wire can_move_p2_1 = (p2_pos_1==22)?0:((p2_pos_1>=23)?(dice_value==6):1);

// =====================================================
// Auto-select piece in S_SELECT
// =====================================================
always @(posedge clk) begin
    if(state==S_SELECT && confirm_rising) begin
        steps_left <= dice_value;
        if(player_turn==0) selected_piece <= can_move_p1_0 ? 0 : 1;
        else selected_piece <= can_move_p2_0 ? 0 : 1;
    end
end

// =====================================================
// Next square function
// =====================================================
function [4:0] next_square;
    input [4:0] pos;      // current position
    input       player;   // 0 = Red, 1 = Blue
    input [3:0] dice;     // the rolled value (1-6)
    begin
        // ----- BASE EXIT (only on 6) -----
        if (pos == 23 || pos == 24) begin               // Red base
            next_square = (dice == 6) ? 0 : pos;    // 0 = Red start
        end else if (pos == 25 || pos == 26) begin      // Blue base
            next_square = (dice == 6) ? 11 : pos;   // 11 = Blue start
        end
        // ----- HOME (never move) -----
        else if (pos == 22) begin
            next_square = 22;
        end
        // ----- SPECIAL TURNS -----
        else if (pos == 8) begin
            next_square = (player==1) ? 9 : 11;     // Blue ? final, Red ? outer
        end else if (pos == 19) begin
            next_square = (player==0) ? 20 : 0;     // Red ? final, Blue ? wrap
        end
        // ----- RED FINAL PATH -----
        else if (pos == 20) next_square = 21;
        else if (pos == 21) next_square = 22;
        // ----- BLUE FINAL PATH -----
        else if (pos == 9)  next_square = 10;
        else if (pos == 10) next_square = 22;
        // ----- OUTER RING (default) -----
        else if (pos < 19) begin
            next_square = pos + 1;
        end
        // ----- FALLBACK (should never hit) -----
        else begin
            next_square = pos;
        end
    end
endfunction


// =====================================================
// Move Logic
// =====================================================
reg [4:0] curr_pos, next_pos;
wire [3:0] dice_for_move = dice_value;
always @(*) begin
    curr_pos = (player_turn==0)? (selected_piece? p1_pos_1:p1_pos_0) : (selected_piece? p2_pos_1:p2_pos_0);
    next_pos = next_square(curr_pos, player_turn, dice_for_move);
end

always @(posedge clk) begin
    if(state==S_MOVE && steps_left>0) begin
        if(player_turn==0) begin // red turn
            if(selected_piece==0) p1_pos_0 <= next_pos;
            else p1_pos_1 <= next_pos;
        end else begin
            if(selected_piece==0) p2_pos_0 <= next_pos;
            else p2_pos_1 <= next_pos;
        end
        steps_left <= steps_left - 1;
    end
end

// =====================================================
// Capture Logic
// =====================================================
wire [26:0] safe_mask = 27'b111111100000000111000000001;

reg [4:0] landed;
always @(posedge clk) begin
    if(state==S_CAPTURE) begin
        landed = (player_turn==0)? (selected_piece? p1_pos_1:p1_pos_0) : (selected_piece? p2_pos_1:p2_pos_0);
        if(!safe_mask[landed]) begin
            if(player_turn==0) begin
                if(p2_pos_0==landed) p2_pos_0 <= 25;
                if(p2_pos_1==landed) p2_pos_1 <= 26;
            end else begin
                if(p1_pos_0==landed) p1_pos_0 <= 23;
                if(p1_pos_1==landed) p1_pos_1 <= 24;
            end
        end
    end
end

// =====================================================
// Next Turn & Win
// =====================================================
always @(posedge clk) begin
    if(state==S_NEXT) begin
        if((p1_pos_0==22 && p1_pos_1==22) || (p2_pos_0==22 && p2_pos_1==22)) game_over <= 1;
        if(!game_over && dice_value!=6) player_turn <= ~player_turn;
    end
end

// =====================================================
// Board Next Mapping
// =====================================================
assign board_next = {
    (p2_pos_0==26||p2_pos_1==26), (p2_pos_0==25||p2_pos_1==25),
    (p1_pos_0==24||p1_pos_1==24), (p1_pos_0==23||p1_pos_1==23),
    (p1_pos_0==22||p1_pos_1==22||p2_pos_0==22||p2_pos_1==22),
    (p1_pos_0==21||p1_pos_1==21||p2_pos_0==21||p2_pos_1==21),
    (p1_pos_0==20||p1_pos_1==20||p2_pos_0==20||p2_pos_1==20),
    (p1_pos_0==19||p1_pos_1==19||p2_pos_0==19||p2_pos_1==19),
    (p1_pos_0==18||p1_pos_1==18||p2_pos_0==18||p2_pos_1==18),
    (p1_pos_0==17||p1_pos_1==17||p2_pos_0==17||p2_pos_1==17),
    (p1_pos_0==16||p1_pos_1==16||p2_pos_0==16||p2_pos_1==16),
    (p1_pos_0==15||p1_pos_1==15||p2_pos_0==15||p2_pos_1==15),
    (p1_pos_0==14||p1_pos_1==14||p2_pos_0==14||p2_pos_1==14),
    (p1_pos_0==13||p1_pos_1==13||p2_pos_0==13||p2_pos_1==13),
    (p1_pos_0==12||p1_pos_1==12||p2_pos_0==12||p2_pos_1==12),
    (p1_pos_0==11||p1_pos_1==11||p2_pos_0==11||p2_pos_1==11),
    (p1_pos_0==10||p1_pos_1==10||p2_pos_0==10||p2_pos_1==10),
    (p1_pos_0==9||p1_pos_1==9||p2_pos_0==9||p2_pos_1==9),
    (p1_pos_0==8||p1_pos_1==8||p2_pos_0==8||p2_pos_1==8),
    (p1_pos_0==7||p1_pos_1==7||p2_pos_0==7||p2_pos_1==7),
    (p1_pos_0==6||p1_pos_1==6||p2_pos_0==6||p2_pos_1==6),
    (p1_pos_0==5||p1_pos_1==5||p2_pos_0==5||p2_pos_1==5),
    (p1_pos_0==4||p1_pos_1==4||p2_pos_0==4||p2_pos_1==4),
    (p1_pos_0==3||p1_pos_1==3||p2_pos_0==3||p2_pos_1==3),
    (p1_pos_0==2||p1_pos_1==2||p2_pos_0==2||p2_pos_1==2),
    (p1_pos_0==1||p1_pos_1==1||p2_pos_0==1||p2_pos_1==1),
    (p1_pos_0==0||p1_pos_1==0||p2_pos_0==0||p2_pos_1==0)
};

endmodule
