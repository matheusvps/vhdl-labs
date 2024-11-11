#!/bin/bash

 ghdl -a ../RegisterBank/Register16Bits.vhd

 ghdl -a ../RegisterBank/RegisterBank.vhd

 ghdl -a ../ULA/ULA.vhd

 ghdl -a Connection.vhd

 ghdl -e Connection

 ghdl -a Connection_tb.vhd

 ghdl -e Connection_tb

 ghdl -r Connection_tb --wave=Connection_tb_wave.ghw

 gtkwave Connection_tb.ghw