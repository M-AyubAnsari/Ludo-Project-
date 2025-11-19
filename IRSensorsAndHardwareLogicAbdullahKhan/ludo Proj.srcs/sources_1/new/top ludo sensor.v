// TopLudoWithSensors.v (updated)
module TopLudoWithSensors(
    input  wire       clk,
    input  wire       reset,
    input  wire       roll_btn,
    input  wire       confirm_btn,
    input  wire       btn_piece0,
    input  wire       btn_piece1,
    input  wire [26:0] sensor_in,
    output wire [15:0] led,
    output wire [6:0] seg,      // 7-segment
    output wire [3:0] an        // digit select
);
 
    wire [26:0] board_next;
    wire [26:0] board_occ;
    wire [3:0]  dice_value;
    wire        player_turn;
 
    // Game
    LudoFull game (
        .clk(clk), .reset(reset),
        .roll_btn(roll_btn), .confirm_btn(confirm_btn),
        .btn_piece0(btn_piece0), .btn_piece1(btn_piece1),
        .board_next(board_next),
        .dice_value(dice_value),
        .player_turn(player_turn),
        .p1_pos_0(), .p1_pos_1(), .p2_pos_0(), .p2_pos_1(),
        .game_over(), .status_led()
    );
 
    // Sensors
    BoardOccAggregator #(.INVERT_SENSOR(1)) sensors (
        .clk(clk), .reset(reset),
        .confirm_btn(confirm_btn),
        .sensor_in(sensor_in),
        .board_occ(board_occ)
    );
 
    // LEDs
    LudoLedTest display (
        .clk(clk), .reset(reset),
        .board_next(board_next),
        .board_occ(board_occ),
        .led(led)
    );
 
    // DICE DISPLAY
    DiceDisplay dice_disp (
        .clk(clk),
        .reset(reset),
        .dice_value(dice_value),
        .player_turn(player_turn),
        .seg(seg),
        .an(an)
    );
 
endmodule