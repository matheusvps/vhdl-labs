library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity TopLevel_tb is
end entity;

architecture sim of TopLevel_tb is
    component ControlUnit is
        port(
            clk         : in std_logic;                    -- Clock
            instruction : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
            jump_enable : out std_logic;                   -- Sinal para habilitar o Jump
            jump_address: out unsigned(7 downto 0)         -- Endereço absoluto para Jump
        );
    end component;

    component ROM is
        port(
            clk: in std_logic;
            endereco : in unsigned(7 downto 0);
            dado     : out std_logic_vector(13 downto 0) -- 14 bits para cada dado
        );
    end component;

    component ProgramCounter_Control is
        port(
            clk         : in std_logic;
            wr_enable   : in std_logic;
            jump_enable : in std_logic;
            jump_in     : in unsigned(7 downto 0);
            data_out    : out unsigned(7 downto 0)
        );
    end component;

    signal clk : std_logic := '0';
    signal finished : std_logic := '0';
    signal clk_period : time := 10 ns;

    signal wr_enable : std_logic := '0';
    signal jump_enable_s : std_logic;
    signal jump_address_s : unsigned(7 downto 0);
    signal data_out_pc : unsigned(7 downto 0);
    signal data_out_rom : std_logic_vector(13 downto 0);

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
                jump_enable => jump_enable_s,
                jump_in => jump_address_s,
                data_out => data_out_pc
            );

        CU: ControlUnit
            port map(
                clk => clk,
                instruction => data_out_rom,
                jump_enable => jump_enable_s,
                jump_address => jump_address_s
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
        end process;
end architecture;
