library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity StateMachine is
   port(
      clk    : in std_logic;
      rst    : in std_logic;
      estado : out unsigned(1 downto 0)  -- Estado atual
   );
end entity;

-- Estados:
--    00: Fetch
--    01: Decode
--    10: Execute

architecture a_StateMachine of StateMachine is
   signal estado_s : unsigned(1 downto 0); -- Estado interno
begin
   process(clk, rst)
   begin
      if rst = '1' then
         estado_s <= "00";               -- Reset: volta ao estado 0
      elsif rising_edge(clk) then
         if estado_s = "10" then         -- Se no estado 2
            estado_s <= "00";            -- Próximo estado é 0
         else
            estado_s <= estado_s + 1;    -- Avança para o próximo estado
         end if;
      end if;
   end process;

   estado <= estado_s; -- Saída do estado atual
end architecture;
