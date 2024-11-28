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
      0  => B"0110_0011_0001_01",  -- LD R3, 5 (A)                         
      1  => B"0110_0000_0100_00",  -- LD R4, 8 (B)                         
      2  => B"0001_1111_0011_00",  -- ADD ACC, R3 (C)                      
      3  => B"0001_1111_0100_00",  -- ADD ACC, R4 (C)                      
      4  => B"0110_0010_0000_01",  -- LD R2, 1 (D)                         
      5  => B"0011_1111_0010_00",  -- SUB ACC, R2 (D)                      
      6  => B"1111_0010_1000_00",  -- JMP 20 (E)                           
      7  => B"0110_0101_0000_00",   -- LD R5, 0 (F) [não executada]        
      20 => B"1010_0011_1111_00",   -- MOV R3, ACC (G)                     
      21 => B"1111_0000_0100_00",   -- JMP C (H) (salta para o endereço 2) 
      22 => B"0110_0011_0000_00",   -- LD R3, 0 (I) [não executada]        
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
