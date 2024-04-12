// Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
// Date        : Tue Mar  5 12:37:09 2024
// Host        : rozmarco-ThinkPad-T490s running 64-bit Ubuntu 22.04.3 LTS
// Command     : write_verilog -force -mode synth_stub
//               /home/rozmarco/Documents/ECE532/OV7670/OV7670.srcs/sources_1/bd/design_1/ip/design_1_debounce_0_0/design_1_debounce_0_0_stub.v
// Design      : design_1_debounce_0_0
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a100tcsg324-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* X_CORE_INFO = "debounce,Vivado 2018.3" *)
module design_1_debounce_0_0(clk, i, o)
/* synthesis syn_black_box black_box_pad_pin="clk,i,o" */;
  input clk;
  input i;
  output o;
endmodule
