-- refs: https://balbertini.github.io/vhdl_testbench-pt_BR.html

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder_tb is
end decoder_tb;

architecture Behavioral of decoder_tb is
    signal A : STD_LOGIC;
    signal B : STD_LOGIC;
    signal Y : STD_LOGIC_VECTOR (3 downto 0);
    
begin
    uut: entity work.decoder
        port map (
            A => A,
            B => B,
            Y => Y
        );

    stimulus: process
    begin
        A <= '0'; B <= '0';
        wait for 10 ns;
        assert (Y = "0001") report "Erro: A=0, B=0, esperado Y=0001" severity error;

        A <= '0'; B <= '1';
        wait for 10 ns;
        assert (Y = "0010") report "Erro: A=0, B=1, esperado Y=0010" severity error;

        A <= '1'; B <= '0';
        wait for 10 ns;
        assert (Y = "0100") report "Erro: A=1, B=0, esperado Y=0100" severity error;

        A <= '1'; B <= '1';
        wait for 10 ns;
        assert (Y = "1000") report "Erro: A=1, B=1, esperado Y=1000" severity error;

        wait;
    end process;
end Behavioral;
