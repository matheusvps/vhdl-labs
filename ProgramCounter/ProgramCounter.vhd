library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter is
    port(
        clk       : in std_logic;             
        wr_enable : in std_logic;              
        data_in   : in unsigned(6 downto 0);   
        data_out  : out unsigned(6 downto 0)  
    );
end entity;

architecture behavior of ProgramCounter is
    signal reg : unsigned(6 downto 0) := (others => '0'); 
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if wr_enable = '1' then
                reg <= data_in; 
            end if;
        end if;
    end process;

    data_out <= reg;
end architecture;
