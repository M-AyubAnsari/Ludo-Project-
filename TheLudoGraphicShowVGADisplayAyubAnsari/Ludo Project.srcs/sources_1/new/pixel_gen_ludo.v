`timescale 1ns / 1ps
module pixel_gen_ludo (
    input clk_d,
    input [9:0] pixel_x,
    input [9:0] pixel_y,
    input video_on,
    output reg [3:0] red   = 0,
    output reg [3:0] green = 0,
    output reg [3:0] blue  = 0
);

    localparam BLACK  = 12'h000;
    localparam WHITE  = 12'hFFF;
    localparam YELLOW = 12'hFF0;
    localparam DGREEN = 12'h050;
    localparam DBLUE  = 12'h005;
    localparam BROWN  = 12'h840;

    function integer s;
        input integer x;
        s = (x * 51) / 100;
    endfunction

    localparam BASE_X = (640 - s(600)) / 2; // 167
    localparam BASE_Y = (480 - s(900)) / 2; // 10
    localparam RAD = 12;

    // Circle centers
    localparam G1_X = BASE_X + s(480);
    localparam G1_Y = BASE_Y + s(140);
    localparam G2_X = BASE_X + s(560);
    localparam G2_Y = BASE_Y + s(140);
    localparam B1_X = BASE_X + s(240);
    localparam B1_Y = BASE_Y + s(860);
    localparam B2_X = BASE_X + s(320);
    localparam B2_Y = BASE_Y + s(860);

    integer dx, dy;

    // ==================== DICE IN BOTTOM-RIGHT CORNER ====================
    localparam DICE_LEFT   = 540;
    localparam DICE_TOP    = 390;
    localparam DICE_SIZE   = 70;

    reg [26:0] dice_timer = 0;
    reg [2:0] dice_face = 0;  // 0 to 5 ? shows 1 to 6

    always @(posedge clk_d) begin
        dice_timer <= dice_timer + 1;
        if (dice_timer == 0) dice_face <= dice_face + 1;  // changes every ~0.6s at 50MHz
    end

    wire in_dice_area = (pixel_x >= DICE_LEFT && pixel_x < DICE_LEFT + DICE_SIZE &&
                         pixel_y >= DICE_TOP  && pixel_y < DICE_TOP  + DICE_SIZE);

    wire dice_border = in_dice_area &&
                       (pixel_x < DICE_LEFT+4 || pixel_x >= DICE_LEFT+DICE_SIZE-4 ||
                        pixel_y < DICE_TOP+4  || pixel_y >= DICE_TOP+DICE_SIZE-4);

    // Dot positions (10x10 pixel dots)
    wire dot_tl = (pixel_x >= DICE_LEFT+15 && pixel_x < DICE_LEFT+25) && (pixel_y >= DICE_TOP+15 && pixel_y < DICE_TOP+25);
    wire dot_tr = (pixel_x >= DICE_LEFT+45 && pixel_x < DICE_LEFT+55) && (pixel_y >= DICE_TOP+15 && pixel_y < DICE_TOP+25);
    wire dot_bl = (pixel_x >= DICE_LEFT+15 && pixel_x < DICE_LEFT+25) && (pixel_y >= DICE_TOP+45 && pixel_y < DICE_TOP+55);
    wire dot_br = (pixel_x >= DICE_LEFT+45 && pixel_x < DICE_LEFT+55) && (pixel_y >= DICE_TOP+45 && pixel_y < DICE_TOP+55);
    wire dot_mid = (pixel_x >= DICE_LEFT+30 && pixel_x < DICE_LEFT+40) && (pixel_y >= DICE_TOP+30 && pixel_y < DICE_TOP+40);

    // ====================================================================
    always @(posedge clk_d) begin
        if (!video_on) begin
            {red, green, blue} <= BLACK;
        end else begin
            {red, green, blue} <= BLACK;

            // ==================== YOUR ORIGINAL LUDO BOARD ====================
            if (pixel_x >= BASE_X + s(280) && pixel_x < BASE_X + s(520) &&
                pixel_y >= BASE_Y + s(180) && pixel_y < BASE_Y + s(260))
                {red, green, blue} <= YELLOW;
            if (pixel_y >= BASE_Y + s(580) && pixel_y < BASE_Y + s(740) &&
                pixel_x >= BASE_X + s(280) && pixel_x < BASE_X + s(520))
                {red, green, blue} <= YELLOW;
            if (pixel_y >= BASE_Y + s(260) && pixel_y < BASE_Y + s(420)) begin
                if (pixel_x >= BASE_X + s(280) && pixel_x < BASE_X + s(360))
                    {red, green, blue} <= YELLOW;
                if (pixel_x >= BASE_X + s(440) && pixel_x < BASE_X + s(520))
                    {red, green, blue} <= YELLOW;
            end
            if (pixel_x >= BASE_X + s(280) && pixel_x < BASE_X + s(520) &&
                pixel_y >= BASE_Y + s(420) && pixel_y < BASE_Y + s(580))
                {red, green, blue} <= BROWN;
            if (pixel_y >= BASE_Y + s(420) && pixel_y < BASE_Y + s(580)) begin
                if (pixel_x >= BASE_X + s(200) && pixel_x < BASE_X + s(280))
                    {red, green, blue} <= YELLOW;
                if (pixel_x >= BASE_X + s(520) && pixel_x < BASE_X + s(600))
                    {red, green, blue} <= YELLOW;
            end
            if (pixel_y >= BASE_Y + s(740) && pixel_y < BASE_Y + s(820) &&
                pixel_x >= BASE_X + s(200) && pixel_x < BASE_X + s(520))
                {red, green, blue} <= YELLOW;
            if (pixel_x >= BASE_X + s(440) && pixel_x < BASE_X + s(600) &&
                pixel_y >= BASE_Y + s(100) && pixel_y < BASE_Y + s(260))
                {red, green, blue} <= YELLOW;
            if (pixel_x >= BASE_X + s(200) && pixel_x < BASE_X + s(360) &&
                pixel_y >= BASE_Y + s(820) && pixel_y < BASE_Y + s(900))
                {red, green, blue} <= YELLOW;

            // Colored safe zones & diamonds
            if (pixel_y >= BASE_Y + s(260) && pixel_y < BASE_Y + s(420) &&
                pixel_x >= BASE_X + s(360) && pixel_x < BASE_X + s(440))
                {red, green, blue} <= DGREEN;
            if (pixel_y >= BASE_Y + s(580) && pixel_y < BASE_Y + s(740) &&
                pixel_x >= BASE_X + s(360) && pixel_x < BASE_X + s(440))
                {red, green, blue} <= DBLUE;

            if (pixel_x >= BASE_X + s(440) && pixel_x < BASE_X + s(520) &&
                pixel_y >= BASE_Y + s(180) && pixel_y < BASE_Y + s(260)) begin
                dx = (pixel_x > BASE_X + s(480)) ? pixel_x - (BASE_X + s(480)) : (BASE_X + s(480)) - pixel_x;
                dy = (pixel_y > BASE_Y + s(220)) ? pixel_y - (BASE_Y + s(220)) : (BASE_Y + s(220)) - pixel_y;
                if (dx + dy <= s(40))
                    {red, green, blue} <= DGREEN;
            end
            if (pixel_x >= BASE_X + s(280) && pixel_x < BASE_X + s(360) &&
                pixel_y >= BASE_Y + s(740) && pixel_y < BASE_Y + s(820)) begin
                dx = (pixel_x > BASE_X + s(320)) ? pixel_x - (BASE_X + s(320)) : (BASE_X + s(320)) - pixel_x;
                dy = (pixel_y > BASE_Y + s(780)) ? pixel_y - (BASE_Y + s(780)) : (BASE_Y + s(780)) - pixel_y;
                if (dx + dy <= s(40))
                    {red, green, blue} <= DBLUE;
            end

            if (pixel_x >= BASE_X + s(440) && pixel_x < BASE_X + s(600) &&
                pixel_y >= BASE_Y + s(100) && pixel_y < BASE_Y + s(260)) begin
                if ((pixel_x-G1_X)*(pixel_x-G1_X) + (pixel_y-G1_Y)*(pixel_y-G1_Y) <= RAD*RAD ||
                    (pixel_x-G2_X)*(pixel_x-G2_X) + (pixel_y-G2_Y)*(pixel_y-G2_Y) <= RAD*RAD)
                    {red, green, blue} <= DGREEN;
            end
            if (pixel_x >= BASE_X + s(200) && pixel_x < BASE_X + s(360) &&
                pixel_y >= BASE_Y + s(820) && pixel_y < BASE_Y + s(900)) begin
                if ((pixel_x-B1_X)*(pixel_x-B1_X) + (pixel_y-B1_Y)*(pixel_y-B1_Y) <= RAD*RAD ||
                    (pixel_x-B2_X)*(pixel_x-B2_X) + (pixel_y-B2_Y)*(pixel_y-B2_Y) <= RAD*RAD)
                    {red, green, blue} <= DBLUE;
            end

            // ============================= DICE ON TOP =============================
            if (in_dice_area) begin
                if (dice_border)
                    {red, green, blue} <= BLACK;
                else
                    {red, green, blue} <= WHITE;

                case (dice_face)
                    0: if (dot_mid)               {red, green, blue} <= BLACK; // 1
                    1: if (dot_tl || dot_br)      {red, green, blue} <= BLACK; // 2
                    2: if (dot_tl || dot_mid || dot_br) {red, green, blue} <= BLACK; // 3
                    3: if (dot_tl || dot_tr || dot_bl || dot_br) {red, green, blue} <= BLACK; // 4
                    4: if (dot_tl || dot_tr || dot_bl || dot_br || dot_mid) {red, green, blue} <= BLACK; // 5
                    5: if (dot_tl || dot_tr || dot_bl || dot_br || dot_mid || dot_mid) {red, green, blue} <= BLACK; // 6 (uses mid twice on purpose)
                    default: ;
                endcase
            end
        end
    end
endmodule