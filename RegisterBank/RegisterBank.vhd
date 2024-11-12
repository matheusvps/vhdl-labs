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
    signal register_data_0  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_1  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_2  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_3  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_4  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_5  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_6  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_7  : STD_LOGIC_VECTOR(15 downto 0);
    signal register_data_8  : STD_LOGIC_VECTOR(15 downto 0);

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
    write_en_0 <= '1' when (wr_en = '1' and reg_wr = "00000") else '0';
    write_en_1 <= '1' when (wr_en = '1' and reg_wr = "00001") else '0';
    write_en_2 <= '1' when (wr_en = '1' and reg_wr = "00010") else '0';
    write_en_3 <= '1' when (wr_en = '1' and reg_wr = "00011") else '0';
    write_en_4 <= '1' when (wr_en = '1' and reg_wr = "00100") else '0';
    write_en_5 <= '1' when (wr_en = '1' and reg_wr = "00101") else '0';
    write_en_6 <= '1' when (wr_en = '1' and reg_wr = "00110") else '0';
    write_en_7 <= '1' when (wr_en = '1' and reg_wr = "00111") else '0';
    write_en_8 <= '1' when (wr_en = '1' and reg_wr = "01000") else '0';

    -- Seleciona o registrador de leitura
    data_r <= register_data_0 when reg_r = "00000" else
              register_data_1 when reg_r = "00001" else
              register_data_2 when reg_r = "00010" else
              register_data_3 when reg_r = "00011" else
              register_data_4 when reg_r = "00100" else
              register_data_5 when reg_r = "00101" else
              register_data_6 when reg_r = "00110" else
              register_data_7 when reg_r = "00111" else
              register_data_8 when reg_r = "01000" else (others => '0');

end architecture;
