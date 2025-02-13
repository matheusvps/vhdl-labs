#!/bin/bash

ghdl -a MMU.vhd
ghdl -e MMU
ghdl -a MMU_tb.vhd
ghdl -e MMU_tb

ghdl -r MMU_tb --wave=MMU_tb_wave.ghw

gtkwave MMU_tb_wave.ghw -o MMU_tb_wave_config.gtkw
read  -n 1