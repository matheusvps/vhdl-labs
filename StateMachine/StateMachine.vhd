library ieee;
use ieee.std_logic_1164.all;

entity StateMachine is
   port(
      clk   : in std_logic;  -- Clock
      reset : in std_logic;  -- Reset síncrono
      estado_o : out std_logic -- Saída representando o estado atual
   );
end entity;

architecture behavior of StateMachine is
   signal estado_s : std_logic := '0'; -- Estado interno (0: Fetch, 1: Decode/Execute)
begin
   process(clk)
   begin
      if rising_edge(clk) then
         if reset = '1' then
            estado_s <= '0'; -- Reset: volta para o estado Fetch
         else
            estado_s <= not estado_s; -- Flip-flop T: alterna entre Fetch e Decode/Execute
         end if;
      end if;
   end process;

   estado_o <= estado_s; -- Saída do estado atual
end architecture;
