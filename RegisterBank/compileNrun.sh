#!/bin/bash

ghdl -a Register16Bits.vhd
ghdl -e Register16Bits
ghdl -a Register16Bits_tb.vhd
ghdl -e Register16Bits_tb

ghdl -r Register16Bits_tb --wave=Register16Bits_tb_wave.ghw

gtkwave Register16Bits_tb_wave.ghw
