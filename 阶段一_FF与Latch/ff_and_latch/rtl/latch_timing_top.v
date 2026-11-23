`timescale 1ns / 1ps

module latch_timing_top (
    input wire clk_reference,
    input wire phase_a,
    input wire phase_b,
    input wire reset,
    input wire [7:0] data_in,
    output wire [7:0] result
);
    wire [7:0] core_input, core_result;
    timing_boundaries u_boundary (
        .clk_reference(clk_reference), .reset(reset), .data_in(data_in),
        .core_result(core_result), .core_input(core_input), .result(result)
    );
    latch_datapath u_core (
        .reset(reset), .phase_a(phase_a), .phase_b(phase_b),
        .data_in(core_input), .result(core_result)
    );
endmodule
