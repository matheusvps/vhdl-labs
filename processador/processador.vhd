library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity processador is
    port (
        clk : in std_logic;
        rst : in std_logic
    );
end entity;
  
  architecture a_processador of processador is
    component StateMachine is
        port (
            clk       : in std_logic;
            rst       : in std_logic;
            exception : in std_logic; -- Sinal de exceção para halt
            estado    : out unsigned(1 downto 0)  -- Estado atual
        );
    end component;
    component ProgramCounter_Control is
        port (
            clk          : in std_logic;
            rst          : in std_logic;
            wr_enable    : in  STD_LOGIC;
            jump_enable  : in std_logic;
            jump_in      : in unsigned(6 downto 0);
            br_enable    : in std_logic;
            br_in        : in unsigned(6 downto 0);
            br_condition : in std_logic_vector(2 downto 0);
            beq_cond     : in std_logic;            
            blt_cond     : in std_logic;          
            bmi_cond     : in std_logic;  
            data_out     : out unsigned(6 downto 0)
        );
    end component;
    component MMU is
        port (
            ram_read_en  : in std_logic;
            ram_write_en : in std_logic;
            endereco_in  : in std_logic_vector(15 downto 0);
            endereco_out : out std_logic_vector(15 downto 0);
            exception    : out std_logic
        );
    end component;
    component ROM is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out std_logic_vector(13 downto 0) -- 14 bits para cada dado
        );
    end component;
    component RAM is
        port (
            clk      : in STD_LOGIC;
            endereco : in STD_LOGIC_VECTOR(15 downto 0);
            wr_en    : in STD_LOGIC;
            dado_in  : in STD_LOGIC_VECTOR(15 downto 0);
            dado_out : out STD_LOGIC_VECTOR(15 downto 0) 
        );
    end component;
    component ControlUnit is
        port (
            clk           : in std_logic;
            instruction   : in STD_LOGIC_VECTOR(13 downto 0);  -- Instrução da ROM (14 bits)
            jump_enable   : out std_logic;                     -- Sinal para habilitar o Jump
            jump_address  : out unsigned(6 downto 0);          -- Endereço absoluto para Jump
            br_enable     : out std_logic;                     -- Sinal para habilitar o Branch
            br_address    : out unsigned(6 downto 0);          -- Endereço relativo para Branch
            br_condition  : out STD_LOGIC_VECTOR(2 downto 0);  -- Condição para Branch
            sel_op_ula    : out unsigned(2 downto 0);          -- Operação da ULA
            sel_mux_regs  : out std_logic;                     -- Seleção do mux de registradores entre Accumulator e Immediate
            reg_wr_en     : out std_logic;                     -- Habilita a escrita no banco de registradoresW
            accum_en      : out std_logic;                     -- Habilita a escrita no acumulador
            accum_ovwr_en : out std_logic;                     -- Habilita a sobrescrita no acumulador
            accum_mux_sel : out std_logic;                     -- Seleção do mux de entrada do acumulador
            rst_accum     : out std_logic;                     -- Reseta o acumulador
            flags_wr_en   : out std_logic;                     -- Habilita a escrita das flags
            immediate     : out STD_LOGIC_VECTOR(15 downto 0); -- Valor constante
            ram_wr_en     : out std_logic;                     -- Habilita a escrita na RAM
            ram_rd_en     : out std_logic;                     -- Habilita a leitura na RAM
            reg_code      : out STD_LOGIC_VECTOR(3 downto 0)   -- Registrador de destino
        );
    end component;
    component RegisterBank is
        port (
            clock   : in  STD_LOGIC;
            rst     : in  STD_LOGIC; -- Reseta todos os registradores
            wr_en   : in  STD_LOGIC; 
            data_wr : in  STD_LOGIC_VECTOR(15 downto 0); -- Dado a ser escrito
            reg_wr  : in  STD_LOGIC_VECTOR(3 downto 0);  -- Seleção do registrador para escrita
            reg_r   : in  STD_LOGIC_VECTOR(3 downto 0);  -- Seleção do registrador para leitura
            data_r  : out STD_LOGIC_VECTOR(15 downto 0) -- Dado lido do registrador selecionado
        );
    end component;
    component Register1bit is
        port (
            clock    : in STD_LOGIC;
            rst      : in STD_LOGIC;
            wr_en    : in STD_LOGIC;
            data_in  : in STD_LOGIC;
            data_out : out STD_LOGIC
        );
    end component;
    component Register16Bits is
        port ( 
            clock    : in STD_LOGIC;
            rst      : in STD_LOGIC;
            wr_en    : in STD_LOGIC;
            data_in  : in STD_LOGIC_VECTOR(15 downto 0);
            data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    component ULA is
        port (
            A, B        : in unsigned(15 downto 0);
            opcode      : in unsigned(2 downto 0);
            Result      : out unsigned(15 downto 0);
            Zero        : out std_logic;
            Carry       : out std_logic;
            Negative    : out std_logic
        );
    end component;

    
    -- Sinais da State Machine
    signal estado    : unsigned(1 downto 0) := (others => '0');
    
    -- Sinais do PC
    signal pc_en        : std_logic := '0';
    signal pc_out       : unsigned(6 downto 0) := (others => '0');
    
    -- Sinais da MMU
    signal exception : std_logic := '0';
    signal endereco  : std_logic_vector(15 downto 0) := (others => '0');

    -- Sinais da ROM
    signal rom_data : STD_LOGIC_VECTOR(13 downto 0) := (others => '0');

    -- Sinais da RAM
    signal ram_out : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    -- Sinais da Control Unit
    signal jump_enable_s   : std_logic := '0';
    signal jump_address_s  : unsigned(6 downto 0) := (others => '0');
    signal br_enable_s     : std_logic := '0';
    signal br_address_s    : unsigned(6 downto 0) := (others => '0');
    signal br_condition_s  : STD_LOGIC_VECTOR(2 downto 0) := (others => '0');
    signal sel_op_ula_s    : unsigned(2 downto 0) := (others => '0');
    signal sel_mux_regs_s  : std_logic := '0';
    signal reg_wr_en_s     : std_logic := '0';
    signal accum_en_s      : std_logic := '0';
    signal accum_ovwr_en_s : std_logic := '0';
    signal accum_mux_sel_s : std_logic := '0';
    signal rst_accum_s     : std_logic := '0';
    signal flags_wr_en_s   : std_logic := '0';
    signal imm             : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal ram_wr_en_s     : std_logic := '0';
    signal ram_rd_en_s     : std_logic := '0';
    signal reg_code_s      : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
    
    -- Sinais do Banco de Registradores
    signal reg_en      : std_logic := '0';
    signal data_wr_mux : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal data_r_s    : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    -- Sinais do Acumulador
    signal accum_en  : std_logic := '0';
    signal accum_out : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    signal accum_in  : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
    
    -- Sinais da ULA
    signal ula_out  : unsigned(15 downto 0) := (others => '0');
    signal carry    : std_logic := '0';
    signal zero     : std_logic := '0';
    signal negative : std_logic := '0';

    -- Sinais dos registradores de flags
    signal zero_flag : std_logic := '0';
    signal carry_flag : std_logic := '0';


begin
    state_machine: StateMachine port map(
        clk       => clk,
        rst       => rst,
        exception => exception,
        estado    => estado
    );

    pc: ProgramCounter_Control port map(
        clk          => clk,
        rst          => rst,
        wr_enable    => pc_en,
        jump_enable  => jump_enable_s,
        jump_in      => jump_address_s,
        br_enable    => br_enable_s,
        br_in        => br_address_s,
        br_condition => br_condition_s,
        beq_cond     => zero_flag,
        blt_cond     => carry_flag,
        bmi_cond     => negative,
        data_out     => pc_out
    );

    mmu_1: MMU port map(
        ram_read_en  => ram_rd_en_s,
        ram_write_en => ram_wr_en_s,
        endereco_in  => data_r_s,
        endereco_out => endereco,
        exception    => exception
    );

    rom_1: ROM port map(
        clk      => clk,
        endereco => pc_out,
        dado     => rom_data
    );

    ram_1: RAM port map(
        clk      => clk,
        endereco => endereco,
        wr_en    => ram_wr_en_s,
        dado_in  => accum_out,
        dado_out => ram_out
    );

    control_unit: ControlUnit port map(
        clk           => clk,
        instruction   => rom_data,
        jump_enable   => jump_enable_s,
        jump_address  => jump_address_s,
        br_enable     => br_enable_s,
        br_address    => br_address_s,
        br_condition  => br_condition_s,
        sel_op_ula    => sel_op_ula_s,
        sel_mux_regs  => sel_mux_regs_s,
        reg_wr_en     => reg_wr_en_s,
        accum_en      => accum_en_s,
        accum_ovwr_en => accum_ovwr_en_s,
        accum_mux_sel => accum_mux_sel_s,
        rst_accum     => rst_accum_s,
        flags_wr_en   => flags_wr_en_s,
        immediate     => imm,
        ram_wr_en     => ram_wr_en_s,
        ram_rd_en     => ram_rd_en_s,
        reg_code      => reg_code_s
    );

    register_bank: RegisterBank port map(
        clock   => clk,
        rst     => rst,
        wr_en   => reg_en,
        data_wr => data_wr_mux,
        reg_wr  => reg_code_s,
        reg_r   => reg_code_s,
        data_r  => data_r_s
    );

    accumulator: Register16Bits port map(
        clock    => clk,
        rst      => rst_accum_s,
        wr_en    => accum_en,
        data_in  => accum_in,
        data_out => accum_out
    );

    ula_1: ULA port map(
        A           => UNSIGNED(accum_out),
        B           => UNSIGNED(data_r_s),
        opcode      => UNSIGNED(sel_op_ula_s),
        Result      => ula_out,
        Zero        => zero,
        Carry       => carry,
        Negative    => negative
    );

    flag_zero: Register1bit port map(
        clock    => clk,
        rst      => rst,
        wr_en    => flags_wr_en_s,
        data_in  => zero,
        data_out => zero_flag
    );

    flag_carry: Register1bit port map(
        clock    => clk,
        rst      => rst,
        wr_en    => flags_wr_en_s,
        data_in  => carry,
        data_out => carry_flag
    );

    -- Enables do FETCH
    pc_en <= '1' when (estado = "10" and exception = '0') else '0';
    
    -- Enables do DECODE

    -- Enables do EXECUTE
    accum_en <= accum_en_s when estado = "01" else '0';
    reg_en <= reg_wr_en_s when estado = "01" else '0';

    -- Registers Write Data Mux
    data_wr_mux <= accum_out when sel_mux_regs_s = '1' else imm;

    -- Accumulator data input
    accum_in <= data_r_s when (accum_ovwr_en_s = '1' and ram_rd_en_s = '0') else
                 ram_out when ram_rd_en_s = '1' 
                    else STD_LOGIC_VECTOR(ula_out);

end architecture;


