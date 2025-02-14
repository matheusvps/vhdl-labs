library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity ROM is
    port (
           clk      : in STD_LOGIC;
           endereco : in unsigned(6 downto 0);
           dado     : out STD_LOGIC_VECTOR(13 downto 0)
    );
end entity;

architecture a_ROM of ROM is
    type mem is array (0 to 127) of std_logic_vector(13 downto 0); -- 128 posi��es de 14 bits
    constant conteudo_rom : mem := (
	  0 => B"0110_0000_011110",  -- LD R0, 30
	  1 => B"0110_0001_000001",  -- LD R1, 1
	  2 => B"0110_0010_010100",  -- LD R2, 20
	  3 => B"1010_1111_000000",  -- MOV ACC, R0  # Seta 120 para R0
	  4 => B"0001_0000_000000",  -- ADD ACC, R0
	  5 => B"0001_0000_000000",  -- ADD ACC, R0
	  6 => B"0001_0000_000000",  -- ADD ACC, R0
	  7 => B"1010_0000_111100",  -- MOV R0, ACC
	  8 => B"0110_0011_111101",  -- LD R3, -3   # Testa o BMI
	  9 => B"0110_0100_000000",  -- LD R4, 0
	 10 => B"1100_0000_000000",  -- ZAC
	 11 => B"1010_1111_001100",  -- MOV ACC, R3
	 12 => B"0101_0100_000000",  -- CMP R4
	 13 => B"1101_100_0001000",  -- BMI loop0
	 14 => B"0110_0011_000001",  -- LD R3, 1   # Não roda
	 15 => B"0110_0011_111101",  -- LD R3, -3   # Testa o BLS-Lower
	 16 => B"0110_0100_111110",  -- LD R4, -2
	 17 => B"1100_0000_000000",  -- ZAC
	 18 => B"1010_1111_001100",  -- MOV ACC, R3
	 19 => B"0101_0100_000000",  -- CMP R4
	 20 => B"1101_101_0000111",  -- BLS loop1
	 21 => B"0110_0011_111101",  -- LD R3, -3   # Testa o BLS-Same
	 22 => B"0110_0100_111101",  -- LD R4, -3
	 23 => B"1100_0000_000000",  -- ZAC
	 24 => B"1010_1111_001100",  -- MOV ACC, R3
	 25 => B"0101_0100_000000",  -- CMP R4
	 26 => B"1101_101_1110101",  -- BLS preloop
	 27 => B"1010_1111_000000",  -- MOV ACC, R0
	 28 => B"1011_0000_000000",  -- SW R0  # Salva o valor do Acumulador no endereço de memória de R1
	 29 => B"1010_1111_001000",  -- MOV ACC, R2  # Atualiza o índice
	 30 => B"0011_0001_000000",  -- SUB ACC, R1
	 31 => B"1010_0010_111100",  -- MOV R2, ACC
	 32 => B"1010_1111_000000",  -- MOV ACC, R0  # Incrementa o número
	 33 => B"0001_0001_000000",  -- ADD ACC, R1
	 34 => B"1010_0000_111100",  -- MOV R0, ACC
	 35 => B"1010_1111_001000",  -- MOV ACC, R2
	 36 => B"0101_0001_000000",  -- CMP R1
	 37 => B"1101_010_1110110",  -- BGT loop1
	 38 => B"0111_0000_000000",  -- LW R0  # Carrega o valor no endereco de memoria de R0 no Acumulador
   others => (others => '0')
    );
begin
   process(clk)
   begin
       if rising_edge(clk) then
           dado <= conteudo_rom(to_integer(endereco));
       end if;
   end process;
end architecture;
