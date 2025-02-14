import sys

# Instructions dictionary
instructions = {
    "NOP" : "0000",
    "ADD" : "0001",
    "SUB" : "0011",
    "CMP" : "0101",
    "LD"  : "0110",
    "LW"  : "0111",
    "OR"  : "1000",
    "MULT": "1001",
    "MOV" : "1010",
    "SW"  : "1011",
    "ZAC" : "1100",
    "BEQ" : "1101",
    "BNE" : "1101",
    "BGT" : "1101",
    "BLT" : "1101",
    "BMI" : "1101",
    "BLS" : "1101",
    "JMP": "1111"
}

COMMENT_CHAR = '#'

def invert_bits(bin_string):
    return ''.join(['1' if bit == '0' else '0' for bit in bin_string])

def get_twos_complement(value, bits=7):
    if value >= 0:
        bin_string = bin(value)[2:].zfill(bits)
        return bin_string
    value = abs(value)
    bin_string = bin(value)[2:].zfill(bits)
    reversed_bin = invert_bits(bin_string)
    twos_complement = bin(int(reversed_bin, 2) + 1)[2:].zfill(bits)
    return twos_complement

def assemble(filename):
    labels = {}
    rom_code = []
    with open(filename) as f:
        lines = f.readlines()
        i = 0
        for line in lines:
            line = line.strip()
            # Filters empty lines and comments
            if line == "" or line == "\n" or line.startswith(COMMENT_CHAR):
                continue

            # Remove comments from line, if any
            code = line.split(COMMENT_CHAR, 1)[0]

            # Handle labels
            if ":" in code:
                label, code = code.split(":", 1)
                label = label.strip()
                code = code.strip()
                labels[label] = i
            
            if code == "":  # If the line was only a label
                continue
            
            # Split the code into tokens
            space_split = code.split(" ", 1)
            instruction = space_split[0].upper()
            try:
                operands = space_split[1].split(',')
            except IndexError:
                operands = None
            
            # Get the binary code for the instruction
            opcode = instructions[instruction]

            # Initialize variables for the operands
            operand1 = operand2 = op1 = op2 = None

            # Modify the binary depending on the instruction
            if instruction in ["LD"]:  # INSTRUCTIONS WITH CONSTANT
                operand1 = operands[0].strip()
                op1 = bin(int(operand1.split('R')[1]))[2:].zfill(4)
                operand2 = operands[1].strip()
                num = int(operand2)
                op2 = get_twos_complement(num, 6)

            elif instruction in ["JMP", "BEQ", "BNE", "BGT", "BLT", "BMI", "BLS"]:  # INSTRUCTIONS WITH LABEL
                if instruction == "JMP":
                    op1 = space_split[1].strip()
                    op1 = 'A' + op1   # Absolute jump
                    op2 = "000"
                else:
                    op1 = "000"
                    if instruction == "BEQ":
                        op1 = "000"
                    elif instruction == "BNE":
                        op1 = "001"
                    elif instruction == "BGT":
                        op1 = "010"
                    elif instruction == "BLT":
                        op1 = "011"
                    elif instruction == "BMI":
                        op1 = "100"
                    elif instruction == "BLS":
                        op1 = "101"
                    op2 = space_split[1].strip()
                    op2 = 'R' + op2   # Relative jump
            
            elif instruction in ["ADD", "SUB", "OR", "MULT"]: # INSTRUCTIONS WITH ONLY 1 REGISTER
                operand1 = operands[1].strip()
                op1 = bin(int(operand1.split('R')[1]))[2:].zfill(4)
                op2 = "000000"
            
            elif instruction in ["LW", "SW"]: # INSTRUCTIONS WITH MEMORY ACCESS
                operand1 = operands[0].strip()  # Value to be saved/loaded from memory
                # operand2 = operands[1].strip()[1:-1]  # Memory address
                # op1 = bin(int(operand2.split('R')[1]))[2:].zfill(4)
                op1 = bin(int(operand1.split('R')[1]))[2:].zfill(4)
                op2 = "000000"
                
            elif instruction in ["ZAC", "NOP"]: # INSTRUCTIONS WITHOUT OPERANDS
                op1 = "0000"
                op2 = "000000"
            
            elif instruction in ["MOV"]: # INSTRUCTIONS WITH 2 OPERANDS
                operand0 = operands[0].strip()
                operand1 = operands[1].strip()
                if operand1 == 'ACC':  # MOV ACC -> R
                    op1 = bin(int(operand0.split('R')[1]))[2:].zfill(4)
                    op2 = "1111" + "00"
                elif operand0 == 'ACC':  # MOV R -> ACC
                    op1 = "1111"
                    op2 = bin(int(operand1.split('R')[1]))[2:].zfill(4) + "00"
                elif instruction == "CMP":
                    op1 = bin(int(operand0.split('R')[1]))[2:].zfill(4)
                    op2 = bin(int(operand1))[2:].zfill(6)
                else:  # MOV R -> R
                    op1 = bin(int(operand0.split('R')[1]))[2:].zfill(4)
                    op2 = bin(int(operand1.split('R')[1]))[2:].zfill(4) + "00"
            
            elif instruction in ["CMP"]:
                operand0 = operands[0].strip()
                op1 = bin(int(operand0.split('R')[1]))[2:].zfill(4)
                op2 = "000000"
            else:
                print("Instruction not defined in ISA")
                sys.exit(1)
            
            rom_code.append(f"{str(i).rjust(3)} => B\"{opcode}_{op1}_{op2}\",  -- {line}")
            i += 1

    # Substitute labels for their respective addresses
    for i, line in enumerate(rom_code):
        for label, address in labels.items():
            code = line.split('--')[0]
            ind = code.find(label)
            if ind == -1 and code.find(label) == -1:
                continue

            if code[ind-1] == 'A':  # Absolute jump
                rom_code[i] = rom_code[i].replace('A'+label, get_twos_complement(address), 1)
            elif code[ind-1] == 'R':
                rom_code[i] = rom_code[i].replace('R'+label, get_twos_complement(address-i), 1)

    return rom_code

if __name__ == "__main__":
    # if len(sys.argv) != 2:
    #     print("Usage: python assembler.py <filename>")
    #     sys.exit(1)

    # filename = sys.argv[1]
    filename = "assembly.txt"
    rom_code = assemble(filename)

    filename = "ROM/ROM.vhd"
    with open(filename, "w") as f:
        f.write("library IEEE;\n")
        f.write("use IEEE.STD_LOGIC_1164.ALL;\n")
        f.write("use IEEE.numeric_std.ALL;\n")
        f.write("\n")
        f.write("entity ROM is\n")
        f.write("    port (\n")
        f.write("           clk      : in STD_LOGIC;\n")
        f.write("           endereco : in unsigned(6 downto 0);\n")
        f.write("           dado     : out STD_LOGIC_VECTOR(13 downto 0)\n")
        f.write("    );\n")
        f.write("end entity;\n")
        f.write("\n")
        f.write("architecture a_ROM of ROM is\n")
        f.write("    type mem is array (0 to 127) of std_logic_vector(13 downto 0); -- 128 posições de 14 bits\n")
        f.write("    constant conteudo_rom : mem := (\n")
        for line in rom_code:
            f.write(f"\t{line}\n")
        f.write("   others => (others => '0')\n")
        f.write("    );\n")
        f.write("begin\n")
        f.write("   process(clk)\n")
        f.write("   begin\n")
        f.write("       if rising_edge(clk) then\n")
        f.write("           dado <= conteudo_rom(to_integer(endereco));\n")
        f.write("       end if;\n")
        f.write("   end process;\n")
        f.write("end architecture;\n")
    