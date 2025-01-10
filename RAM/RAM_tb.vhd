library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity RAM_tb is
end entity;

architecture sim of RAM_tb is
    component RAM is
        port(
            clk      : in STD_LOGIC;
            endereco : in STD_LOGIC_VECTOR(6 downto 0);
            wr_en    : in STD_LOGIC;
            dado_in  : in STD_LOGIC_VECTOR(15 downto 0);
            dado_out : out STD_LOGIC_VECTOR(15 downto 0) 
        );
    end component;

    signal finished : STD_LOGIC := '0';
    signal clk      : STD_LOGIC := '0';
    signal wr_en_s  : STD_LOGIC := '0';
    signal endereco_s : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
    signal dado_in_s  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal dado_out_s : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');

    constant clk_period : time := 10 ns;
begin
    uut: RAM port map(
            clk      => clk,
            endereco => endereco_s,
            wr_en    => wr_en_s,
            dado_in  => dado_in_s,
            dado_out => dado_out_s
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
        -- Test 1: Escrever valor no endereço 0
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(0, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(12345, 16));
        wr_en_s <= '1';
        wait for clk_period;
        wr_en_s <= '0';
        wait for clk_period;


        -- Test 2: Escrever valor no endereço 1 e ler o valor do endereço 0
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(1, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(54321, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(0, 7));
        wr_en_s <= '0';
        wait for clk_period;

        -- Test 3: Escrever valores em endereços aleatórios
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(11, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(0, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(23, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(8, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(8, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(3, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(127, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(255, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(100, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(10, 16));
        wr_en_s <= '1';
        wait for clk_period;

        -- Test 4: Sobrescrever valores nos endereços 0, 1 e 127
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(0, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(0, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(1, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(1, 16));
        wr_en_s <= '1';
        wait for clk_period;
        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(127, 7));
        dado_in_s <= STD_LOGIC_VECTOR(to_unsigned(127, 16));
        wr_en_s <= '1';
        wait for clk_period;
        wr_en_s <= '0';
        wait for clk_period;

        endereco_s <= STD_LOGIC_VECTOR(to_unsigned(0, 7));
        wr_en_s <= '0';
        wait for clk_period;

        wait;
    end process tb;
end architecture;
