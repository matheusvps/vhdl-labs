#!/bin/bash

ghdl -a ROM.vhd
ghdl -e ROM
ghdl -a ProgramCounter.vhd
ghdl -e ProgramCounter
ghdl -a ProgramCounter_Control.vhd
ghdl -e ProgramCounter_Control
ghdl -a Connection_ROM_PC_tb.vhd
ghdl -e Connection_ROM_PC_tb

ghdl -r Connection_ROM_PC_tb --wave=Connection_ROM_PC_tb_wave.ghw

gtkwave Connection_ROM_PC_tb_wave.ghw -o Connection_ROM_PC_tb_wave_config.gtkw
read  -n 1
