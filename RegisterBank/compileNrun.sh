#!/bin/bash

ghdl -a Register16Bits.vhd
ghdl -e Register16Bits
ghdl -a Register16Bits_tb.vhd
ghdl -e Register16Bits_tb
ghdl -a RegisterBank.vhd
ghdl -e RegisterBank_tb

ghdl -r RegisterBank_tb --wave=RegisterBank_tb_wave.ghw

gtkwave RegisterBank_tb_wave.ghw
