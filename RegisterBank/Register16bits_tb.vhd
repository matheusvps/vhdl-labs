    library IEEE;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity Register16Bits_tb is
    end entity;

    architecture a_Register16Bits_tb of Register16Bits_tb is
        component Register16Bits port(
            clock      : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in STD_LOGIC_VECTOR(15 downto 0);
            data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
        end component;
                                
    constant period_time : time      := 10 ns;
    signal   finished    : std_logic := '0';
    signal   clk         : std_logic := '0';
    signal   rst         : std_logic := '0';
    signal   wr_en       : std_logic := '0';
    signal   data_in     : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal   data_out    : STD_LOGIC_VECTOR(15 downto 0);
    begin
    uut: Register16Bits port map (    
                                        clock      => clk,
                                        rst      => rst,
                                        wr_en    => wr_en,
                                        data_in  => data_in,
                                        data_out => data_out
                                    );
    
    rst_global: process
    begin
        rst <= '1';
        wait for period_time*2; -- espera 2 clocks
        rst <= '0';
        wait;
    end process;
    
    sim_time_proc: process
    begin
        wait for 1 us;         -- <== TEMPO TOTAL DA SIMULAÇÃO
        finished <= '1';
        wait;
    end process sim_time_proc;

    clk_proc: process
    begin                       -- gera clock até que sim_time_proc termine
        while finished /= '1' loop
            clk <= '0';
            wait for period_time/2;
            clk <= '1';
            wait for period_time/2;
        end loop;
        wait;
    end process clk_proc;
    process                      -- sinais dos casos de Register16Bits (p.ex.)
    begin
        wait for 20 ns;

        wr_en <= '0';
        data_in <= "1111111111111111";
        wait for 10 ns;
        
        wr_en <= '1';
        data_in <= "1010010010100100";
        wait for 10 ns;
        
        wr_en <= '1';             -- Teste para verificar o que ocorre ao setar wr_en e rst ao mesmo tempo
        data_in <= "1110011111100111";
        wait for 10 ns;

        wr_en <= '0';
        data_in <= "1111111111111111";
        wait for 10 ns;

        wr_en <= '1';
        data_in <= "1010101010101010";
        wait for 10 ns;
        
        wait;
    end process;
    end architecture;
    -- ghdl -a Register16Bits.vhd   
    -- ghdl -e Register16Bits       
    -- ghdl -a Register16Bits_tb.vhd
    -- ghdl -e Register16Bits_tb    
    -- ghdl  -r  Register16Bits_tb  --wave=Register16Bits_tb.ghw 
    -- gtkwave Register16Bits_tb.ghw