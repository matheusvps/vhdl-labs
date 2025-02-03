library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador_tb is
end entity;
  
  architecture a_processador_tb of processador_tb is
    component processador is
        port (
            clk : in std_logic;
            rst : in std_logic
        );
    end component;

    signal clk, rst : std_logic := '0';

    -- Simulation parameters
    constant clk_period : time := 10 ns;
    signal finished  : std_logic := '0';
    
begin
    uut: processador port map (
        clk => clk,
        rst => rst
    );

    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process clk_proc;

    sim_time_proc: process
    begin
        wait for 50 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    tb: process
    begin
        rst <= '1';
        wait for clk_period;
        rst <= '0';
        wait for clk_period;

        wait;
    end process tb;
end architecture;


