library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RAM is
   port( 
         clk      : in STD_LOGIC;
         endereco : in STD_LOGIC_VECTOR(6 downto 0);
         wr_en    : in STD_LOGIC;
         dado_in  : in STD_LOGIC_VECTOR(15 downto 0);
         dado_out : out STD_LOGIC_VECTOR(15 downto 0) 
   );
end entity;

architecture a_RAM of RAM is
   type mem is array (0 to 127) of STD_LOGIC_VECTOR(15 downto 0);
   signal conteudo_ram : mem;
begin
   process(clk,wr_en)
   begin
      if rising_edge(clk) then
         if wr_en='1' then
            conteudo_ram(to_integer(unsigned(endereco))) <= dado_in;
         end if;
      end if;
   end process;
   dado_out <= conteudo_ram(to_integer(unsigned(endereco)));
end architecture;