`timescale 1ns / 1ps

module ff_timing_top (
    input wire clk_reference,
    input wire reset,
    input wire [7:0] data_in,
    output wire [7:0] result
);
    wire [7:0] core_input, core_result;
    timing_boundaries u_boundary (
        .clk_reference(clk_reference), .reset(reset), .data_in(data_in),
        .core_result(core_result), .core_input(core_input), .result(result)
    );
    ff_datapath u_core (
        .clk(clk_reference), .reset(reset), .sample_enable(1'b1),
        .data_in(core_input), .result(core_result)
    );
endmodule
