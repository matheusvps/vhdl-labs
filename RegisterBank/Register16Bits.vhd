library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register16bits is
   port( clock      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in STD_LOGIC_VECTOR(15 downto 0);
         data_out : out STD_LOGIC_VECTOR(15 downto 0)
   );
end entity;

architecture a_Register16bits of Register16bits is
begin
   process(clock, rst, wr_en) 
   begin                
      if rst='1' then
         data_out <= (others => '0');
      elsif wr_en='1' then
         if rising_edge(clock) then
            data_out <= data_in;
         end if;
      end if;
   end process;
   
end architecture;