@echo off
REM ****************************************************************************
REM Vivado (TM) v2020.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Wed May 24 11:19:32 +0200 2023
REM SW Build 3064766 on Wed Nov 18 09:12:45 MST 2020
REM
REM Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim tb_led_command_behav -key {Behavioral:sim_1:Functional:tb_led_command} -tclbatch tb_led_command.tcl -view C:/Users/Thomas/Documents/Travail/Formation/FPGA/TP/TP4/vivado/tp4_led_memory/tb_led_command_behav.wcfg -log simulate.log"
call xsim  tb_led_command_behav -key {Behavioral:sim_1:Functional:tb_led_command} -tclbatch tb_led_command.tcl -view C:/Users/Thomas/Documents/Travail/Formation/FPGA/TP/TP4/vivado/tp4_led_memory/tb_led_command_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
