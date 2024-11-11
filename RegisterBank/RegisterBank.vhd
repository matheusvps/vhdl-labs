library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

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
        data_r  : out STD_LOGIC_VECTOR(15 downto 0) -- Dado lido do registrador selecionado
    );
end RegisterBank;

architecture a_RegisterBank of RegisterBank is
    component Register16Bits
        Port (
            clock    : in  STD_LOGIC;
            rst      : in  STD_LOGIC;
            wr_en    : in  STD_LOGIC;
            data_in  : in  STD_LOGIC_VECTOR(15 downto 0);
            data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    -- Sinais de controle e dados dos registradores
    signal register_data_0  : std_logic_vector(15 downto 0);
    signal register_data_1  : std_logic_vector(15 downto 0);
    signal register_data_2  : std_logic_vector(15 downto 0);
    signal register_data_3  : std_logic_vector(15 downto 0);
    signal register_data_4  : std_logic_vector(15 downto 0);
    signal register_data_5  : std_logic_vector(15 downto 0);
    signal register_data_6  : std_logic_vector(15 downto 0);
    signal register_data_7  : std_logic_vector(15 downto 0);
    signal register_data_8  : std_logic_vector(15 downto 0);

    signal write_en_0 : std_logic := '0';
    signal write_en_1 : std_logic := '0';
    signal write_en_2 : std_logic := '0';
    signal write_en_3 : std_logic := '0';
    signal write_en_4 : std_logic := '0';
    signal write_en_5 : std_logic := '0';
    signal write_en_6 : std_logic := '0';
    signal write_en_7 : std_logic := '0';
    signal write_en_8 : std_logic := '0';

begin
    -- Instanciando os registradores
    reg_0 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_0,
                                    data_in => data_wr,
                                    data_out => register_data_0
                                 );
    reg_1 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_1,
                                    data_in => data_wr,
                                    data_out => register_data_1
                                 );
    reg_2 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_2,
                                    data_in => data_wr,
                                    data_out => register_data_2
                                 );
    reg_3 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_3,
                                    data_in => data_wr,
                                    data_out => register_data_3
                                 );
    reg_4 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_4,
                                    data_in => data_wr,
                                    data_out => register_data_4
                                 );
    reg_5 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_5,
                                    data_in => data_wr,
                                    data_out => register_data_5
                                 );
    reg_6 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_6,
                                    data_in => data_wr,
                                    data_out => register_data_6
                                 );
    reg_7 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_7,
                                    data_in => data_wr,
                                    data_out => register_data_7
                                 );
    reg_8 : Register16Bits port map (
                                    clock => clock,
                                    rst => rst,
                                    wr_en => write_en_8,
                                    data_in => data_wr,
                                    data_out => register_data_8
                                 );

    -- Process para definir o registrador de escrita
    process(clock)
    begin
        if rising_edge(clock) then
            -- Seta os sinais de wr_en em '0'
            write_en_0 <= '0';
            write_en_1 <= '0';
            write_en_2 <= '0';
            write_en_3 <= '0';
            write_en_4 <= '0';
            write_en_5 <= '0';
            write_en_6 <= '0';
            write_en_7 <= '0';
            write_en_8 <= '0';
            
            -- Habilita a escrita para o registrador selecionado
            if wr_en = '1' then
                case reg_wr is
                    when "00000" =>
                        write_en_0 <= '1';
                    when "00001" =>
                        write_en_1 <= '1';
                    when "00010" =>
                        write_en_2 <= '1';
                    when "00011" =>
                        write_en_3 <= '1';
                    when "00100" =>
                        write_en_4 <= '1';
                    when "00101" =>
                        write_en_5 <= '1';
                    when "00110" =>
                        write_en_6 <= '1';
                    when "00111" =>
                        write_en_7 <= '1';
                    when "01000" =>
                        write_en_8 <= '1';
                    when others =>
                        write_en_0 <= '0';
                end case;
            end if;
        end if;
    end process;

    -- Process para selecionar o registrador de leitura
    process(clock)
    begin
        if rising_edge(clock) then
            data_r <= (others => '0');
            case reg_r is
                when "00000" =>
                    data_r <= register_data_0;
                when "00001" =>
                    data_r <= register_data_1;
                when "00010" =>
                    data_r <= register_data_2;
                when "00011" =>
                    data_r <= register_data_3;
                when "00100" =>
                    data_r <= register_data_4;
                when "00101" =>
                    data_r <= register_data_5;
                when "00110" =>
                    data_r <= register_data_6;
                when "00111" =>
                    data_r <= register_data_7;
                when "01000" =>
                    data_r <= register_data_8;
                when others =>
                    data_r <= (others => '1');
            end case;
        end if;
    end process;

end architecture;
