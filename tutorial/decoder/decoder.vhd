library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity decoder is
    Port (
        A : in STD_LOGIC;
        B : in STD_LOGIC;
        Y : out STD_LOGIC_VECTOR (3 downto 0)
    );
end decoder;

architecture Behavioral of decoder is
begin
    process (A, B)
        variable sel : STD_LOGIC_VECTOR(1 downto 0);
    begin
        sel := A & B;
        case sel is
            when "00" =>
                Y <= "0001";
            when "01" =>
                Y <= "0010";
            when "10" =>
                Y <= "0100";
            when "11" =>
                Y <= "1000";
            when others =>
                Y <= "0000";
        end case;
    end process;
end Behavioral;
