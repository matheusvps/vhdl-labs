library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ProgramCounter_Control is
    port(
        clk          : in std_logic;
        wr_enable    : in std_logic;
        jump_enable  : in std_logic;
        jump_in      : in unsigned(6 downto 0);
        br_enable    : in std_logic;
        br_in        : in unsigned(6 downto 0);
        br_condition : in std_logic_vector(2 downto 0);
        beq_cond     : in std_logic;             -- Resultado da comparação de igualdade da ULA
        blt_cond     : in std_logic;             -- Resultado da comparação de igualdade da ULA
        data_out     : out unsigned(6 downto 0)
    );
end entity;

architecture behavior of ProgramCounter_Control is
    component ProgramCounter is
        port(
            clk       : in std_logic;
            wr_enable : in std_logic;
            data_in   : in unsigned(6 downto 0);
            data_out  : out unsigned(6 downto 0)
        );
    end component;

    signal pc_plus_1  : unsigned(6 downto 0) := (others => '0');
    signal data_out_s : unsigned(6 downto 0) := (others => '0');
    signal data_in_pc : unsigned(6 downto 0) := (others => '0');
    signal relative_address : unsigned(6 downto 0) := (others => '0');
    signal wr_enable_s : std_logic := '0';
    signal bne_cond : std_logic := '0';
    signal bgt_cond : std_logic := '0';
    begin
    PC: ProgramCounter 
        port map(
            clk => clk, 
            wr_enable => wr_enable_s, 
            data_in => data_in_pc, 
            data_out => data_out_s
        );

    -- Infere condições de branch
    bne_cond <= not beq_cond;
    bgt_cond <= not blt_cond;

    -- Adiciona o endereço relativo ao endereço atual (faz a extensão do sinal de 7 para 8 bits)
    -- relative_address <= ('0' & data_out_s) + ('0' & br_in);
    relative_address <= data_out_s + br_in;

    -- MUX para selecionar endereço de branch (relativo) ou de jump (absoluto)
    -- Instrução de JUMP tem prioridade sobre BRANCH
    data_in_pc <= jump_in when jump_enable = '1' else
                  relative_address when (br_enable = '1'  and (
                        (br_condition = "000" and beq_cond = '1') or  -- BEQ
                        (br_condition = "001" and bne_cond = '1') or  -- BEQ
                        (br_condition = "010" and bgt_cond = '1') or  -- BLT
                        (br_condition = "011" and blt_cond = '1')  -- BLT
                  ))
                  else pc_plus_1; 

    -- Habilita a escrita no PC
    wr_enable_s <= wr_enable;

    pc_plus_1 <= data_out_s + 1;
    data_out <= data_out_s;
end architecture;
