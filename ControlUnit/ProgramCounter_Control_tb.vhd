library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter_Control_tb is
end entity;

architecture sim of ProgramCounter_Control_tb is
    component ProgramCounter_Control is
        port(
            clk         : in std_logic;
            wr_enable   : in std_logic;
            jump_enable : in std_logic;
            jump_in     : in unsigned(7 downto 0);
            data_out    : out unsigned(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal clk_period : time := 10 ns;
    signal finished : std_logic := '0';

    signal wr_enable : std_logic := '0';
    signal jump_enable : std_logic := '0';
    signal jump_in : unsigned(7 downto 0);
    signal data_out : unsigned(7 downto 0);

begin
    PC_Control: ProgramCounter_Control
        port map(
            clk         => clk,
            wr_enable   => wr_enable,
            jump_enable => jump_enable,
            jump_in     => jump_in,
            data_out    => data_out
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

    tb: process
    begin
        wait for 20 ns;

        jump_enable <= '0';
        wr_enable <= '1';
        wait for 100 ns;

        jump_enable <= '1';
        jump_in <= "01000000";
        wait for clk_period;
        
        wr_enable <= '0';
        jump_enable <= '0';
        wait for 50 ns;

        wr_enable <= '1';

        wait;
    end process tb;
    
end architecture;
