#!/bin/bash

ghdl -a StateMachine.vhd
ghdl -e StateMachine
ghdl -a StateMachine_tb.vhd
ghdl -e StateMachine_tb

ghdl -r StateMachine_tb --wave=stateMachine_tb_wave.ghw

gtkwave stateMachine_tb_wave.ghw -o stateMachine_tb_wave_config.gtkw
