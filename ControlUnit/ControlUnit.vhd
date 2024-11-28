library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port(
        clk          : in std_logic;
        instruction  : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
        jump_enable  : out std_logic;                   -- Sinal para habilitar o Jump
        jump_address : out unsigned(6 downto 0);         -- Endereço absoluto para Jump
        sel_op_ula   : out unsigned(2 downto 0);         -- Operação da ULA
        sel_mux_regs : out std_logic;                    -- Seleção do mux de registradores entre Accumulator e Immediate
        reg_wr_en    : out std_logic;                    -- Habilita a escrita no banco de registradoresW
        accum_en     : out std_logic                    -- Habilita a escrita no acumulador
    );
end entity;

architecture behavioral of ControlUnit is
    signal opcode : std_logic_vector(3 downto 0);      -- Opcode (bits mais significativos)
    signal state : std_logic;                          -- Estado atual da máquina de estados
    signal src_reg   : std_logic_vector(3 downto 0);  -- Registrador de origem
    signal dst_reg   : std_logic_vector(3 downto 0);  -- Registrador de destino

begin
    opcode <= instruction(13 downto 10);               -- Extrai o opcode da instrução
    
    -- Extrai os registrador de origem e destino
    dst_reg <= instruction(9 downto 6) when opcode="0001" -- ADD
                                         OR opcode="0011" -- SUB
                                         OR opcode="0111" -- LW
                                         OR opcode="1010" -- MOV
                                       else "0000";

    src_reg <= instruction(5 downto 2) when opcode="0001" -- ADD
                                         OR opcode="0011" -- SUB
                                         OR opcode="0111" -- LW
                                         OR opcode="1010" -- MOV
                                       else instruction(9 downto 6);


    -- Detecta se a instrução é um Jump
    jump_enable <= '1' when opcode = "1111" else '0';
    jump_address <= unsigned(instruction(9 downto 3));      -- Extrai o endereço (bits menos significativos)

    -- Seleção da operação da ULA
    sel_op_ula <= "000" when opcode = "0001" else -- ADD
                  "010" when opcode = "0010" else -- AND
                  "001" when opcode = "0011" else -- SUB
                  --"011" when opcode = "0100" else -- XOR
                  --"100" when opcode = "0101" else -- LSL
                  --"101" when opcode = "0110" else -- LSR
                  "000";
    
    -- Seleção do mux de registradores entre Accumulator (1) e Immediate (0)
    sel_mux_regs <= '0' when opcode = "0110" else -- LD
                    '1';

    -- Habilita a escrita no banco de registradores
    reg_wr_en <= '1' when opcode = "0110" -- LD 
                       OR opcode = "1010" -- MOV 
                     else '0';

    -- Habilita a escrita no acumulador
    accum_en <= '1' when (opcode = "1010" AND dst_reg = "1111") else -- MOV to ACC
                '0';

end architecture;
