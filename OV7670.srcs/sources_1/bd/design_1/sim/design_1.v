//Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
//--------------------------------------------------------------------------------
//Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
//Date        : Tue Mar  5 19:14:46 2024
//Host        : rozmarco-ThinkPad-T490s running 64-bit Ubuntu 22.04.3 LTS
//Command     : generate_target design_1.bd
//Design      : design_1
//Purpose     : IP block netlist
//--------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CORE_GENERATION_INFO = "design_1,IP_Integrator,{x_ipVendor=xilinx.com,x_ipLibrary=BlockDiagram,x_ipName=design_1,x_ipVersion=1.00.a,x_ipLanguage=VERILOG,numBlks=6,numReposBlks=6,numNonXlnxBlks=0,numHierBlks=0,maxHierDepth=0,numSysgenBlks=0,numHlsBlks=0,numHdlrefBlks=4,numPkgbdBlks=0,bdsource=USER,da_board_cnt=1,synth_mode=OOC_per_IP}" *) (* HW_HANDOFF = "design_1.hwdef" *) 
module design_1
   (clk_in1_0,
    config_finished_0,
    d_0,
    href_0,
    i_0,
    pclk_0,
    pwdn_0,
    reset_0,
    sioc_0,
    siod_0,
    vga_blue_0,
    vga_green_0,
    vga_hsync_0,
    vga_red_0,
    vga_vsync_0,
    vsync_0,
    xclk_0);
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 CLK.CLK_IN1_0 CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME CLK.CLK_IN1_0, CLK_DOMAIN design_1_clk_in1_0, FREQ_HZ 100000000, INSERT_VIP 0, PHASE 0.000" *) input clk_in1_0;
  output config_finished_0;
  input [7:0]d_0;
  input href_0;
  input i_0;
  input pclk_0;
  output pwdn_0;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 RST.RESET_0 RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME RST.RESET_0, INSERT_VIP 0, POLARITY ACTIVE_LOW" *) output reset_0;
  output sioc_0;
  inout siod_0;
  output [3:0]vga_blue_0;
  output [3:0]vga_green_0;
  output vga_hsync_0;
  output [3:0]vga_red_0;
  output vga_vsync_0;
  input vsync_0;
  output xclk_0;

  wire Net;
  wire [11:0]blk_mem_gen_0_doutb;
  wire clk_in1_0_1;
  wire clk_wiz_0_clk_out1;
  wire clk_wiz_0_clk_out2;
  wire [7:0]d_0_1;
  wire debounce_0_o;
  wire href_0_1;
  wire i_0_1;
  wire [17:0]ov7670_capture_0_addr;
  wire [11:0]ov7670_capture_0_dout;
  wire ov7670_capture_0_we;
  wire ov7670_controller_0_config_finished;
  wire ov7670_controller_0_pwdn;
  wire ov7670_controller_0_reset;
  wire ov7670_controller_0_sioc;
  wire ov7670_controller_0_xclk;
  wire [17:0]ov7670_vga_0_frame_addr;
  wire [3:0]ov7670_vga_0_vga_blue;
  wire [3:0]ov7670_vga_0_vga_green;
  wire ov7670_vga_0_vga_hsync;
  wire [3:0]ov7670_vga_0_vga_red;
  wire ov7670_vga_0_vga_vsync;
  wire pclk_0_1;
  wire vsync_0_1;

  assign clk_in1_0_1 = clk_in1_0;
  assign config_finished_0 = ov7670_controller_0_config_finished;
  assign d_0_1 = d_0[7:0];
  assign href_0_1 = href_0;
  assign i_0_1 = i_0;
  assign pclk_0_1 = pclk_0;
  assign pwdn_0 = ov7670_controller_0_pwdn;
  assign reset_0 = ov7670_controller_0_reset;
  assign sioc_0 = ov7670_controller_0_sioc;
  assign vga_blue_0[3:0] = ov7670_vga_0_vga_blue;
  assign vga_green_0[3:0] = ov7670_vga_0_vga_green;
  assign vga_hsync_0 = ov7670_vga_0_vga_hsync;
  assign vga_red_0[3:0] = ov7670_vga_0_vga_red;
  assign vga_vsync_0 = ov7670_vga_0_vga_vsync;
  assign vsync_0_1 = vsync_0;
  assign xclk_0 = ov7670_controller_0_xclk;
  design_1_blk_mem_gen_0_0 blk_mem_gen_0
       (.addra(ov7670_capture_0_addr),
        .addrb(ov7670_vga_0_frame_addr),
        .clka(pclk_0_1),
        .clkb(clk_wiz_0_clk_out1),
        .dina(ov7670_capture_0_dout),
        .doutb(blk_mem_gen_0_doutb),
        .wea(ov7670_capture_0_we));
  design_1_clk_wiz_0_0 clk_wiz_0
       (.clk_in1(clk_in1_0_1),
        .clk_out1(clk_wiz_0_clk_out1),
        .clk_out2(clk_wiz_0_clk_out2));
  design_1_debounce_0_0 debounce_0
       (.clk(clk_wiz_0_clk_out1),
        .i(i_0_1),
        .o(debounce_0_o));
  design_1_ov7670_capture_0_0 ov7670_capture_0
       (.addr(ov7670_capture_0_addr),
        .d(d_0_1),
        .dout(ov7670_capture_0_dout),
        .href(href_0_1),
        .pclk(pclk_0_1),
        .vsync(vsync_0_1),
        .we(ov7670_capture_0_we));
  design_1_ov7670_controller_0_0 ov7670_controller_0
       (.clk(clk_wiz_0_clk_out1),
        .config_finished(ov7670_controller_0_config_finished),
        .pwdn(ov7670_controller_0_pwdn),
        .resend(debounce_0_o),
        .reset(ov7670_controller_0_reset),
        .sioc(ov7670_controller_0_sioc),
        .siod(siod_0),
        .xclk(ov7670_controller_0_xclk));
  design_1_ov7670_vga_0_0 ov7670_vga_0
       (.clk25(clk_wiz_0_clk_out2),
        .frame_addr(ov7670_vga_0_frame_addr),
        .frame_pixel(blk_mem_gen_0_doutb),
        .vga_blue(ov7670_vga_0_vga_blue),
        .vga_green(ov7670_vga_0_vga_green),
        .vga_hsync(ov7670_vga_0_vga_hsync),
        .vga_red(ov7670_vga_0_vga_red),
        .vga_vsync(ov7670_vga_0_vga_vsync));
endmodule
