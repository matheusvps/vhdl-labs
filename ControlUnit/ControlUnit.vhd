library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity ControlUnit is
    port(
        clk         : in std_logic;                    -- Clock
        instruction : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
        jump_enable : out std_logic;                   -- Sinal para habilitar o Jump
        jump_address: out unsigned(7 downto 0)         -- Endereço absoluto para Jump
    );
end entity;

architecture behavioral of ControlUnit is
    component StateMachine is
        port(
            clk   : in std_logic;  -- Clock
            reset : in std_logic;  -- Reset síncrono
            estado_o : out std_logic -- Saída representando o estado atual
        );
    end component;

    signal opcode : std_logic_vector(3 downto 0);      -- Opcode (bits mais significativos)
    signal state : std_logic;                          -- Estado atual da máquina de estados
begin
    -- Instanciação da máquina de estados
    SM : StateMachine port map(
        clk   => clk,
        reset => '0',
        estado_o => state
    );

    opcode <= instruction(13 downto 10);               -- Extrai o opcode da instrução
    
    -- Detecta se a instrução é um Jump
    jump_enable <= '1' when opcode = "1111" else '0';
    jump_address <= unsigned(instruction(7 downto 0));      -- Extrai o endereço (bits menos significativos)
end architecture;
