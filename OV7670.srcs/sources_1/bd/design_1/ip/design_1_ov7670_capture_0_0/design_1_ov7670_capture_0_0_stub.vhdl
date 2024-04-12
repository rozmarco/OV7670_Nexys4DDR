-- Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2018.3 (lin64) Build 2405991 Thu Dec  6 23:36:41 MST 2018
-- Date        : Tue Mar  5 12:36:36 2024
-- Host        : rozmarco-ThinkPad-T490s running 64-bit Ubuntu 22.04.3 LTS
-- Command     : write_vhdl -force -mode synth_stub
--               /home/rozmarco/Documents/ECE532/OV7670/OV7670.srcs/sources_1/bd/design_1/ip/design_1_ov7670_capture_0_0/design_1_ov7670_capture_0_0_stub.vhdl
-- Design      : design_1_ov7670_capture_0_0
-- Purpose     : Stub declaration of top-level module interface
-- Device      : xc7a100tcsg324-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity design_1_ov7670_capture_0_0 is
  Port ( 
    pclk : in STD_LOGIC;
    vsync : in STD_LOGIC;
    href : in STD_LOGIC;
    d : in STD_LOGIC_VECTOR ( 7 downto 0 );
    addr : out STD_LOGIC_VECTOR ( 17 downto 0 );
    dout : out STD_LOGIC_VECTOR ( 11 downto 0 );
    we : out STD_LOGIC
  );

end design_1_ov7670_capture_0_0;

architecture stub of design_1_ov7670_capture_0_0 is
attribute syn_black_box : boolean;
attribute black_box_pad_pin : string;
attribute syn_black_box of stub : architecture is true;
attribute black_box_pad_pin of stub : architecture is "pclk,vsync,href,d[7:0],addr[17:0],dout[11:0],we";
attribute X_CORE_INFO : string;
attribute X_CORE_INFO of stub : architecture is "ov7670_capture,Vivado 2018.3";
begin
end;
