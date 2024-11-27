library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
      clk      : in std_logic;
      endereco : in unsigned(7 downto 0);
      dado     : out std_logic_vector(13 downto 0) -- 14 bits para cada dado
   );
end entity;

architecture a_ROM of ROM is
   type mem is array (0 to 127) of std_logic_vector(13 downto 0); -- 128 posições de 14 bits
   constant conteudo_rom : mem := (
      0  => "00000000000001",
      1  => "00000000000010",
      2  => "00000000000011",
      3  => "00000000000100",
      4  => "00000000000101",
      5  => "00000000000110",
      6  => "00000000000111",
      7  => "00000000001000",
      8  => "00000000001001",
      9  => "00000000001010",
      10 => "00000000001011",
      11 => "00000000001100",
      12 => "00000000001101",
      13 => "00000000001110",
      14 => "11110000001010",
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
