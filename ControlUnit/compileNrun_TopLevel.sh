#!/bin/bash

ghdl -a ProgramCounter.vhd
ghdl -e ProgramCounter
ghdl -a ProgramCounter_Control.vhd
ghdl -e ProgramCounter_Control
ghdl -a ROM.vhd
ghdl -e ROM
ghdl -a ControlUnit.vhd
ghdl -e ControlUnit
ghdl -a TopLevel_tb.vhd
ghdl -e TopLevel_tb

ghdl -r TopLevel_tb --wave=TopLevel_tb_wave.ghw

gtkwave TopLevel_tb_wave.ghw -o TopLevel_tb_wave_config.gtkw
read  -n 1
