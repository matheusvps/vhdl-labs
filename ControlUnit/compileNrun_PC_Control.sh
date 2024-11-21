#!/bin/bash

ghdl -a ProgramCounter.vhd
ghdl -e ProgramCounter
ghdl -a ProgramCounter_Control.vhd
ghdl -e ProgramCounter_Control
ghdl -a ProgramCounter_Control_tb.vhd
ghdl -e ProgramCounter_Control_tb

ghdl -r ProgramCounter_Control_tb --wave=ProgramCounter_Control_tb_wave.ghw

gtkwave ProgramCounter_Control_tb_wave.ghw -o ProgramCounter_Control_tb_wave_config.gtkw
read  -n 1
