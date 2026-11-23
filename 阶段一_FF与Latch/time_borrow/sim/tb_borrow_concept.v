`timescale 1ns / 1ps

// RTL-only illustration: deliberately delay input stimulus, not cell models.
// These 40..200 / 320..480 ns phases are not the PDS borrow/overflow clocks.
module tb_borrow_concept;
    reg phase_a = 0, phase_b = 0, reset = 1, grs_n = 0;
    reg [7:0] early_data = 0, late_data = 0, missed_data = 0;
    wire [7:0] early_result, late_result, missed_result;
    integer checks = 0, errors = 0;
    integer early_launch = -1, late_launch = -1;
    reg test_done = 0;
    localparam [7:0] SAMPLE = 8'h96;
    localparam [7:0] SUM = 8'hcf;

    GTP_GRS GRS_INST (.GRS_N(grs_n));
    latch_datapath early (.reset(reset), .phase_a(phase_a), .phase_b(phase_b),
        .data_in(early_data), .result(early_result));
    latch_datapath late (.reset(reset), .phase_a(phase_a), .phase_b(phase_b),
        .data_in(late_data), .result(late_result));
    latch_datapath missed (.reset(reset), .phase_a(phase_a), .phase_b(phase_b),
        .data_in(missed_data), .result(missed_result));

    function [7:0] reference;
        input [7:0] x;
        integer sum, rotated;
        begin
            sum = (x + 57) % 256;
            rotated = ((sum * 8) + (sum / 32)) % 256;
            reference = rotated ^ 167;
        end
    endfunction

    task check;
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

    always @(early.stage_one)
        if (early.stage_one === SUM && early_launch < 0) early_launch = $time;
    always @(late.stage_one)
        if (late.stage_one === SUM && late_launch < 0) late_launch = $time;

    initial begin
        #5 grs_n = 1;
        #5 reset = 0;
    end
    initial begin
        #40 phase_a = 1;
        #160 phase_a = 0;
        #120 phase_b = 1;
        #160 phase_b = 0;
        #200 phase_a = 1;
        #160 phase_a = 0;
        #120 phase_b = 1;
        #160 phase_b = 0;
    end
    initial #20 early_data = SAMPLE;
    initial #60 late_data = SAMPLE;
    initial #220 missed_data = SAMPLE;

    initial begin
        #21;
        check(early.stage_one === 0, "early input cannot cross closed latch");
        check(late.stage_one === 0, "late latch initially holds reset value");
        check(missed.stage_one === 0, "missed latch initially holds reset value");
        #20;
        check(early.stage_one === SUM, "early data propagates at opening");
        check(late.stage_one === 8'h39, "late sample has not arrived yet");
        check(missed.stage_one === 8'h39, "negative sample has not arrived yet");
        #20;
        check(early.stage_one === SUM, "early first stage remains correct");
        check(late.stage_one === SUM, "late data crosses while transparent");
        check(missed.stage_one === 8'h39, "negative first stage still has old data");
        #140;
        check(missed.stage_one === 8'h39, "first window closes with old data");
        #20;
        check(missed.stage_one === 8'h39, "post-close input cannot cross");
        #100;
        check(early_result === reference(SAMPLE), "early transaction succeeds");
        check(late_result === reference(SAMPLE), "borrowed transaction succeeds");
        check(missed_result === reference(0), "negative control retains previous transaction");
        check(missed_result !== reference(SAMPLE), "expected transaction failure is detected");
        check(early_launch == 40, "early sample launches at opening");
        check(late_launch == 60, "late sample launches at data arrival");
        check(late_launch - early_launch == 20, "next-stage launch loses 20 ns");
        #160;
        check(missed_result === reference(0), "missed output stays old after B closes");
        check(late_result === reference(SAMPLE), "borrowed output stays correct after B closes");
        #200;
        check(missed.stage_one === SUM, "missed input is accepted in next A window");
        #280;
        check(missed_result === reference(SAMPLE), "missed transaction appears one cycle late");
        if (errors != 0) $fatal(1, "Concept test failed");
        $display("PASS: concept checks=%0d; early=%0d ns; borrowed=%0d ns; launch shift=%0d ns",
            checks, early_launch, late_launch, late_launch - early_launch);
        test_done = 1;
    end
    initial begin
        #2000;
        if (!test_done) $fatal(1, "Concept test timed out");
    end
endmodule
