library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit_tb is
end entity;

architecture sim of ControlUnit_tb is
    component ControlUnit is
        port(
            clk         : in std_logic;                    -- Clock
            instruction : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
            jump_enable : out std_logic;                   -- Sinal para habilitar o Jump
            jump_address: out unsigned(7 downto 0)         -- Endereço absoluto para Jump
        );
    end component;

    signal instruction : std_logic_vector(13 downto 0) := (others => '0');
    signal jump_enable : std_logic;
    signal jump_address: unsigned(7 downto 0);
    signal clk : std_logic := '0';
    signal clk_period : time := 10 ns;
    signal finished : std_logic := '0';

begin
    
    UUT: ControlUnit port map(
        clk => clk,
        instruction => instruction,
        jump_enable => jump_enable,
        jump_address => jump_address
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
        instruction <= "00000000000001";
        wait for 10 ns;
        instruction <= "00000000000010";
        wait for 10 ns;
        instruction <= "00000000000011";
        wait for 10 ns;
        instruction <= "00000000000100";
        wait for 10 ns;
        instruction <= "00000000000101";
        wait for 10 ns;
        instruction <= "00000000000110";
        wait for 10 ns;
        instruction <= "11110000000111";
        wait for 10 ns;
        instruction <= "00000000001000";
        wait for 10 ns;
        instruction <= "00000000001001";
        wait for 10 ns;
        instruction <= "00000000001010";
        wait for 10 ns;
        instruction <= "00000000001011";
        wait for 10 ns;
        instruction <= "00000000001100";
        wait for 10 ns;
        instruction <= "00000000001101";
        wait for 10 ns;
        instruction <= "00000000001110";
        wait for 10 ns;
        instruction <= "11110000001110";
        wait for 10 ns;
        wait;
    end process;
end architecture;
