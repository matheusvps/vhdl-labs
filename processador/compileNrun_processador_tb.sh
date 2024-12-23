#!/bin/bash


ghdl -a ../StateMachine/StateMachine.vhd
ghdl -a ../ProgramCounter/ProgramCounter.vhd
ghdl -a ../ProgramCounter/ProgramCounter_Control.vhd
ghdl -a ../ROM/ROM.vhd
ghdl -a ../ControlUnit/ControlUnit.vhd
ghdl -a ../RegisterBank/Register16Bits.vhd
ghdl -a ../RegisterBank/RegisterBank.vhd
ghdl -a ../ULA/ULA.vhd
ghdl -a processador.vhd
ghdl -a processador_tb.vhd
ghdl -e StateMachine ProgramCounter ProgramCounter_Control ROM ControlUnit Register16Bits RegisterBank ULA processador processador_tb

ghdl -r processador_tb --wave=processador_tb_wave.ghw

gtkwave processador_tb_wave.ghw -o processador_tb_wave_config.gtkw
read  -n 1
