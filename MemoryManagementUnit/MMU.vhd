library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMU is
   port(
      ram_read_en  : in STD_LOGIC;
      ram_write_en : in STD_LOGIC;
      endereco_in  : in STD_LOGIC_VECTOR(15 downto 0);
      endereco_out : out STD_LOGIC_VECTOR(15 downto 0);
      exception    : out STD_LOGIC
   );
end entity;

architecture a_MMU of MMU is

begin
   endereco_out <= endereco_in when (to_integer(unsigned(endereco_in)) <= 127) 
                  else "0000000000000000";
   -- exception <= '0' when (ram_read_en = '1' or ram_write_en = '1' and to_integer(unsigned(endereco_in)) >= 0 and to_integer(unsigned(endereco_in)) <= 127)
   --             else '1';
   exception <= '1' when ((ram_read_en = '1' or ram_write_en = '1') and to_integer(unsigned(endereco_in)) > 127)
               else '0';
end architecture;
