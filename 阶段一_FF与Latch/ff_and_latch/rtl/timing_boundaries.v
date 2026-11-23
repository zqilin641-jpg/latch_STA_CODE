`timescale 1ns / 1ps

module timing_boundaries (
    input wire clk_reference,
    input wire reset,
    input wire [7:0] data_in,
    input wire [7:0] core_result,
    output reg [7:0] core_input /* synthesis syn_preserve=1 */,
    output reg [7:0] result /* synthesis syn_preserve=1 */
);
    // Separate IO timing from the experimental internal storage.
    always @(posedge clk_reference or posedge reset) begin
        if (reset) begin
            core_input <= 8'h00;
            result <= 8'h00;
        end else begin
            core_input <= data_in;
            result <= core_result;
        end
    end
endmodule
