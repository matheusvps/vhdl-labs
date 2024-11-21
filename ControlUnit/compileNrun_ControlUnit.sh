#!/bin/bash

ghdl -a ControlUnit.vhd
ghdl -e ControlUnit
ghdl -a ControlUnit_tb.vhd
ghdl -e ControlUnit_tb

ghdl -r ControlUnit_tb --wave=ControlUnit_tb_wave.ghw

gtkwave ControlUnit_tb_wave.ghw -o ControlUnit_tb_wave_config.gtkw
read  -n 1
