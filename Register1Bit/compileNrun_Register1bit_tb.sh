#!/bin/bash

ghdl -a *.vhd

ghdl -e Register1bit
ghdl -e Register1bit_tb

ghdl -r Register1bit_tb --wave=Register1bit_tb_wave.ghw

gtkwave Register1bit_tb_wave.ghw
