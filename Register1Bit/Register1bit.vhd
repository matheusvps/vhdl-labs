library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register1bit is
   port(
      clock    : in STD_LOGIC;
      rst      : in STD_LOGIC;
      wr_en    : in STD_LOGIC;
      data_in  : in STD_LOGIC;
      data_out : out STD_LOGIC
   );
end entity;

architecture a_Register1bit of Register1bit is
   signal registr: std_logic := '0';
begin
   process(clock, rst, wr_en) 
   begin                
      if rst='1' then
         registr <= '0';
      elsif wr_en='1' then
         if rising_edge(clock) then
            registr <= data_in;
         end if;
      end if;
   end process;
   data_out <= registr;
end architecture;