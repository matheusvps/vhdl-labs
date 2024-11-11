library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register16bits is
   port( clock      : in std_logic;
         rst      : in std_logic;
         wr_en    : in std_logic;
         data_in  : in std_logic_vector(15 downto 0);
         data_out : out std_logic_vector(15 downto 0)
   );
end entity;

architecture a_Register16bits of Register16bits is
   signal registro: std_logic_vector(15 downto 0);
begin
   process(clock,rst) 
   begin                
      if rst='1' then
         registro <= (others => '0');
      elsif rising_edge(clock) then
         if wr_en='1' then
            registro <= data_in;
         end if;
      end if;
   end process;
   
   data_out <= registro;
end architecture;