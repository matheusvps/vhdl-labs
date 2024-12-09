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
    "BLT" : "1110",
    "JMP": "1111"
}

COMMENT_CHAR = '#'

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
                op2 = bin(int(operand2))[2:].zfill(6)

            elif instruction in ["JMP", "BEQ", "BLT"]:  # INSTRUCTIONS WITH LABEL
                op1 = space_split[1].strip()
                op2 = "000"
            
            elif instruction in ["ADD", "SUB", "OR", "MULT"]: # INSTRUCTIONS WITH ONLY 1 REGISTER
                operand1 = operands[1].strip()
                op1 = bin(int(operand1.split('R')[1]))[2:].zfill(4)
                op2 = "000000"
            
            elif instruction in ["LW", "SW"]: # INSTRUCTIONS WITH MEMORY ACCESS
                print("Can't handle memory instructions yet")
            
            elif instruction in ["ZAC", "NOP"]: # INSTRUCTIONS WITHOUT OPERANDS
                op1 = "0000"
                op2 = "000000"
            
            elif instruction in ["MOV", "CMP"]: # INSTRUCTIONS WITH 2 OPERANDS
                # MODIFICAR POIS POR AGORA SÓ LIDA COM ACUMULADOR->REGISTRADOR
                operand1 = operands[0].strip()
                op1 = bin(int(operand1.split('R')[1]))[2:].zfill(4)
                op2 = "1111"
                op2 = op2 + "00"
            
            else:
                print("Instruction not defined in ISA")
                sys.exit(1)
            
            rom_code.append(f"{str(i).rjust(3)} => B\"{opcode}_{op1}_{op2}\",  -- {line}")
            i += 1

    # Substitute labels for their respective addresses
    for i, line in enumerate(rom_code):
        for label, address in labels.items():
            if label in line.split('--')[0]:
                rom_code[i] = rom_code[i].replace(label, bin(int(address))[2:].zfill(7))

    return rom_code

'''
0  => B"0110_0011_0001_01",  -- LD R3, 5 (A)                         
1  => B"0110_0100_0010_00",  -- LD R4, 8 (B)
2  => B"1100_0000_0000_00",  -- ZAC (zera o acumulador)                         
3  => B"0001_0011_0000_00",  -- ADD ACC, R3 (C)                      
4  => B"0001_0100_0000_00",  -- ADD ACC, R4 (C)                      
5  => B"0110_0010_0000_01",  -- LD R2, 1 (D)                         
6  => B"0011_0010_0000_00",  -- SUB ACC, R2 (D)                      
7  => B"1111_0010_1000_00",  -- JMP 20 (E)                           
8  => B"0110_0101_0000_00",  -- LD R5, 0 (F) [não executada]        
20 => B"1010_0011_1111_00",  -- MOV R3, ACC (G)                     
21 => B"1111_0000_0100_00",  -- JMP 2 (H)
22 => B"0110_0011_0000_00",  -- LD R3, 0 (I) [não executada]       
'''

if __name__ == "__main__":
    # if len(sys.argv) != 2:
    #     print("Usage: python assembler.py <filename>")
    #     sys.exit(1)

    # filename = sys.argv[1]
    filename = "ROM\\assembly.txt"
    print('Assembling file:', filename)
    rom_code = assemble(filename)
    for line in rom_code:
        print(line)
    