`default_nettype none
`timescale 1ns / 1ps

/* 
 * Testbench for TinyTapeout user project.
 * This only instantiates the DUT and exposes signals to cocotb.
 */
module tb ();

  // Dump waveforms
  initial begin
    $dumpfile("tb.fst");
    $dumpvars(0, tb);
  end

  // Clock and reset
  reg clk;
  reg rst_n;
  reg ena;

  // TinyTapeout IOs
  reg  [7:0] ui_in;
  reg  [7:0] uio_in;
  wire [7:0] uo_out;
  wire [7:0] uio_out;
  wire [7:0] uio_oe;

`ifdef GL_TEST
  // Power pins for gate-level simulation
  wire VPWR = 1'b1;
  wire VGND = 1'b0;
`endif

  // Instantiate YOUR design (FIXED NAME)
  tt_um_alu_4bit user_project (
`ifdef GL_TEST
      .VPWR    (VPWR),
      .VGND    (VGND),
`endif
      .ui_in   (ui_in),
      .uo_out  (uo_out),
      .uio_in  (uio_in),
      .uio_out (uio_out),
      .uio_oe  (uio_oe),
      .ena     (ena),
      .clk     (clk),
      .rst_n   (rst_n)
  );

endmodule
