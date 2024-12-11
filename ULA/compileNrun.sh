#!/bin/bash

ghdl -a ULA.vhd
ghdl -e ULA
ghdl -a ULA_tb.vhd
ghdl -e ULA_tb

ghdl -r ULA_tb --wave=ula_tb_wave.ghw

gtkwave ula_tb_wave.ghw -o ula_tb_wave_config.gtkw
