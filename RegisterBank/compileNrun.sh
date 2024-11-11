#!/bin/bash

ghdl -a *.vhd
ghdl -e *.vhd

ghdl -r RegisterBank_tb --wave=RegisterBank_tb_wave.ghw

gtkwave RegisterBank_tb_wave.ghw
