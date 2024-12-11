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
            clk    : in std_logic;
            rst    : in std_logic;
            estado : out unsigned(1 downto 0)  -- Estado atual
        );
    end component;
    component ProgramCounter_Control is
        port (
            clk          : in std_logic;
            wr_enable    : in  STD_LOGIC;
            jump_enable  : in std_logic;
            jump_in      : in unsigned(6 downto 0);
            br_enable    : in std_logic;
            br_in        : in unsigned(6 downto 0);
            br_condition : in std_logic_vector(2 downto 0);
            beq_cond     : in std_logic;            
            blt_cond     : in std_logic;            
            data_out     : out unsigned(6 downto 0)
        );
    end component;
    component ROM is
        port (
            clk      : in std_logic;
            endereco : in unsigned(6 downto 0);
            dado     : out std_logic_vector(13 downto 0) -- 14 bits para cada dado
        );
    end component;
    component ControlUnit is
        port (
            clk           : in std_logic;
            instruction   : in std_logic_vector(13 downto 0); -- Instrução da ROM (14 bits)
            jump_enable   : out std_logic;                    -- Sinal para habilitar o Jump
            jump_address  : out unsigned(6 downto 0);         -- Endereço absoluto para Jump
            br_enable     : out std_logic;                     -- Sinal para habilitar o Branch
            br_address    : out unsigned(6 downto 0);          -- Endereço relativo para Branch
            br_condition  : out std_logic_vector(2 downto 0);         -- Condição para Branch
            sel_op_ula    : out unsigned(2 downto 0);         -- Operação da ULA
            sel_mux_regs  : out std_logic;                    -- Seleção do mux de registradores entre Accumulator e Immediate
            reg_wr_en     : out std_logic;                    -- Habilita a escrita no banco de registradoresW
            accum_en      : out std_logic;                    -- Habilita a escrita no acumulador
            accum_ovwr_en : out std_logic;                     -- Habilita a sobrescrita no acumulador
            rst_accum     : out std_logic;                     -- Reseta o acumulador
            flags_wr_en   : out std_logic;                     -- Habilita a escrita das flags
            immediate     : out std_logic_vector(15 downto 0); -- Valor constante
            reg_code      : out std_logic_vector(3 downto 0)  -- Registrador de destino
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
    component Register16Bits is
        port ( 
            clock    : in std_logic;
            rst      : in std_logic;
            wr_en    : in std_logic;
            data_in  : in STD_LOGIC_VECTOR(15 downto 0);
            data_out : out STD_LOGIC_VECTOR(15 downto 0)
        );
    end component;
    component ULA is
        port (
            A, B        : in unsigned(15 downto 0);
            opcode      : in unsigned(2 downto 0);
            Result      : out unsigned(15 downto 0);
            flags_wr_en : in std_logic;
            Zero        : out std_logic;
            Carry       : out std_logic
        );
    end component;

    
    -- Sinais da State Machine
    signal estado : unsigned(1 downto 0) := (others => '0');
    
    -- Sinais do PC
    signal pc_en        : std_logic := '0';
    signal pc_out       : unsigned(6 downto 0) := (others => '0');
    
    -- Sinais da ROM
    signal rom_data : std_logic_vector(13 downto 0) := (others => '0');
    
    -- Sinais da Control Unit
    signal jump_enable_s   : std_logic := '0';
    signal jump_address_s  : unsigned(6 downto 0) := (others => '0');
    signal br_enable_s     : std_logic := '0';
    signal br_address_s    : unsigned(6 downto 0) := (others => '0');
    signal br_condition_s  : std_logic_vector(2 downto 0) := (others => '0');
    signal sel_op_ula_s    : unsigned(2 downto 0) := (others => '0');
    signal sel_mux_regs_s  : std_logic := '0';
    signal reg_wr_en_s     : std_logic := '0';
    signal accum_en_s      : std_logic := '0';
    signal accum_ovwr_en_s : std_logic := '0';
    signal rst_accum_s     : std_logic := '0';
    signal flags_wr_en_s   : std_logic := '0';
    signal imm             : std_logic_vector(15 downto 0) := (others => '0');
    signal reg_code_s      : std_logic_vector(3 downto 0) := (others => '0');
    -- signal reg_wr_s : std_logic_vector(3 downto 0) := (others => '0');
    -- signal reg_r_s : std_logic_vector(3 downto 0) := (others => '0');
    
    -- Sinais do Banco de Registradores
    signal reg_en      : std_logic := '0';
    signal data_wr_mux : std_logic_vector(15 downto 0) := (others => '0');
    signal data_r_s    : std_logic_vector(15 downto 0) := (others => '0');
    
    -- Sinais do Acumulador
    signal accum_en  : std_logic := '0';
    signal accum_out : std_logic_vector(15 downto 0) := (others => '0');
    signal accum_in  : std_logic_vector(15 downto 0) := (others => '0');
    
    -- Sinais da ULA
    signal ula_out : unsigned(15 downto 0) := (others => '0');
    signal carry   : std_logic := '0';
    signal zero    : std_logic := '0';


begin
    state_machine: StateMachine port map(
        clk    => clk,
        rst    => rst,
        estado => estado
    );

    pc: ProgramCounter_Control port map(
        clk          => clk,
        wr_enable    => pc_en,
        jump_enable  => jump_enable_s,
        jump_in      => jump_address_s,
        br_enable    => br_enable_s,
        br_in        => br_address_s,
        br_condition => br_condition_s,
        beq_cond     => zero,
        blt_cond     => carry,
        data_out     => pc_out
    );

    rom_1: ROM port map(
        clk      => clk,
        endereco => pc_out,
        dado     => rom_data
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
        rst_accum     => rst_accum_s,
        flags_wr_en   => flags_wr_en_s,
        immediate     => imm,
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
        flags_wr_en => flags_wr_en_s,
        Zero        => zero,
        Carry       => carry
    );

    -- Enables do FETCH
    pc_en <= '1' when estado = "10" else '0';

    -- Enables do DECODE

    -- Enables do EXECUTE
    accum_en <= accum_en_s when estado = "01" else '0';
    reg_en <= reg_wr_en_s when estado = "01" else '0';

    -- Registers Write Data Mux
    data_wr_mux <= accum_out when sel_mux_regs_s = '1' else imm;

    -- Accumulator data input
    accum_in <= data_r_s when accum_ovwr_en_s = '1' else STD_LOGIC_VECTOR(ula_out);

end architecture;


