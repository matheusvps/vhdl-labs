#!/bin/bash

ghdl -a ../RegisterBank/Register16Bits.vhd
ghdl -e Register16Bits

ghdl -a ../RegisterBank/RegisterBank.vhd
ghdl -e RegisterBank

ghdl -a ../ULA/ULA.vhd
ghdl -e ULA

ghdl -a Connection.vhd
ghdl -e Connection


ghdl -a Connection_tb.vhd
ghdl -e Connection_tb


ghdl -r Connection_tb --wave=Connection_tb_wave.ghw

gtkwave Connection_tb_wave.ghw -o registerbank_ula_config.gtkw