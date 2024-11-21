library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter_tb is
end entity;

architecture sim of ProgramCounter_tb is
    component ProgramCounter is
        port(
            clk       : in std_logic;
            wr_enable : in std_logic;
            data_in   : in unsigned(7 downto 0);
            data_out  : out unsigned(7 downto 0)
        );
    end component;

    signal clk       : std_logic := '0';
    signal finished  : std_logic := '0';
    signal wr_enable : std_logic := '0';
    signal data_in   : unsigned(7 downto 0) := (others => '0');
    signal data_out  : unsigned(7 downto 0);

    constant clk_period : time := 10 ns;

begin
    uut: ProgramCounter
        port map(
            clk       => clk,
            wr_enable => wr_enable,
            data_in   => data_in,
            data_out  => data_out
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

        wr_enable <= '1';
        data_in <= "00000001";
        wait for clk_period;

        wr_enable <= '0';
        data_in <= "00000101";
        wait for clk_period;

        wr_enable <= '1';
        data_in <= "00000111";
        wait for clk_period;

        data_in <= "00000101";
        wait for clk_period;

        wr_enable <= '0';
        data_in <= "00000101";

        wait;
    end process tb;
end architecture;
