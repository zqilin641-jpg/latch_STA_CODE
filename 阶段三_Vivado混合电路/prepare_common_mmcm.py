from pathlib import Path
B=Path.cwd(); R=B/'common_mmcm'; R.mkdir(exist_ok=True)
for name in ['ff_balanced','latch_short_4']:
 s=B/'frequency_search'/name; d=R/name; d.mkdir(exist_ok=True)
 rtl=(s/'design.v').read_text().replace('BUFG clock_buffer(.I(clk_in),.O(clk));', '''wire mm_out,fb_raw,fb,locked;
MMCME2_BASE #(.CLKIN1_PERIOD(10.0),.CLKFBOUT_MULT_F(8.0),.DIVCLK_DIVIDE(1),.CLKOUT0_DIVIDE_F(8.0),.CLKOUT0_PHASE(0.0)) common_mmcm(.CLKIN1(clk_in),.CLKFBIN(fb),.CLKFBOUT(fb_raw),.CLKOUT0(mm_out),.LOCKED(locked),.RST(1'b0),.PWRDWN(1'b0));
BUFG feedback_buffer(.I(fb_raw),.O(fb));
BUFG clock_buffer(.I(mm_out),.O(clk));''')
 (d/'design.v').write_text(rtl)
 (d/'timing.xdc').write_text((s/'timing.xdc').read_text()+'\nset_clock_uncertainty 0.2 [get_clocks -include_generated_clocks common_clock]\n')
 t=(s/'build.tcl').read_text().replace(s.as_posix(),d.as_posix()).replace(' || [llength [get_clocks]]!=1','')
 (d/'build.tcl').write_text(t)
(R/'build.tcl').write_text('\n'.join('source {'+(R/n/'build.tcl').as_posix()+'}' for n in ['ff_balanced','latch_short_4'])+'\nexit\n')
