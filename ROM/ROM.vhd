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
      0 => B"0110_0000_111100",  -- LD R0, 60
      1 => B"0110_0001_000010",  -- LD R1, 2
      2 => B"0110_0010_010100",  -- LD R2, 20
      3 => B"1010_1111_000000",  -- MOV ACC, R0  # Seta 120 para R0
      4 => B"0001_0000_000000",  -- ADD ACC, R0
      5 => B"1010_0000_111100",  -- MOV R0, ACC
      6 => B"1010_1111_000000",  -- MOV ACC, R0
      7 => B"1011_0001_000000",  -- SW R1  # Salva o valor do Acumulador no endereÃ§o de memÃ³ria de R1
      8 => B"1010_1111_001000",  -- MOV ACC, R2  # Atualiza o Ã­ndice
      9 => B"0011_0001_000000",  -- SUB ACC, R1
     10 => B"1010_0010_111100",  -- MOV R2, ACC
     11 => B"1010_1111_000000",  -- MOV ACC, R0  # Incrementa o nÃºmero
     12 => B"0001_0001_000000",  -- ADD ACC, R1
     13 => B"1010_0000_111100",  -- MOV R0, ACC
     14 => B"1010_1111_001000",  -- MOV ACC, R2
     15 => B"0101_0001_000000",  -- CMP R1
     16 => B"1101_010_1110110",  -- BGT loop1
     17 => B"0111_0000_000000",  -- LW R0  # Carrega o valor no endereco de memoria de R0 no Acumulador
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
