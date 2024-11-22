#!/bin/bash

ghdl -a *.vhd
ghdl -e ProgramCounter, ProgramCounter_Control, ROM, StateMachine, ControlUnit, TopLevel_tb

ghdl -r TopLevel_tb --wave=TopLevel_tb_wave.ghw

gtkwave TopLevel_tb_wave.ghw -o TopLevel_tb_wave_config.gtkw
read  -n 1
