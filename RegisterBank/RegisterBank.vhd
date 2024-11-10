library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- 
-- Numero de registradores: 9
-- 

entity RegisterBank is
    Port (
        clock   : in  STD_LOGIC;
        rst     : in  STD_LOGIC; -- Reseta todos os registradores
        wr_en   : in  STD_LOGIC; 
        data_wr : in  STD_LOGIC_VECTOR(15 downto 0); -- Dado a ser escrito
        reg_wr  : in  STD_LOGIC_VECTOR(4 downto 0);  -- Seleção do registrador para escrita
        reg_r   : in  STD_LOGIC_VECTOR(4 downto 0);  -- Seleção do registrador para leitura
        data_r  : out STD_LOGIC_VECTOR(15 downto 0); -- Dado lido do registrador selecionado
    );
end RegisterBank;

architecture a_RegisterBank of RegisterBank is
    component Register
        Port (
            clock    : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            wr_en    : in  STD_LOGIC;
            data_in  : in  STD_LOGIC_VECTOR(31 downto 0);
            data_out : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    -- Sinais de controle e dados dos registradores
    signal registers_data   : array (8 downto 0) of STD_LOGIC_VECTOR(15 downto 0);
    signal write_en_signals : array (8 downto 0) of STD_LOGIC := (others => '0');
    
begin
    -- Instanciando os registradores
    reg_0 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(0),
                                    data_in => data_wr,
                                    data_out => registers_data(0)
                                 );
    reg_1 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(1),
                                    data_in => data_wr,
                                    data_out => registers_data(1)
                                 );
    reg_2 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(2),
                                    data_in => data_wr,
                                    data_out => registers_data(2)
                                 );
    reg_3 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(3),
                                    data_in => data_wr,
                                    data_out => registers_data(3)
                                 );
    reg_4 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(4),
                                    data_in => data_wr,
                                    data_out => registers_data(4)
                                 );
    reg_5 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(5),
                                    data_in => data_wr,
                                    data_out => registers_data(5)
                                 );
    reg_6 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(6),
                                    data_in => data_wr,
                                    data_out => registers_data(6)
                                 );
    reg_7 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(7),
                                    data_in => data_wr,
                                    data_out => registers_data(7)
                                 );
    reg_8 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(8),
                                    data_in => data_wr,
                                    data_out => registers_data(8)
                                 );
    reg_9 : Register port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_signals(9),
                                    data_in => data_wr,
                                    data_out => registers_data(9)
                                 );

    -- Process para definir o registrador de escrita
    process(reg_wr, wr_en)
    begin
        -- Seta os sinais de wr_en em '0'
        for i in 0 to 8 loop
            write_en_signals(i) <= '0';
        end loop;
        
        -- Habilita a escrita para o registrador selecionado
        if wr_en = '1' then
            write_en_signals(to_integer(unsigned(reg_wr))) <= '1';
        end if;
    end process;

    -- Process para selecionar o registrador de leitura
    process(reg_r)
    begin
        data_r <= (others => '0');
        data_r <= registers_data(to_integer(unsigned(reg_r)));
    end process;

end architecture;
