`timescale 1ns / 1ps
 
// =====================================================
// BoardOccAggregator
// Aggregates 27 IR sensors into board_occ[26:0]
// Each sensor latched on confirm_btn rising edge
// =====================================================
module BoardOccAggregator #(
    parameter INVERT_SENSOR = 1  // 1 = active-low (object blocks ? 0)
) (
    input  wire        clk,
    input  wire        reset,
    input  wire        confirm_btn,
    input  wire [26:0] sensor_in,     // 27 raw sensor inputs
    output reg  [26:0] board_occ      // Final latched occupancy
);
 
    // -------------------------------------------------
    // Wires for latched sensor outputs
    // -------------------------------------------------
    wire [26:0] sensor_latched;
 
    // -------------------------------------------------
    // Instantiate 27 sensor_latch modules
    // -------------------------------------------------
    genvar i;
    generate
        for (i = 0; i < 27; i = i + 1) begin : sensor_array
            sensor_latch #(
                .INVERT_SENSOR(INVERT_SENSOR)
            ) latch_inst (
                .clk          (clk),
                .reset        (reset),
                .sensor_in    (sensor_in[i]),
                .confirm_btn  (confirm_btn),
                .sensor_out   (sensor_latched[i])
            );
        end
    endgenerate
 
    // -------------------------------------------------
    // Aggregate into board_occ
    // -------------------------------------------------
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            board_occ <= 27'b0;  // All clear on reset
        end else begin
            board_occ <= sensor_latched;
        end
    end
 
endmodule