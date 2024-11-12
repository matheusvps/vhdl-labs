library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity RegisterBank_tb is
end entity;

architecture a_RegisterBank_tb of RegisterBank_tb is
    component RegisterBank
        Port (
            clock   : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            wr_en   : in  STD_LOGIC;
            data_wr : in  STD_LOGIC_VECTOR(15 downto 0);
            reg_wr  : in  STD_LOGIC_VECTOR(4 downto 0);
            reg_r   : in  STD_LOGIC_VECTOR(4 downto 0);
            data_r  : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    constant period_time : time      := 10 ns;
    signal clock   : STD_LOGIC := '0';
    signal rst     : STD_LOGIC := '0';
    signal wr_en   : STD_LOGIC := '0';
    signal finished: std_logic := '0';
    signal data_wr : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal reg_wr  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal reg_r   : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal data_r  : STD_LOGIC_VECTOR(15 downto 0);

begin
    uut : RegisterBank port map (
                                    clock   => clock,
                                    rst     => rst,
                                    wr_en   => wr_en,
                                    data_wr => data_wr,
                                    reg_wr  => reg_wr,
                                    reg_r   => reg_r,
                                    data_r  => data_r
                                 );

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clock <= '1';
            wait for period_time/2;
            clock <= '0';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    
    sim_time_proc: process
    begin
        wait for 1 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO
        finished <= '1';
        wait;
    end process sim_time_proc;

    tb : process
    begin
        wait for 20 ns;
        
        rst <= '1';
        wait for 20 ns;
        
        rst <= '0';
        wait for 15 ns;
        
        -- Escreve 4 no registrador 0
        data_wr <= "0000000000000100";
        reg_wr <= "00000";
        wr_en <= '1';
        wait for 25 ns;
        
        -- Lê o registrador 0
        wr_en <= '0';
        reg_r <= "00000";
        wait for 20 ns;
        
        -- Escreve 3 no registrador 1
        wr_en <= '1';
        data_wr <= "0000000000000011";
        reg_wr <= "00001";
        wait for 20 ns;
        
        -- Lê o registrador 1
        wr_en <= '0';
        reg_r <= "00001";
        wait for 20 ns;
        
        -- Escreve 5 no registrador 3
        wr_en <= '1';
        data_wr <= "0000000000000101";
        reg_wr <= "00011";
        wait for 20 ns;

        -- Lê o registrador 3
        wr_en <= '0';
        reg_r <= "00011";
        wait for 20 ns;
        
        wait;
    end process tb;
end architecture;