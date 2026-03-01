/*
 * Copyright (c) 2024 Your Name
 * SPDX-License-Identifier: Apache-2.0
 */

`default_nettype none

module tt_um_explorer 
  (input wire [7:0]	 ui_in, // Dedicated inputs
   output wire [7:0] uo_out, // Dedicated outputs
   input wire [7:0]  uio_in, // IOs: Input path
   output wire [7:0] uio_out, // IOs: Output path
   output wire [7:0] uio_oe, // IOs: Enable path (active high: 0=input, 1=output)
   input wire	     ena, // always 1 when the design is powered, so you can ignore it
   input wire	     clk, // clock
   input wire	     rst_n     // reset_n - low to reset
   );

  // All output pins must be assigned. If not used, assign to 0.
  assign uio_out = 8'd50;
  assign uio_oe  = 0;

  // List all unused inputs to prevent warnings
  wire		     _unused = &{ena, clk, rst_n, 1'b0};

  wire [100:0]	     stage; // 101 nodes: stage[0] through stage[100]
  // 100 inverter stages
  genvar	     i;
  generate
    for (i = 0; i < 100; i = i + 1) begin : inv_stage
      (* keep *) sky130_fd_sc_hd__inv_1 u_inv 
	     (.Y (stage[i+1]),
	      .A (stage[i]));
    end
  endgenerate

  assign uo_out = {7'd0, stage[100]};

endmodule
