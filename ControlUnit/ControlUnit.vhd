library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port(
        clk           : in std_logic;
        instruction   : in std_logic_vector(13 downto 0);  -- Instrução da ROM (14 bits)
        jump_enable   : out std_logic;                     -- Sinal para habilitar o Jump
        jump_address  : out unsigned(6 downto 0);          -- Endereço absoluto para Jump
        br_enable     : out std_logic;                     -- Sinal para habilitar o Branch
        br_address    : out unsigned(6 downto 0);          -- Endereço relativo para Branch
        br_condition  : out std_logic_vector(2 downto 0);         -- Condição para Branch
        sel_op_ula    : out unsigned(2 downto 0);          -- Operação da ULA
        sel_mux_regs  : out std_logic;                     -- Seleção do mux de registradores entre Accumulator e Immediate
        reg_wr_en     : out std_logic;                     -- Habilita a escrita no banco de registradoresW
        accum_en      : out std_logic;                     -- Habilita a escrita no acumulador
        accum_ovwr_en : out std_logic;                     -- Habilita a sobrescrita no acumulador
        rst_accum     : out std_logic;                     -- Reseta o acumulador
        flags_wr_en   : out std_logic;                     -- Habilita a escrita das flags
        immediate     : out std_logic_vector(15 downto 0); -- Valor constante
        reg_code      : out std_logic_vector(3 downto 0)   -- Registrador de destino
    );
end entity;

architecture behavioral of ControlUnit is
    signal opcode  : std_logic_vector(3 downto 0) := (others => '0');      -- Opcode (bits mais significativos)
    signal state   : std_logic := '0';  -- Estado atual da máquina de estados
    signal dst_reg : std_logic_vector(3 downto 0) := (others => '0');  -- Registrador de destino

begin
    opcode <= instruction(13 downto 10);               -- Extrai o opcode da instrução
    
    -- Extract Immediate from ROM data
    immediate <= "0000000000" & instruction(5 downto 0);

    -- Extrai os registrador de origem e destino
    -- MODIFICAR AQUI: RETIRAR CONDICIONAL MULTIPLA PARA MOV
    reg_code <= instruction(9 downto 6);

    -- Detecta se a instrução é um Jump
    jump_enable <= '1' when opcode = "1111" else '0';
    jump_address <= unsigned(instruction(9 downto 3));      -- Extrai o endereço (bits menos significativos)

    -- Detecta se a instrução é um Branch
    br_enable <= '1' when opcode = "1101" else '0';
    br_address <= unsigned(instruction(6 downto 0));      -- Extrai o endereço (bits menos significativos)
    br_condition <= instruction(9 downto 7);              -- Extrai a condição de Branch

    -- Seleção da operação da ULA
    sel_op_ula <= "000" when opcode = "0001" else -- ADD
                  "001" when opcode = "0011" else -- SUB
                  "001" when opcode = "0101" else -- CMP
                  --"010" when opcode = "0010" else -- AND
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
    accum_en <= '1' when (opcode = "1010" AND dst_reg = "1111")  -- MOV to ACC
                      OR opcode = "0001" -- ADD
                      OR opcode = "0011" -- SUB
                    else '0';
    
    -- Reseta o acumulador
    rst_accum <= '1' when opcode = "1100" else -- ZAC
                 '0';

    -- Sobrescreve o acumulador
    accum_ovwr_en <= '1' when (opcode = "1010" and dst_reg = "1111") -- MOV to ACC
                           OR (opcode = "0101") -- CMP
                         else '0';
    
    -- Habilita a escrita das flags
    flags_wr_en <= '1' when opcode = "0101" else -- CMP
                   '0';

end architecture;
