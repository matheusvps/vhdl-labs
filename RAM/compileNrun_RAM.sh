#!/bin/bash

ghdl -a RAM.vhd
ghdl -e RAM
ghdl -a RAM_tb.vhd
ghdl -e RAM_tb

ghdl -r RAM_tb --wave=ram_tb_wave.ghw

gtkwave ram_tb_wave.ghw -o ram_tb_wave_config.gtkw
