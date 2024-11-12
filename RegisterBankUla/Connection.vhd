library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Connection is
    Port (
        clock         : in  STD_LOGIC;
        rst           : in  STD_LOGIC;
        rst_accum     : in  STD_LOGIC;
        wr_en_regs    : in  STD_LOGIC;
        wr_en_accum   : in  STD_LOGIC;
        opcode        : in  STD_LOGIC_VECTOR(2 downto 0);
        reg_sel_wr    : in  STD_LOGIC_VECTOR(4 downto 0);
        reg_sel_rd    : in  STD_LOGIC_VECTOR(4 downto 0);
        data_in_regs  : in  STD_LOGIC_VECTOR(15 downto 0);
        data_out_regs : out STD_LOGIC_VECTOR(15 downto 0);
        accum_out     : out STD_LOGIC_VECTOR(15 downto 0);
        ula_out       : out STD_LOGIC_VECTOR(15 downto 0);
        zero_flag     : out STD_LOGIC;
        carry_flag    : out STD_LOGIC
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
            A, B    : in  UNSIGNED(15 downto 0);
            opcode  : in  UNSIGNED(2 downto 0);
            Result  : out UNSIGNED(15 downto 0);
            Zero    : out STD_LOGIC;
            Carry   : out STD_LOGIC
        );
    end component;
    component Register16Bits
        Port (
            clock   : in  STD_LOGIC;
            rst     : in  STD_LOGIC;
            wr_en   : in  STD_LOGIC;
            data_in : in  STD_LOGIC_VECTOR(15 downto 0);
            data_out: out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;

    signal reg_data_out   : STD_LOGIC_VECTOR(15 downto 0);
    signal accum_data_in  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal accum_data_out : STD_LOGIC_VECTOR(15 downto 0);
    signal ula_result     : UNSIGNED(15 downto 0);

begin

    reg_bank : RegisterBank
        Port map (
            clock   => clock,
            rst     => rst,
            wr_en   => wr_en_regs,
            data_wr => data_in_regs,
            reg_wr  => reg_sel_wr,
            reg_r   => reg_sel_rd,
            data_r  => reg_data_out 
        );

    connected_ula : ULA
        Port map (
            A       => UNSIGNED(accum_data_out),
            B       => UNSIGNED(reg_data_out),
            opcode  => UNSIGNED(opcode),
            Result  => ula_result,
            Zero    => zero_flag,
            Carry   => carry_flag
        );
    accumulator : Register16Bits
        Port map (
            clock    => clock,
            rst      => rst_accum,
            wr_en    => wr_en_accum,
            data_in  => accum_data_in,
            data_out => accum_data_out
        );

    accum_data_in <= std_logic_vector(ula_result);
    data_out_regs <= reg_data_out;
    accum_out <= accum_data_out;
    ula_out <= accum_data_in;
end a_Connection;
