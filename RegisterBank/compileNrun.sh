#!/bin/bash

ghdl -a *.vhd

ghdl -e Register16Bits
ghdl -e Register16Bits_tb
ghdl -e RegisterBank
ghdl -e RegisterBank_tb

ghdl -r Register16Bits_tb --wave=Register16Bits_tb_wave.ghw
ghdl -r RegisterBank_tb --wave=RegisterBank_tb_wave.ghw

gtkwave RegisterBank_tb_wave.ghw
