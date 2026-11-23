`timescale 1ns / 1ps

module tb_independent_timing;
    reg clk_reference = 1'b0;
    reg phase_a = 1'b0, phase_b = 1'b0;
    reg phase_a40 = 1'b0, phase_b40 = 1'b0;
    reg reset = 1'b1;
    reg grs_n = 1'b0;
    reg [7:0] data_in = 8'd0;
    wire [7:0] ff_result, latch_result, latch40_result;
    reg [7:0] history0 = 8'd0, history1 = 8'd0, history2 = 8'd0;
    integer launches = 0;
    integer ff_checks = 0, latch_checks = 0, latch40_checks = 0;
    integer checks = 0, errors = 0, value;
    reg collecting = 1'b1;
    reg test_done = 1'b0;

    GTP_GRS GRS_INST (.GRS_N(grs_n));
    ff_timing_top ff (
        .clk_reference(clk_reference), .reset(reset),
        .data_in(data_in), .result(ff_result)
    );
    latch_timing_top latch25 (
        .clk_reference(clk_reference), .phase_a(phase_a), .phase_b(phase_b),
        .reset(reset), .data_in(data_in), .result(latch_result)
    );
    latch_timing_top latch40 (
        .clk_reference(clk_reference), .phase_a(phase_a40), .phase_b(phase_b40),
        .reset(reset), .data_in(data_in), .result(latch40_result)
    );

    function [7:0] reference;
        input [7:0] sample;
        integer sum, rotated;
        begin
            sum = (sample + 57) % 256;
            rotated = ((sum * 8) + (sum / 32)) % 256;
            reference = rotated ^ 167;
        end
    endfunction

    task expect_true;
        input condition;
        input [511:0] description;
        begin
            checks = checks + 1;
            if (condition !== 1'b1) begin
                errors = errors + 1;
                $display("FAIL: %0s at %0t", description, $time);
            end
        end
    endtask

    initial begin
        while (!test_done) begin
            #320;
            if (!test_done) clk_reference = !clk_reference;
        end
    end
    always @(posedge clk_reference) begin
        #40 phase_a = 1'b1;
        #160 phase_a = 1'b0;
        #120 phase_b = 1'b1;
        #160 phase_b = 1'b0;
    end
    always @(posedge clk_reference) begin
        #40 phase_a40 = 1'b1;
        #256 phase_a40 = 1'b0;
        #64 phase_b40 = 1'b1;
        #256 phase_b40 = 1'b0;
    end
    always @(phase_a or phase_b or phase_a40 or phase_b40) begin
        if ((phase_a && phase_b) || (phase_a40 && phase_b40))
            $fatal(1, "Ideal phase windows overlap.");
    end

    always @(posedge clk_reference) begin
        if (reset) begin
            launches = 0;
            history0 = 8'd0;
            history1 = 8'd0;
            history2 = 8'd0;
        end else if (collecting) begin
            #1;
            if (launches >= 1 && latch_checks < 256) begin
                expect_true(latch_result === reference(history0),
                    "25-percent latch transaction");
                latch_checks = latch_checks + 1;
                expect_true(latch40_result === reference(history0),
                    "40-percent latch transaction");
                latch40_checks = latch40_checks + 1;
            end
            // Including the identical IO boundaries: FF latency=3, latch=1.
            if (launches >= 3 && ff_checks < 256) begin
                expect_true(ff_result === reference(history2), "FF transaction");
                ff_checks = ff_checks + 1;
            end
            history2 = history1;
            history1 = history0;
            history0 = data_in;
            launches = launches + 1;
        end
    end

    initial begin
        #45 grs_n = 1'b1;
        @(negedge clk_reference);
        reset = 1'b0;
        data_in = 8'd0;
        for (value = 1; value < 256; value = value + 1) begin
            @(negedge clk_reference);
            data_in = value[7:0];
        end
        wait (ff_checks == 256 && latch_checks == 256 && latch40_checks == 256);
        #2;
        expect_true(ff_checks == 256, "FF covers all 256 inputs");
        expect_true(latch_checks == 256, "25-percent latch covers all 256 inputs");
        expect_true(latch40_checks == 256, "40-percent latch covers all 256 inputs");
        collecting = 1'b0;

        @(posedge phase_a);
        reset = 1'b1;
        data_in = 8'h96;
        #1;
        expect_true(ff_result === 8'h00, "FF reset while latch window is open");
        expect_true(latch_result === 8'h00, "25-percent latch asynchronous reset");
        expect_true(latch40_result === 8'h00, "40-percent latch asynchronous reset");
        @(negedge clk_reference); reset = 1'b0;
        repeat (4) @(posedge clk_reference);
        #1;
        expect_true(ff_result === reference(8'h96), "FF pipeline recovers");
        expect_true(latch_result === reference(8'h96), "25-percent latch recovers");
        expect_true(latch40_result === reference(8'h96), "40-percent latch recovers");
        if (errors != 0) $fatal(1, "Independent timing test failed: %0d errors", errors);
        $display("PASS: independent timing wrappers; checks=%0d; errors=%0d", checks, errors);
        test_done = 1'b1;
    end
    initial begin
        #1000000;
        if (!test_done) $fatal(1, "Independent timing test timeout.");
    end
endmodule
