# OV7670_Nexys4DDR

This repository utilizing source code from [this project repository](https://github.com/laurivosandi/hdl/tree/master/zynq). 

A constraint file was included for the Nexys 4 DDR board with the OV7670 Camera module using the JA and JB PMOD ports. 

This code was a part of a larger project, [FPGA Audio Localization Search and Rescue Robot](https://github.com/ece532-ProjectGroup4/ECE532/tree/main). It displays the VGA output of the camera module with text information from the search and rescus robot. 

A customization that was added from the original source code was adapting the code for the Nexys 4 DDR board's RGB444 VGA output as opposed to the original code's RGB565. Additionally, the text display logic was added to the ov7670_vga.vhd module to display information from two input signals.

