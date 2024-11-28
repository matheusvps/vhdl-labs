library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port(
        clk          : in std_logic;
        instruction  : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
        jump_enable  : out std_logic;                   -- Sinal para habilitar o Jump
        jump_address : out unsigned(7 downto 0)         -- Endereço absoluto para Jump
        sel_op_ula   : out unsigned(2 downto 0)         -- Operação da ULA
        sel_mux_regs : out std_logic                    -- Seleção do mux de registradores entre Accumulator e Immediate
        reg_wr_en    : out std_logic                    -- Habilita a escrita no banco de registradoresW
        accum_en     : out std_logic                    -- Habilita a escrita no acumulador
    );
end entity;

architecture behavioral of ControlUnit is
    signal opcode : std_logic_vector(3 downto 0);      -- Opcode (bits mais significativos)
    signal state : std_logic;                          -- Estado atual da máquina de estados
    signal sel_op_ula   : unsigned(2 downto 0) := "000"; -- Seleção da operação da ULA
    signal sel_mux_regs : std_logic := '0';
    signal reg_wr_en    : std_logic := '0';

begin
    opcode <= instruction(13 downto 10);               -- Extrai o opcode da instrução
    
    -- Detecta se a instrução é um Jump
    jump_enable <= '1' when opcode = "1111" else '0';
    jump_address <= unsigned(instruction(7 downto 0));      -- Extrai o endereço (bits menos significativos)

    -- Seleção da operação da ULA
    sel_op_ula <= "000" when opcode = "0001" else -- ADD
                  "010" when opcode = "0010" else -- AND
                  "001" when opcode = "0011" else -- SUB
                  "011" when opcode = "0100" else -- XOR
                  "100" when opcode = "0101" else -- LSL
                  "101" when opcode = "0110" else -- LSR
                  "000";
    
    -- Seleção do mux de registradores entre Accumulator (1) e Immediate (0)
    sel_mux_regs <= '0' when opcode = "0110" else -- LD
                    '1';

    -- Habilita a escrita no banco de registradores
    reg_wr_en <= '1' when opcode = "0110" -- LD 
                       OR opcode = "1010" -- MOV 
                     else '0';

    -- Habilita a escrita no acumulador
    accum_en <= '1' when opcode = "1010"

end architecture;
