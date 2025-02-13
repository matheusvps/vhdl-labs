library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity MMU_tb is
end entity;

architecture sim of MMU_tb is
    component MMU is
        port(
            endereco_in  : in STD_LOGIC_VECTOR(15 downto 0);
            endereco_out : out STD_LOGIC_VECTOR(15 downto 0);
            exception    : out STD_LOGIC
        );
    end component;

    signal clk    : std_logic := '0';              
    signal endereco_in  : std_logic_vector(15 downto 0) := (others => '0');
    signal endereco_out : std_logic_vector(15 downto 0) := (others => '0');
    signal exception    : std_logic := '0';
    signal finished     : std_logic := '0';          

    constant clk_period : time := 10 ns;           
begin
    -- Instância da máquina de estados
    uut: MMU
        port map(
            endereco_in  => endereco_in,
            endereco_out => endereco_out,
            exception    => exception
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

    process
    begin
        endereco_in <= "0000000000000000";
        wait for 10 ns;

        endereco_in <= "0000000000000100";
        wait for 10 ns;

        endereco_in <= "0000000001111111";
        wait for 10 ns;

        endereco_in <= "0000000010000000";
        wait for 10 ns;

        endereco_in <= "0010100010000000";
        wait for 10 ns;

        endereco_in <= "0000000000000111";
        wait for 10 ns;

        wait;
    end process;
end architecture;
