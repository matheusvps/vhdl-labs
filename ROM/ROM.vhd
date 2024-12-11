library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
      clk      : in std_logic;
      endereco : in unsigned(6 downto 0);
      dado     : out std_logic_vector(13 downto 0)  -- 14 bits para cada dado
   );
end entity;
architecture a_ROM of ROM is
   type mem is array (0 to 127) of std_logic_vector(13 downto 0); -- 128 posições de 14 bits
   -- acc = Endereço F
   constant conteudo_rom : mem := (
      0 => B"0110_0000_000001",  -- LD R0, 1        # Constantes
      1 => B"0110_0010_011110",  -- LD R2, 30
      2 => B"0110_0011_000000",  -- LD R3, 0        # A
      3 => B"0110_0100_000000",  -- LD R4, 0        # B
      4 => B"1100_0000_000000",  -- ZAC             # C
      5 => B"0001_0011_000000",  -- ADD ACC, R3
      6 => B"0001_0100_000000",  -- ADD ACC, R4
      7 => B"1010_0100_111100",  -- MOV R4, ACC
      8 => B"1100_0000_000000",  -- ZAC             # D
      9 => B"0001_0011_000000",  -- ADD ACC, R3
     10 => B"0001_0000_000000",  -- ADD ACC, R0
     11 => B"1010_0011_111100",  -- MOV R3, ACC
     12 => B"0101_0010_000000",  -- CMP R2          # E
     13 => B"1101_011_1110111",  -- BLT loop
     14 => B"1010_1111_010000",  -- MOV ACC, R4     # F
     15 => B"1010_0101_111100",  -- MOV R5, ACC
      others => (others => '0')
   );
begin
   process(clk)
   begin
      if rising_edge(clk) then
         dado <= conteudo_rom(to_integer(endereco)); -- Leitura síncrona
      end if;
   end process;
end architecture;
