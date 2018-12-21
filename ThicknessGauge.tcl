# Copyright (C) 1991-2013 Altera Corporation
# Your use of Altera Corporation's design tools, logic functions 
# and other software and tools, and its AMPP partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Altera Program License 
# Subscription Agreement, Altera MegaCore Function License 
# Agreement, or other applicable license agreement, including, 
# without limitation, that your use is for the sole purpose of 
# programming logic devices manufactured by Altera and sold by 
# Altera or its authorized distributors.  Please refer to the 
# applicable agreement for further details.

# Quartus II 64-Bit Version 13.0.1 Build 232 06/12/2013 Service Pack 1 SJ Full Version
# File: E:\FPGA\FPGA_FD_v1.0_20160527\ThicknessGauge.tcl
# Generated on: Mon Aug 01 16:14:25 2016

package require ::quartus::project

set_location_assignment PIN_38 -to PWDN
set_location_assignment PIN_109 -to CH1_EN
set_location_assignment PIN_111 -to CH1_H
set_location_assignment PIN_110 -to CH1_L
set_location_assignment PIN_63 -to CH0_EN
set_location_assignment PIN_65 -to CH0_H
set_location_assignment PIN_64 -to CH0_L
set_location_assignment PIN_150 -to RESET_IN
set_location_assignment PIN_188 -to ARM_ADDR[7]
set_location_assignment PIN_236 -to ARM_ADDR[6]
set_location_assignment PIN_189 -to ARM_ADDR[5]
set_location_assignment PIN_194 -to ARM_ADDR[3]
set_location_assignment PIN_195 -to ARM_ADDR[1]
set_location_assignment PIN_196 -to ARM_DATA[15]
set_location_assignment PIN_197 -to ARM_DATA[13]
set_location_assignment PIN_200 -to ARM_DATA[11]
set_location_assignment PIN_201 -to ARM_DATA[9]
set_location_assignment PIN_202 -to ARM_DATA[7]
set_location_assignment PIN_203 -to ARM_DATA[5]
set_location_assignment PIN_207 -to ARM_DATA[3]
set_location_assignment PIN_214 -to ARM_DATA[1]
set_location_assignment PIN_216 -to ARM_OEn
set_location_assignment PIN_217 -to ARM_CE
set_location_assignment PIN_218 -to ARM_WEn
set_location_assignment PIN_219 -to ARM_DATA[0]
set_location_assignment PIN_221 -to ARM_DATA[2]
set_location_assignment PIN_223 -to ARM_DATA[4]
set_location_assignment PIN_224 -to ARM_DATA[6]
set_location_assignment PIN_226 -to ARM_DATA[8]
set_location_assignment PIN_230 -to ARM_DATA[10]
set_location_assignment PIN_231 -to ARM_DATA[12]
set_location_assignment PIN_232 -to ARM_DATA[14]
set_location_assignment PIN_233 -to ARM_ADDR[0]
set_location_assignment PIN_234 -to ARM_ADDR[2]
set_location_assignment PIN_235 -to ARM_ADDR[4]
set_location_assignment PIN_152 -to FPGA_CLK_SYS
set_location_assignment PIN_146 -to LCDBL_EN
set_location_assignment PIN_143 -to SDA_ASW
set_location_assignment PIN_144 -to SCL_ASW
set_location_assignment PIN_145 -to RESET_ASW
set_location_assignment PIN_139 -to receive_amp_en
set_location_assignment PIN_137 -to PROBE_MODE
set_location_assignment PIN_132 -to DA_LDAC
set_location_assignment PIN_133 -to DA_DIN
set_location_assignment PIN_134 -to DA_SCLK
set_location_assignment PIN_135 -to DA_SYNC
set_location_assignment PIN_131 -to AD_CLK
set_location_assignment PIN_106 -to FIFO_D[13]
set_location_assignment PIN_103 -to FIFO_D[12]
set_location_assignment PIN_100 -to FIFO_D[11]
set_location_assignment PIN_99 -to FIFO_D[10]
set_location_assignment PIN_98 -to FIFO_D[9]
set_location_assignment PIN_95 -to FIFO_D[8]
set_location_assignment PIN_94 -to FIFO_D[7]
set_location_assignment PIN_93 -to FIFO_D[6]
set_location_assignment PIN_92 -to FIFO_D[5]
set_location_assignment PIN_91 -to FIFO_D[4]
set_location_assignment PIN_90 -to FIFO_D[3]
set_location_assignment PIN_89 -to FIFO_D[2]
set_location_assignment PIN_88 -to FIFO_D[1]
set_location_assignment PIN_87 -to FIFO_D[0]
set_location_assignment PIN_126 -to FIFO_EF
set_location_assignment PIN_117 -to FIFO_FF
set_location_assignment PIN_119 -to FIFO_HF
set_location_assignment PIN_120 -to FIFO_PAE
set_location_assignment PIN_118 -to FIFO_PAF
set_location_assignment PIN_127 -to FIFO_RCLK
set_location_assignment PIN_128 -to FIFO_REN
set_location_assignment PIN_113 -to FIFO_WCLK
set_location_assignment PIN_112 -to FIFO_WEN
set_location_assignment PIN_45 -to CODER_A
set_location_assignment PIN_46 -to CODER_B
set_location_assignment PIN_37 -to FPGA_BUZZER
set_location_assignment PIN_177 -to FPGA_GPIO[7]
set_location_assignment PIN_181 -to FPGA_GPIO[6]
set_location_assignment PIN_182 -to FPGA_GPIO[5]
set_location_assignment PIN_184 -to FPGA_GPIO[3]
set_location_assignment PIN_185 -to FPGA_GPIO[2]
set_location_assignment PIN_147 -to KEY_CTRL
set_location_assignment PIN_149 -to KEY_DET
set_location_assignment PIN_114 -to MRS
set_location_assignment PIN_108 -to OE
set_location_assignment PIN_183 -to FPGA_GPIO[4]
set_location_assignment PIN_83 -to AD_DCO
set_location_assignment PIN_84 -to AD_OE_N
set_location_assignment PIN_107 -to AD_OR
set_location_assignment PIN_78 -to AD_PDWN
set_location_assignment PIN_186 -to FPGA_GPIO[1]
set_location_assignment PIN_187 -to FPGA_GPIO[0]
set_location_assignment PIN_81 -to AD_DFS
set_location_assignment PIN_167 -to KEY_DET_ARM
set_location_assignment PIN_21 -to CHARGH_H
set_location_assignment PIN_22 -to CHARGH_L
set_location_assignment PIN_5 -to HV_SCL
set_location_assignment PIN_4 -to HV_SDA
