#!/bin/bash

ghdl -a ROM.vhd
ghdl -e ROM
ghdl -a ROM_tb.vhd
ghdl -e ROM_tb

ghdl -r ROM_tb --wave=rom_tb_wave.ghw

gtkwave rom_tb_wave.ghw -o rom_tb_wave_config.gtkw
