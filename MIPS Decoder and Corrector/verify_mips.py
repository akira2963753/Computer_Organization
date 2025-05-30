#!/usr/bin/env python3

import re
import sys
import os

class MIPSSimulator:
    def __init__(self):
        # Initialize registers (32 registers, each 32 bits)
        self.registers = [0] * 32
        # Data memory (we'll use a dictionary for sparse memory representation)
        self.memory = {}
        # Register $0 is hardwired to 0
        self.registers[0] = 0
        
    def load_register_file(self, filename):
        """Load initial register values from file"""
        if not os.path.exists(filename):
            print(f"Error: Register file {filename} not found.")
            return
            
        with open(filename, 'r') as f:
            lines = f.readlines()
            
        reg_index = 0
        for line in lines:
            # Skip comments and empty lines
            if line.strip() == '' or line.strip().startswith('//'):
                continue
                
            # Extract hex value (remove comments and whitespace)
            hex_value = line.split('//')[0].strip()
            hex_value = hex_value.replace('_', '')  # Remove underscores
            
            # Convert hex to int
            try:
                value = int(hex_value, 16)
                if reg_index < 32:
                    self.registers[reg_index] = value
                    reg_index += 1
            except ValueError:
                print(f"Warning: Invalid hex value in register file: {hex_value}")
                
        print(f"Loaded {reg_index} registers from {filename}")
    
    def load_data_memory(self, filename):
        """Load initial data memory values from file"""
        if not os.path.exists(filename):
            print(f"Error: Data memory file {filename} not found.")
            return
            
        with open(filename, 'r') as f:
            lines = f.readlines()
            
        addr = 0
        for line in lines:
            # Skip comments and empty lines
            if line.strip() == '' or line.strip().startswith('//'):
                continue
                
            # Extract hex value (remove comments and whitespace)
            hex_value = line.split('//')[0].strip()
            
            # Convert hex to int
            try:
                value = int(hex_value, 16)
                self.memory[addr] = value
                addr += 1
            except ValueError:
                print(f"Warning: Invalid hex value in memory file: {hex_value}")
                
        print(f"Loaded {len(self.memory)} memory locations from {filename}")
    
    def parse_register(self, reg_str):
        """Parse register string like '$R01' or '$5' to get register number"""
        if reg_str.startswith('$R'):
            return int(reg_str[2:])
        elif reg_str.startswith('$'):
            return int(reg_str[1:])
        else:
            raise ValueError(f"Invalid register format: {reg_str}")
    
    def parse_immediate(self, imm_str):
        """Parse immediate value in decimal or hex (16-bit MIPS immediate)"""
        if imm_str.startswith('0x') or imm_str.startswith('0X'):
            # Hexadecimal format
            value = int(imm_str, 16)
        else:
            # Decimal format
            value = int(imm_str)
        
        # MIPS immediate values are 16-bit signed
        # Convert to 16-bit signed representation
        if value > 32767:
            # If it's larger than 16-bit signed max, treat as unsigned and convert
            value = value & 0xFFFF
            if value > 32767:
                value = value - 65536  # Convert to signed
        elif value < -32768:
            # If it's smaller than 16-bit signed min, clamp it
            value = -32768
            
        return value
    
    def execute_instruction(self, instruction):
        """Execute a single MIPS instruction"""
        instruction = instruction.strip()
        if not instruction or instruction.startswith('//'):
            return  # Skip empty lines and comments
            
        # Remove any trailing comments
        instruction = instruction.split('//')[0].strip()
        
        # R-type instructions
        if instruction.startswith('addu'):
            # Format: addu $Rd, $Rs, $Rt
            match = re.match(r'addu\s+(\$\w+),\s*(\$\w+),\s*(\$\w+)', instruction)
            if match:
                rd, rs, rt = map(self.parse_register, match.groups())
                self.registers[rd] = (self.registers[rs] + self.registers[rt]) & 0xFFFFFFFF
                print(f"Executing: addu $R{rd:02d}, $R{rs:02d}, $R{rt:02d} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('subu'):
            # Format: subu $Rd, $Rs, $Rt
            match = re.match(r'subu\s+(\$\w+),\s*(\$\w+),\s*(\$\w+)', instruction)
            if match:
                rd, rs, rt = map(self.parse_register, match.groups())
                self.registers[rd] = (self.registers[rs] - self.registers[rt]) & 0xFFFFFFFF
                print(f"Executing: subu $R{rd:02d}, $R{rs:02d}, $R{rt:02d} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('sll'):
            # Format: sll $Rd, $Rs, Shamt
            match = re.match(r'sll\s+(\$\w+),\s*(\$\w+),\s*(\d+)', instruction)
            if match:
                rd = self.parse_register(match.group(1))
                rs = self.parse_register(match.group(2))
                shamt = int(match.group(3))
                self.registers[rd] = (self.registers[rs] << shamt) & 0xFFFFFFFF
                print(f"Executing: sll $R{rd:02d}, $R{rs:02d}, {shamt} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('or '):
            # Format: or $Rd, $Rs, $Rt
            match = re.match(r'or\s+(\$\w+),\s*(\$\w+),\s*(\$\w+)', instruction)
            if match:
                rd, rs, rt = map(self.parse_register, match.groups())
                self.registers[rd] = (self.registers[rs] | self.registers[rt]) & 0xFFFFFFFF
                print(f"Executing: or $R{rd:02d}, $R{rs:02d}, $R{rt:02d} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        # I-type instructions
        elif instruction.startswith('addiu'):
            # Format: addiu $Rd, $Rs, Imm
            match = re.match(r'addiu\s+(\$\w+),\s*(\$\w+),\s*(-?\d+|0x[0-9a-fA-F]+)', instruction)
            if match:
                rd = self.parse_register(match.group(1))
                rs = self.parse_register(match.group(2))
                imm = self.parse_immediate(match.group(3))
                # Sign extend 16-bit immediate to 32-bit for MIPS
                if imm > 32767:  # If it's treated as unsigned 16-bit but > 32767
                    imm = imm - 65536  # Convert to signed
                self.registers[rd] = (self.registers[rs] + imm) & 0xFFFFFFFF
                print(f"Executing: addiu $R{rd:02d}, $R{rs:02d}, 0x{imm & 0xFFFF:04X} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('sw'):
            # Format: sw $Rt, Imm($Rs)
            match = re.match(r'sw\s+(\$\w+),\s*(-?\d+|0x[0-9a-fA-F]+)\((\$\w+)\)', instruction)
            if match:
                rt = self.parse_register(match.group(1))
                imm_str = match.group(2)
                rs = self.parse_register(match.group(3))
                imm = self.parse_immediate(imm_str)
                addr = (self.registers[rs] + imm) & 0xFFFFFFFF
                
                # Store word (4 bytes) in big-endian format
                value = self.registers[rt]
                self.memory[addr] = (value >> 24) & 0xFF
                self.memory[addr+1] = (value >> 16) & 0xFF
                self.memory[addr+2] = (value >> 8) & 0xFF
                self.memory[addr+3] = value & 0xFF
                
                # Display the immediate in the format it was provided
                if imm_str.startswith('0x') or imm_str.startswith('0X'):
                    imm_display = f"0x{imm & 0xFFFF:04X}"
                else:
                    imm_display = str(imm)
                print(f"Executing: sw $R{rt:02d}, {imm_display}($R{rs:02d}) -> MEM[0x{addr:08X}] = 0x{value:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('lw'):
            # Format: lw $Rt, Imm($Rs)
            match = re.match(r'lw\s+(\$\w+),\s*(-?\d+|0x[0-9a-fA-F]+)\((\$\w+)\)', instruction)
            if match:
                rt = self.parse_register(match.group(1))
                imm_str = match.group(2)
                rs = self.parse_register(match.group(3))
                imm = self.parse_immediate(imm_str)
                addr = (self.registers[rs] + imm) & 0xFFFFFFFF
                
                # Load word (4 bytes) in big-endian format
                value = 0
                if addr in self.memory:
                    value |= self.memory[addr] << 24
                if addr+1 in self.memory:
                    value |= self.memory[addr+1] << 16
                if addr+2 in self.memory:
                    value |= self.memory[addr+2] << 8
                if addr+3 in self.memory:
                    value |= self.memory[addr+3]
                self.registers[rt] = value
                
                # Display the immediate in the format it was provided
                if imm_str.startswith('0x') or imm_str.startswith('0X'):
                    imm_display = f"0x{imm & 0xFFFF:04X}"
                else:
                    imm_display = str(imm)
                print(f"Executing: lw $R{rt:02d}, {imm_display}($R{rs:02d}) -> R{rt} = 0x{value:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('ori'):
            # Format: ori $Rd, $Rs, Imm
            match = re.match(r'ori\s+(\$\w+),\s*(\$\w+),\s*(0x[0-9a-fA-F]+|\d+)', instruction)
            if match:
                rd = self.parse_register(match.group(1))
                rs = self.parse_register(match.group(2))
                imm_str = match.group(3)
                imm = self.parse_immediate(imm_str)
                
                # OR with immediate (zero-extended for ori)
                imm_unsigned = imm & 0xFFFF  # Treat as unsigned 16-bit for OR operation
                self.registers[rd] = (self.registers[rs] | imm_unsigned) & 0xFFFFFFFF
                
                # Display the immediate in the format it was provided
                if imm_str.startswith('0x') or imm_str.startswith('0X'):
                    imm_display = f"0x{imm_unsigned:04X}"
                else:
                    imm_display = str(imm_unsigned)
                print(f"Executing: ori $R{rd:02d}, $R{rs:02d}, {imm_display} -> R{rd} = 0x{self.registers[rd]:08X}")
            else:
                print(f"Error parsing instruction: {instruction}")
        
        else:
            print(f"Unsupported instruction: {instruction}")
        
        # Always ensure $0 is hardwired to 0
        self.registers[0] = 0
    
    def execute_program(self, filename):
        """Execute all instructions from a file"""
        if not os.path.exists(filename):
            print(f"Error: Program file {filename} not found.")
            return
            
        with open(filename, 'r') as f:
            instructions = f.readlines()
            
        for instruction in instructions:
            self.execute_instruction(instruction)
            
        print(f"Executed {len(instructions)} instructions from {filename}")
    
    def save_register_file(self, filename):
        """Save final register values to file"""
        with open(filename, 'w') as f:
            for reg in self.registers:
                f.write(f"{reg:08x}\n")
                
        print(f"Saved register state to {filename}")
    
    def save_data_memory(self, filename):
        """Save final data memory values to file"""
        with open(filename, 'w') as f:
            # Find the highest memory address
            max_addr = max(self.memory.keys()) if self.memory else 31
            
            # Write all memory locations from 0 to max_addr
            for addr in range(max_addr + 1):
                value = self.memory.get(addr, 0xFF)  # Default to 0xFF for uninitialized memory
                f.write(f"{value:02x}\n")
                
        print(f"Saved memory state to {filename}")

def compare_files(file1, file2):
    """Compare two files line by line and return a list of differences"""
    differences = []
    
    with open(file1, 'r') as f1, open(file2, 'r') as f2:
        lines1 = [line.strip() for line in f1.readlines()]
        lines2 = [line.strip() for line in f2.readlines()]
        
    # Check for length differences
    if len(lines1) != len(lines2):
        differences.append(f"File length mismatch: {file1}={len(lines1)} lines, {file2}={len(lines2)} lines")
    
    # Compare line by line
    for i, (line1, line2) in enumerate(zip(lines1, lines2)):
        if line1 != line2:
            differences.append(f"Line {i}: {file1}='{line1}', {file2}='{line2}'")
            
    return differences

def verify_output_files(asm_file, rf_dat, dm_dat, rf_out, dm_out):
    """Run the simulator and verify the output files"""
    # Create simulator
    simulator = MIPSSimulator()
    
    # Load initial state
    simulator.load_register_file(rf_dat)
    simulator.load_data_memory(dm_dat)
    
    # Execute program
    simulator.execute_program(asm_file)
    
    # Save final state to test files
    rf_test_out = "RF_test.out"
    dm_test_out = "DM_test.out"
    simulator.save_register_file(rf_test_out)
    simulator.save_data_memory(dm_test_out)
    
    # Compare with provided output files
    rf_correct = True
    dm_correct = True
    
    # Compare register file
    rf_diff = compare_files(rf_test_out, rf_out)
    if not rf_diff:
        print("RF.out: CORRECT - Register file output matches exactly")
    else:
        print("RF.out: WRONG - Register file has the following differences:")
        for diff in rf_diff:
            print(f"  - {diff}")
        rf_correct = False
    
    # Compare data memory
    dm_diff = compare_files(dm_test_out, dm_out)
    if not dm_diff:
        print("DM.out: CORRECT - Data memory output matches exactly")
    else:
        print("DM.out: WRONG - Data memory has the following differences:")
        for diff in dm_diff:
            print(f"  - {diff}")
        dm_correct = False
    
    # Overall result
    if rf_correct and dm_correct:
        print("\nOVERALL RESULT: CORRECT - All outputs match expected values")
    else:
        print("\nOVERALL RESULT: WRONG - There are differences in the outputs")
    
    return rf_correct and dm_correct

if __name__ == "__main__":
    if len(sys.argv) != 6:
        print("Usage: python verify_mips.py <program.asm> <RF.dat> <DM.dat> <RF.out> <DM.out>")
        sys.exit(1)
        
    asm_file = sys.argv[1]
    rf_dat = sys.argv[2]
    dm_dat = sys.argv[3]
    rf_out = sys.argv[4]
    dm_out = sys.argv[5]
    
    # Check if all files exist
    missing_files = []
    for file in [asm_file, rf_dat, dm_dat, rf_out, dm_out]:
        if not os.path.exists(file):
            missing_files.append(file)
    
    if missing_files:
        print("Error: The following files were not found:")
        for file in missing_files:
            print(f"  - {file}")
        sys.exit(1)
    
    verify_output_files(asm_file, rf_dat, dm_dat, rf_out, dm_out)