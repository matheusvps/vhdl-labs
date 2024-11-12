library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Connection_tb is
end entity;

architecture a_Connection_tb of Connection_tb is
    component Connection
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
    end component;

    constant period_time : time := 10 ns;
    signal clock         : STD_LOGIC := '0';
    signal rst,rst_accum : STD_LOGIC := '0';
    signal wr_en_regs    : STD_LOGIC := '0';
    signal wr_en_accum   : STD_LOGIC := '0';
    signal opcode        : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_sel_wr    : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal reg_sel_rd    : STD_LOGIC_VECTOR(4 downto 0) := (others => '0');
    signal data_in_regs  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal data_out      : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal accum_out     : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal ula_out       : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal zero_flag     : STD_LOGIC := '0';
    signal carry_flag    : STD_LOGIC := '0';
    signal finished      : STD_LOGIC := '0';

begin
    uut : Connection port map (
        clock         => clock,
        rst           => rst, 
        rst_accum     => rst_accum,
        wr_en_regs    => wr_en_regs,
        wr_en_accum   => wr_en_accum,
        opcode        => opcode,
        reg_sel_wr    => reg_sel_wr,
        reg_sel_rd    => reg_sel_rd,
        data_in_regs  => data_in_regs,
        data_out_regs => data_out,
        accum_out     => accum_out,
        ula_out       => ula_out,
        zero_flag     => zero_flag,
        carry_flag    => carry_flag
    );

    clk_proc: process
    begin
        while finished /= '1' loop
            clock <= '0';
            wait for period_time / 2;
            clock <= '1';
            wait for period_time / 2;
        end loop;
        wait;
    end process clk_proc;

    sim_time_proc: process
    begin
        wait for 1 us;
        finished <= '1';
        wait;
    end process sim_time_proc;

    tb: process
    begin
        -- Reset the system
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait for 10 ns;

        -- Write 34 to register 0
        wr_en_regs <= '1';
        data_in_regs <= "0000000000100010";
        reg_sel_wr <= "00000";
        wait for 10 ns;

        -- Write 12 to register 1
        wr_en_regs <= '1';
        data_in_regs <= "0000000000001100";
        reg_sel_wr <= "00001";
        wait for 10 ns;

        -- Read from register 1
        wr_en_regs <= '0';
        reg_sel_rd <= "00001";
        wait for 10 ns;

        -- Reset accumulator and write register 1's value + 0 to it
        reg_sel_rd <= "00001";
        opcode <= "000";
        rst_accum <= '1';
        wait for 10 ns;
        rst_accum <= '0';
        wr_en_accum <= '1';
        wait for 10 ns;

        -- Sum accumulator with register 0
        opcode <= "000";
        reg_sel_rd <= "00000";
        wait for 10 ns;

        -- Write 14 to register 7
        wr_en_accum <= '0';
        wr_en_regs <= '1';
        data_in_regs <= "0000000000001110";
        reg_sel_wr <= "00111";
        wait for 10 ns;

        -- Subtract register 7 from accumulator
        wr_en_regs <= '0';
        wr_en_accum <= '1';
        opcode <= "001";
        reg_sel_rd <= "00111";
        wait for 10 ns;

        -- Write accumulator to register 2
        wr_en_accum <= '0';
        wr_en_regs <= '1';
        data_in_regs <= accum_out;
        reg_sel_wr <= "00010";
        reg_sel_rd <= "00010";
        wait for 10 ns;
        
        -- ========= Reset the system ========= --
        wr_en_regs <= '0';
        wr_en_accum <= '0';
        rst <= '1';
        rst_accum <= '1';
        wait for 10 ns;
        
        rst_accum <= '0';
        rst <= '0';
        wait for 10 ns;
        -- ==================================== --

        -- Write 0xFFFF to register 3
        wr_en_regs <= '1';
        data_in_regs <= "1111111111111111";
        reg_sel_wr <= "00011";
        wait for 10 ns;

        -- Write 0x0001 to register 4
        data_in_regs <= "0000000000000001";
        reg_sel_wr <= "00100";
        wait for 10 ns;

        -- Read from register 3 and write to accumulator
        wr_en_regs <= '0';
        wr_en_accum <= '1';
        opcode <= "000";
        reg_sel_rd <= "00011";
        wait for 10 ns;

        -- Sum accumulator with register 4
        reg_sel_rd <= "00100";
        wait for 10 ns;

        wr_en_accum <= '0';

        wait;
    end process tb;
end architecture;
