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
      0 => B"0110_0000_010111",  -- LD R0, 23
      1 => B"0110_0001_001000",  -- LD R1, 8
      2 => B"1100_0000_000000",  -- ZAC
      3 => B"0001_0000_000000",  -- ADD ACC, R0
      4 => B"1011_0001_000000",  -- SW R0, (R1)
      5 => B"1100_0000_000000",  -- ZAC
      6 => B"0111_0001_000000",  -- LW ACC, (R1)
      7 => B"1010_0010_111100",  -- MOV R2, ACC
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
