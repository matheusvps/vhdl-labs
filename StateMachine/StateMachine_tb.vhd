library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine_tb is
end entity;

architecture sim of StateMachine_tb is
    component StateMachine is
        port(
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0)
        );
    end component;

    signal clk    : std_logic := '0';              
    signal rst    : std_logic := '0';              
    signal estado : unsigned(1 downto 0);          
    signal finished : std_logic := '0';            

    constant clk_period : time := 10 ns;           
begin
    -- Instância da máquina de estados
    uut: StateMachine
        port map(
            clk    => clk,
            rst    => rst,
            estado => estado
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
        wait for 1 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    process
    begin
        rst <= '1';
        wait for 25 ns;
        rst <= '0';

        wait for 100 ns;

        rst <= '1';
        wait for 25 ns;
        rst <= '0';
        wait;
    end process;
end architecture;
