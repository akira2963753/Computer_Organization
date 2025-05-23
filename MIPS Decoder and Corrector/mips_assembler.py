
#!/usr/bin/env python3

def parse_register(reg_str):
    """Parse a register string like $R01 or $R0 and return its number"""
    if reg_str.startswith('$R'):
        return int(reg_str[2:])
    return 0

def parse_immediate(imm_str):
    """Parse an immediate value that could be decimal, hex (0x...), or with leading zeros"""
    imm_str = imm_str.strip().lower()
    try:
        if imm_str.startswith('0x'):
            return int(imm_str, 16)
        return int(imm_str, 10)
    except ValueError:
        raise ValueError(f"Invalid immediate value: {imm_str}")

def assemble_mips_to_machine_code(asm_file, output_file):
    r_type_opcode = 0x00
    opcodes = {
        'addiu': 0x09,
        'sw': 0x2B,
        'lw': 0x23,
        'ori': 0x0D
    }

    function_codes = {
        'addu': 0x21,
        'subu': 0x23,
        'sll': 0x00,
        'or': 0x25
    }

    instructions = []

    with open(asm_file, 'r') as f:
        lines = [line.strip() for line in f.readlines()]

    for line in lines:
        if not line or line.startswith('#'):
            continue
        if '#' in line:
            line = line[:line.index('#')].strip()

        parts = line.split()
        if not parts:
            continue

        op = parts[0].lower()

        if op in function_codes:
            operands = ' '.join(parts[1:]).replace(' ', '').split(',')

            rd = parse_register(operands[0])
            rs = parse_register(operands[1])

            if op == 'sll':
                rt = 0
                shamt = int(operands[2])
            else:
                rt = parse_register(operands[2])
                shamt = 0

            funct = function_codes[op]
            machine_code = (r_type_opcode << 26) | (rs << 21) | (rt << 16) | (rd << 11) | (shamt << 6) | funct

        elif op in opcodes:
            opcode = opcodes[op]

            if op in ['sw', 'lw']:
                operands = ' '.join(parts[1:]).replace(' ', '').split(',')
                rt = parse_register(operands[0])

                imm_rs = operands[1]
                imm_end = imm_rs.find('(')
                rs_end = imm_rs.find(')')

                if imm_end == -1 or rs_end == -1:
                    raise ValueError(f"Invalid format for {op}: {line}")

                imm = parse_immediate(imm_rs[:imm_end])
                rs = parse_register(imm_rs[imm_end+1:rs_end])
            else:
                operands = ' '.join(parts[1:]).replace(' ', '').split(',')
                rt = parse_register(operands[0])
                rs = parse_register(operands[1])
                imm = parse_immediate(operands[2])

            imm = imm & 0xFFFF
            machine_code = (opcode << 26) | (rs << 21) | (rt << 16) | imm

        else:
            raise ValueError(f"Unsupported operation: {op}")

        instructions.append(machine_code)

    with open(output_file, 'w') as f:
        f.write("// Instruction Memory in Hex\n")

        byte_count = 0
        for instr in instructions:
            for byte_pos in range(3, -1, -1):
                byte_value = (instr >> (byte_pos * 8)) & 0xFF
                f.write(f"{byte_value:02X}\t// Addr=0x{byte_count:02X}\n")
                byte_count += 1

        while byte_count < 0x80:
            f.write(f"FF\t// Addr=0x{byte_count:02X}\n")
            byte_count += 1

def main():
    import sys

    if len(sys.argv) != 3:
        print("Usage: python mips_assembler.py input.asm output.dat")
        return

    asm_file = sys.argv[1]
    output_file = sys.argv[2]

    try:
        assemble_mips_to_machine_code(asm_file, output_file)
        print(f"Successfully assembled {asm_file} to {output_file}")
    except Exception as e:
        print(f"Error: {e}")

if __name__ == "__main__":
    main()
