library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ROM is
   port(
      clk      : in std_logic;
      endereco : in unsigned(7 downto 0);
      dado     : out std_logic_vector(13 downto 0)  -- 14 bits para cada dado
   );
end entity;
architecture a_ROM of ROM is
   type mem is array (0 to 127) of std_logic_vector(13 downto 0); -- 128 posições de 14 bits
   -- acc = Endereço F
   constant conteudo_rom : mem := (
      0  => B"0110_0011_000101",  -- LD R3, 5 (A)                              -- verificado
      1  => B"0110_0000_010000",  -- LD R4, 8 (B)                             -- verificado
      2  => B"0001_1111_0011_00",  -- ADD ACC, R3 (C)                         -- verificado
      3  => B"0001_1111_0100_00",  -- ADD ACC, R4 (C)                         -- verificado
      4  => B"0110_0010_000001",  -- LD R2, 1 (D)                            -- verificado
      5  => B"0011_1111_0010_00",  -- SUB ACC, R2 (D)                        -- verificado
      6  => B"1111_0010100_000",  -- JMP 20 (E)                              -- verificado
      7  => B"0110_0101_000000",   -- LD R5, 0 (F) [não executada]           -- verificado
      20 => B"1010_0011_1111_00",   -- MOV R3, ACC (G)                        -- verificado
      21 => B"1111_0000010_000",   -- JMP C (H) (salta para o endereço 2)     -- verificado
      22 => B"0110_0011_0000_00",   -- LD R3, 0 (I) [não executada]           -- verificado
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
