library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity Connection_ROM_PC_tb is
end entity;

architecture sim of Connection_ROM_PC_tb is
    component ROM is
        port(
            clk: in std_logic;
            endereco : in unsigned(7 downto 0);
            dado     : out unsigned(13 downto 0) -- 14 bits para cada dado
        );
    end component;

    component ProgramCounter_Control is
        port(
            clk       : in std_logic;
            wr_enable : in std_logic;
            data_out  : out unsigned(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal finished : std_logic := '0';
    signal wr_enable : std_logic := '0';
    signal data_out_pc : unsigned(7 downto 0);
    signal data_out_rom : unsigned(13 downto 0);
    signal clk_period : time := 10 ns;

begin
    ROM_mem: ROM
        port map(
            clk => clk,
            endereco => data_out_pc,
            dado => data_out_rom
        );
    
    PC_Control: ProgramCounter_Control
        port map(
            clk => clk,
            wr_enable => wr_enable,
            data_out => data_out_pc
        );
    
    clk_proc: process
    begin
        while finished /= '1' loop
            clk <= '0';
            wait for clk_period / 2;
            clk <= '1';
            wait for clk_period / 2;
        end loop;
        wait;
    end process clk_proc;

    sim_time_proc: process
    begin
        wait for 1 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    tb: process
    begin
        wait for 20 ns;
        
        wr_enable <= '1';
        
        wait;
    end process tb;
    
end architecture;
