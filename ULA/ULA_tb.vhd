library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ULA_tb is end;

architecture func of ULA_tb is
    component ULA port(
        A, B: in unsigned(15 downto 0);
        opcode: in unsigned(2 downto 0);
        Result: out unsigned(15 downto 0);
        Zero, Carry: out std_logic
    );
    end component;

    signal A, B, Result: unsigned(15 downto 0) := "0000000000000000";
    signal opcode: unsigned(2 downto 0) := "000";
    signal Zero, Carry: std_logic := '0';

    begin
        uut: ULA port map(A => A,
                          B => B,
                          Result => Result,
                          opcode => opcode,
                          Zero => Zero,
                          Carry => Carry);
    
    process begin
        --  SOMA de inteiros sem overflow  --
        opcode <= "000";
        A <= "0000000000000001"; -- 0x0001
        B <= "0000000000000001"; -- 0x0001 --> 0x0002

        wait for 5 ns;

        opcode <= "000";
        A <= "0100100000000001"; -- 0x4801
        B <= "0100000000000001"; -- 0x4001 --> 0x8802

        wait for 5 ns;
        
        --  SOMA de inteiros com overflow  --
        opcode <= "000";
        A <= "0000000000000001"; -- 0x0001
        B <= "1111111111111111"; -- 0xFFFF --> 0x0000 + (1 << 16)

        wait for 5 ns;

        opcode <= "000";
        A <= "1000000000000001"; -- 0x8001
        B <= "1000000000000100"; -- 0x8004 --> 0x0005 + (1 << 16)

        wait for 5 ns;

        -- SUBTRAÇÃO de inteiros sem underflow  --
        opcode <= "001";
        A <= "0000000000000010"; -- 0x0002
        B <= "0000000000000000"; -- 0x0000 --> 0x0002

        wait for 5 ns;
        
        opcode <= "001";
        A <= "0000000000000110"; -- 0x0006
        B <= "0000000000000011"; -- 0x0003 --> 0x0003

        wait for 5 ns;

        -- SUBTRAÇÃO de inteiros com underflow --
        opcode <= "001";
        A <= "0000000000000000"; -- 0x0000
        B <= "0000000000000001"; -- 0x0001 --> 0xFFFF

        wait for 5 ns;
        
        opcode <= "001";
        A <= "1111111111111110"; -- 0xFFFE
        B <= "1111111111111111"; -- 0xFFFF --> 0xFFFF

        wait for 5 ns;

        --  AND  --
        opcode <= "010";
        A <= "1010101010101010"; -- 0xAAAA
        B <= "0101010101010101"; -- 0x5555 --> 0x0000

        wait for 5 ns;
        
        opcode <= "010";
        A <= "1010101010101010"; -- 0xAAAA
        B <= "1111111111111111"; -- 0xFFFF --> 0xAAAA

        wait for 5 ns;

        --  XOR  --
        opcode <= "011";
        A <= "1010101010101010"; -- 0xAAAA
        B <= "0101010101010101"; -- 0x5555 --> 0xFFFF

        wait for 5 ns;
        
        opcode <= "011";
        A <= "1010101010101010"; -- 0xAAAA
        B <= "1111111111111111"; -- 0XFFFF --> 0X5555

        wait for 5 ns;

        --  Logical Shift Left  --
        opcode <= "100";
        A <= "0000000000000001"; -- 0x0001
        B <= "0000000000000101"; -- 0x0005 --> 0x0020

        wait for 5 ns;
        
        opcode <= "100";
        A <= "1001000000000000"; -- 0x9000
        B <= "0000000000000011"; -- 0x0003 --> 0x8000

        wait for 5 ns;

        --  Logical Shift Right  --
        opcode <= "101";
        A <= "0000000000000001"; -- 0x0001
        B <= "0000000000000001"; -- 0x0001 --> 0x0000

        wait for 5 ns;
        
        opcode <= "101";
        A <= "1001000000000000"; -- 0x9000
        B <= "0000000000001100"; -- 0x000C --> 0x0009

        wait for 5 ns;




        wait;
    end process;
end architecture;