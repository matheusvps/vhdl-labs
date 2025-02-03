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
      0 => B"0110_0000_111111",  -- LD R0, 63  # Max number to check for
      1 => B"0110_0001_000001",  -- LD R1, 1   # Number and address (1 on 1, 2 on 2, etc.)
      2 => B"0110_0011_000001",  -- LD R3, 1   # Constant
      3 => B"1011_0001_000100",  -- SW R1, (R1)  # Salva o R1 no endereÃ§o de memÃ³ria R2
      4 => B"1010_1111_000100",  -- MOV ACC, R1
      5 => B"0001_0011_000000",  -- ADD ACC, R3
      6 => B"1010_0001_111100",  -- MOV R1, ACC # Incrementa o nÃºmero/endereÃ§o de memÃ³ria
      7 => B"1010_1111_000100",  -- MOV ACC, R1
      8 => B"0101_0000_000000",  -- CMP R0
      9 => B"1101_011_1111010",  -- BLT loop1 # Se R1 < R0, volta para loop1
     10 => B"0110_0000_010111",  -- LD R0, 23  
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
