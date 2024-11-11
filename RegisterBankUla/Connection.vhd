library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Connection is
    Port (
        clock       : in  STD_LOGIC;
        rst         : in  STD_LOGIC;
        wr_en       : in  STD_LOGIC;
        opcode      : in  STD_LOGIC_VECTOR(2 downto 0);
        reg_sel_wr  : in  STD_LOGIC_VECTOR(4 downto 0);
        reg_sel_rd  : in  STD_LOGIC_VECTOR(4 downto 0);
        data_in     : in  STD_LOGIC_VECTOR(15 downto 0);
        data_out    : out STD_LOGIC_VECTOR(15 downto 0);
        zero_flag   : out STD_LOGIC;
        carry_flag  : out STD_LOGIC
    );
end Connection;

architecture a_Connection of Connection is

    component RegisterBank
        Port (
            clock   : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            wr_en   : in  STD_LOGIC; 
            data_wr : in  STD_LOGIC_VECTOR(15 downto 0);
            reg_wr  : in  STD_LOGIC_VECTOR(4 downto 0);
            reg_r   : in  STD_LOGIC_VECTOR(4 downto 0);
            data_r  : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    component ULA
        Port (
            A       : in  UNSIGNED(15 downto 0);
            B       : in  UNSIGNED(15 downto 0);
            opcode  : in  UNSIGNED(2 downto 0);
            Result  : out UNSIGNED(15 downto 0);
            Zero    : out STD_LOGIC;
            Carry   : out STD_LOGIC
        );
    end component;

    signal reg_data_in    : STD_LOGIC_VECTOR(15 downto 0);
    signal reg_data_out   : STD_LOGIC_VECTOR(15 downto 0);
    signal ula_result     : UNSIGNED(15 downto 0);
    signal accum          : STD_LOGIC_VECTOR(15 downto 0);
    signal ula_zero       : STD_LOGIC := '0';
    signal ula_carry      : STD_LOGIC := '0';

begin

    reg_bank : RegisterBank
        Port map (
            clock   => clock,
            rst     => rst,
            wr_en   => wr_en,
            data_wr => data_in,
            reg_wr  => reg_sel_wr,
            reg_r   => reg_sel_rd,
            data_r  => reg_data_out 
        );

    connected_ula : ULA
        Port map (
            A       => UNSIGNED(accum),
            B       => UNSIGNED(reg_data_out),
            opcode  => UNSIGNED(opcode),
            Result  => ula_result,
            Zero    => ula_zero,
            Carry   => ula_carry
        );

    process(clock, rst)
    begin
        if rst = '1' then
            accum <= (others => '0');
        elsif rising_edge(clock) then
            accum <= std_logic_vector(ula_result);
        end if;
    end process;

    data_out   <= accum;      
    zero_flag  <= ula_zero; 
    carry_flag <= ula_carry;

end a_Connection;
