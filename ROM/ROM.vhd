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
      1 => B"0110_0001_000010",  -- LD R1, 2   # Number and address (2 on 2, 3 on 3, etc.)
      2 => B"0110_0011_000001",  -- LD R3, 1   # Constant
      3 => B"1011_0001_000100",  -- SW R1, (R1)  # Salva o R1 no endereÃ§o de memÃ³ria R2
      4 => B"1010_1111_000100",  -- MOV ACC, R1
      5 => B"0001_0011_000000",  -- ADD ACC, R3
      6 => B"1010_0001_111100",  -- MOV R1, ACC # Incrementa o nÃºmero/endereÃ§o de memÃ³ria
      7 => B"1010_1111_000100",  -- MOV ACC, R1
      8 => B"0101_0000_000000",  -- CMP R0
      9 => B"1101_011_1111010",  -- BLT loop1 # Se R1 < R0, volta para loop1
     10 => B"0110_0001_000010",  -- LD R1, 2   # Number and address (2 on 2, 3 on 3, etc.)
     11 => B"0110_0010_000010",  -- LD R2, 2   # Prime number
     12 => B"0110_0011_000001",  -- LD R3, 1   # Constant
     13 => B"1010_1111_000100",  -- MOV ACC, R1
     14 => B"0001_0010_000000",  -- ADD ACC, R2
     15 => B"1010_0001_111100",  -- MOV R1, ACC  # Determina o nÃºmero a ser removido
     16 => B"1010_1111_001100",  -- MOV ACC, R3
     17 => B"1011_0001_001100",  -- SW R3, (R1)  # Remove o nÃºmero (1 nÃ£o Ã© primo, logo usamos como flag)
     18 => B"1010_1111_000100",  -- MOV ACC, R1
     19 => B"0101_0000_000000",  -- CMP R0
     20 => B"1101_011_1111001",  -- BLT loop2 # Se R1 < R0, volta para loop2
     21 => B"1010_1111_001000",  -- MOV ACC, R2
     22 => B"1010_0111_111100",  -- MOV R7, ACC # "Cospe" os nÃºmeros primos em R7
     23 => B"1010_1111_001000",  -- MOV ACC, R2
     24 => B"0001_0011_000000",  -- ADD ACC, R3
     25 => B"1010_0010_111100",  -- MOV R2, ACC  # Incrementa o endereÃ§o de memÃ³ria
     26 => B"1010_1111_001000",  -- MOV ACC, R2
     27 => B"1010_0001_111100",  -- MOV R1, ACC   # Reseta o nÃºmero
     28 => B"0111_0010_000000",  -- LW ACC, (R2)  # Carrega o nÃºmero da memÃ³ria em ACC
     29 => B"0101_0011_000000",  -- CMP R3
     30 => B"1101_001_1101111",  -- BNE loop2  # Se R1 != R3, volta para loop2
     31 => B"1010_1111_001000",  -- MOV ACC, R2
     32 => B"0101_0000_000000",  -- CMP R0
     33 => B"1101_011_1110110",  -- BLT loop3 # Se R2 < R0, volta para loop3
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
