#!/bin/bash


ghdl -a ../StateMachine/StateMachine.vhd
ghdl -a ../ProgramCounter/ProgramCounter.vhd
ghdl -a ../ProgramCounter/ProgramCounter_Control.vhd
ghdl -a ../MemoryManagementUnit/MMU.vhd
ghdl -a ../ROM/ROM.vhd
ghdl -a ../RAM/RAM.vhd
ghdl -a ../ControlUnit/ControlUnit.vhd
ghdl -a ../RegisterBank/Register16Bits.vhd
ghdl -a ../RegisterBank/RegisterBank.vhd
ghdl -a ../Register1Bit/Register1bit.vhd
ghdl -a ../ULA/ULA.vhd
ghdl -a processador.vhd
ghdl -a processador_tb.vhd
ghdl -e StateMachine ProgramCounter ProgramCounter_Control MMU ROM RAM ControlUnit Register16Bits Register1bit RegisterBank ULA processador processador_tb

ghdl -r processador_tb --wave=processador_tb_wave.ghw

gtkwave processador_tb_wave.ghw -o processador_tb_wave_config_submit.gtkw
read  -n 1
