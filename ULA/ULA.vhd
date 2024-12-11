library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

-- ULA com acumulador de 16 bits
-- Op Codes:
--     000 - Soma
--     001 - Subtração
--     010 - And
--     011 - Xor
--     100 - Logical Shift Left
--     101 - Logical Shift Right 
-- Flags:
--     Zero  - Indica se o resultado é zero
--     Carry - Indica se houve carry na operação
-- 

entity ULA is
    port(
        A, B        : in unsigned(15 downto 0);
        opcode      : in unsigned(2 downto 0);
        Result      : out unsigned(15 downto 0);
        flags_wr_en : in std_logic;
        Zero        : out std_logic;
        Carry       : out std_logic
    );
end entity;

architecture func of ULA is
    signal extendedA, extendedB, resultSoma, resultSub, resultAnd, resultXor, resultTmp, resultLSL, resultLSR: unsigned(16 downto 0);

    signal zero_s : std_logic := '0';
    signal carry_s : std_logic := '0';

    begin

    --  Adiciona um bit à palavra para setar as flags --
    extendedA <= '0' & A;
    extendedB <= '0' & B;

    --  Operação de Soma  --
    resultSoma <= extendedA + extendedB;

    --  Operação de Subtração  --
    resultSub <= extendedA - extendedB;

    --  Operação de And  --
    resultAnd <= '0' & (A and B);

    --  Operação de Xor  --
    resultXor <= '0' & (A xor B);

    --  Operações de Logical Shift  --
    resultLSL <= '0' & (A sll to_integer(B));
    resultLSR <= '0' & (A srl to_integer(B));
    

    --  MUX para definir a saída  --
    resultTmp <= resultSoma when opcode = "000" else
                  resultSub when opcode = "001" else
                  resultAnd when opcode = "010" else
                  resultXor when opcode = "011" else
                  resultLSL when opcode = "100" else
                  resultLSR when opcode = "101" else "00000000000000000";
    Result <= resultTmp(15 downto 0);

    --  Definição das flags  --
    zero_s <= '1' when resultTmp = "00000000000000000" else '0';

    carry_s <= resultSoma(16) when opcode = "000" else
                resultSub(16) when opcode = "001" else '0';

    Zero <= zero_s when flags_wr_en = '1' else '0';
    Carry <= carry_s when flags_wr_en = '1' else '0';

end architecture;