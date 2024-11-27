#!/bin/bash

ghdl -a ProgramCounter.vhd
ghdl -e ProgramCounter
ghdl -a ProgramCounter_tb.vhd
ghdl -e ProgramCounter_tb

ghdl -r ProgramCounter_tb --wave=ProgramCounter_tb_wave.ghw

gtkwave ProgramCounter_tb_wave.ghw -o ProgramCounter_tb_wave_config.gtkw
read  -n 1
