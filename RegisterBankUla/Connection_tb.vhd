library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity Connection_tb is
end entity;

architecture a_Connection_tb of Connection_tb is
    component Connection
        Port (
            clock       : in  STD_LOGIC;
            rst         : in  STD_LOGIC;
            wr_en_regs  : in  STD_LOGIC;
            opcode      : in  STD_LOGIC_VECTOR(2 downto 0);
            reg_sel_wr  : in  STD_LOGIC_VECTOR(4 downto 0);
            reg_sel_rd  : in  STD_LOGIC_VECTOR(4 downto 0);
            data_in_regs: in  STD_LOGIC_VECTOR(15 downto 0);
            data_out    : out STD_LOGIC_VECTOR(15 downto 0);
            zero_flag   : out STD_LOGIC;
            carry_flag  : out STD_LOGIC
        );
    end component;

    constant period_time : time := 10 ns;
    signal clock       : STD_LOGIC := '0';
    signal rst         : STD_LOGIC := '0';
    signal wr_en_regs  : STD_LOGIC := '0';
    signal opcode      : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal reg_sel_wr  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Seleciona registrador de escrita
    signal reg_sel_rd  : STD_LOGIC_VECTOR(4 downto 0) := (others => '0'); -- Seleciona registrador de leitura
    signal data_in_regs: STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal data_out    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal zero_flag   : STD_LOGIC := '0';
    signal carry_flag  : STD_LOGIC := '0';
    signal finished    : STD_LOGIC := '0';

begin
    uut : Connection port map (
        clock       => clock,
        rst         => rst,
        wr_en_regs  => wr_en_regs,
        opcode      => opcode,
        reg_sel_wr  => reg_sel_wr,
        reg_sel_rd  => reg_sel_rd,
        data_in_regs=> data_in_regs,
        data_out    => data_out,
        zero_flag   => zero_flag,
        carry_flag  => carry_flag
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
        wait for 20 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 20 ns;

        -- Adicione um tempo de espera para permitir que o sistema estabilize após o reset
        wait for 10 ns;

        -- Test 1: Write 4 to register 0
        wr_en_regs <= '1';
        data_in_regs <= "0000000000000100";
        reg_sel_wr <= "00000";
        wait for 20 ns;

        -- Test 2: Read register 0
        wr_en_regs <= '0';
        reg_sel_rd <= "00000";
        wait for 20 ns;

        -- Test 3: Write 3 to register 1
        wr_en_regs <= '1';
        data_in_regs <= "0000000000000011";
        reg_sel_wr <= "00001";
        wait for 20 ns;

        -- Test 4: Read register 1
        wr_en_regs <= '0';
        reg_sel_rd <= "00001";
        wait for 20 ns;

        -- Test 5: Write 5 to register 3
        wr_en_regs <= '1';
        data_in_regs <= "0000000000000101";
        reg_sel_wr <= "00011";
        wait for 20 ns;

        -- Test 6: Read register 3
        wr_en_regs <= '0';
        reg_sel_rd <= "00011";
        wait for 20 ns;

        -- Test 7: Perform ALU operation (e.g., ADD)
        wr_en_regs <= '0';
        opcode <= "000";  -- Assuming 000 is ADD
        reg_sel_rd <= "00000";
        reg_sel_wr <= "00001";
        wait for 20 ns;

        wait;
    end process tb;
end architecture;
