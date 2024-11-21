library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ROM_tb is
end entity;

architecture sim of ROM_tb is
    component rom is
        port(
            clk      : in std_logic;
            endereco : in unsigned(7 downto 0);
            dado     : out unsigned(13 downto 0)
        );
    end component;

    signal finished : std_logic := '0';
    signal clk      : std_logic := '0';
    signal endereco : unsigned(7 downto 0) := (others => '0');
    signal dado     : unsigned(13 downto 0);

    constant clk_period : time := 10 ns;
begin
    uut: rom
        port map(
            clk      => clk,
            endereco => endereco,
            dado     => dado
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
        -- Testa os primeiros endereços
        for i in 0 to 20 loop
            endereco <= to_unsigned(i, 8);
            wait for clk_period;
        end loop;

        -- Testa o último endereço
        endereco <= to_unsigned(127, 8);
        wait for clk_period;
        wait;
    end process tb;
end architecture;
