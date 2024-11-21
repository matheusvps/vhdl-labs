library IEEE;
use IEEE.std_logic_1164.all;

entity StateMachine_tb is
end entity;

architecture sim of StateMachine_tb is
    -- Instância da máquina de estados
    component StateMachine is
        port(
            clk      : in std_logic;
            reset    : in std_logic;
            estado_o : out std_logic
        );
    end component;

    signal clk      : std_logic := '0';
    signal reset    : std_logic := '0';
    signal estado_o : std_logic;
    signal finished : std_logic := '0';

    constant clk_period : time := 10 ns;
begin
    -- Instância da máquina de estados
    uut: StateMachine
        port map(
            clk      => clk,
            reset    => reset,
            estado_o => estado_o
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
        -- Reseta a máquina de estados
        reset <= '1';
        wait for 25 ns;
        reset <= '0';
        
        wait for 100 ns;
        reset <= '1';
        wait for 25 ns;
        reset <= '0';

        -- Finaliza a simulação
        wait;
    end process;
end architecture;
