library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter_Control is
    port(
        clk         : in std_logic;
        wr_enable   : in std_logic;
        jump_enable : in std_logic;
        jump_in     : in unsigned(7 downto 0);
        data_out    : out unsigned(7 downto 0)
    );
end entity;

architecture behavior of ProgramCounter_Control is
    component ProgramCounter is
        port(
            clk       : in std_logic;
            wr_enable : in std_logic;
            data_in   : in unsigned(7 downto 0);
            data_out  : out unsigned(7 downto 0)
        );
    end component;

    signal pc_plus_1  : unsigned(7 downto 0) := (others => '0');
    signal data_out_s : unsigned(7 downto 0);
    signal data_in_pc : unsigned(7 downto 0);
begin
    PC: ProgramCounter 
        port map(
            clk => clk, 
            wr_enable => wr_enable, 
            data_in => data_in_pc, 
            data_out => data_out_s
        );

    data_in_pc <= jump_in when jump_enable = '1' 
                          else pc_plus_1; 

    pc_plus_1 <= data_out_s + 1;
    data_out <= data_out_s;
end architecture;
