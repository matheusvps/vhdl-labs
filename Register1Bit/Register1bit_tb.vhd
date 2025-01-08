    library IEEE;
    use ieee.std_logic_1164.all;
    use ieee.numeric_std.all;

    entity Register1bit_tb is
    end entity;

    architecture a_Register1bit_tb of Register1bit_tb is
        component Register1bit port(
            clock    : in STD_LOGIC;
            rst      : in STD_LOGIC;
            wr_en    : in STD_LOGIC;
            data_in  : in STD_LOGIC;
            data_out : out STD_LOGIC
        );
        end component;
                                
    constant period_time : time      := 10 ns;
    signal   finished    : STD_LOGIC := '0';
    signal   clk         : STD_LOGIC := '0';
    signal   rst         : STD_LOGIC := '0';
    signal   wr_en       : STD_LOGIC := '0';
    signal   data_in     : STD_LOGIC := '0';
    signal   data_out    : STD_LOGIC := '0';
    
    begin
    uut: Register1bit port map (    
                                        clock    => clk,
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
    process                      -- sinais dos casos de teste
    begin
        wait for 20 ns;

        wr_en <= '0';
        data_in <= '1';
        wait for 10 ns;
        
        wr_en <= '1';
        data_in <= '1';
        wait for 10 ns;
        
        wr_en <= '1';             -- Teste para verificar o que ocorre ao setar wr_en e rst ao mesmo tempo
        data_in <= '0';
        wait for 10 ns;

        wr_en <= '0';
        data_in <= '1';
        wait for 10 ns;

        wr_en <= '1';
        data_in <= '0';
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