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
        """Parse immediate value in decimal or hex"""
        if imm_str.startswith('0x') or imm_str.startswith('0X'):
            return int(imm_str, 16)
        else:
            return int(imm_str)
    
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
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('subu'):
            # Format: subu $Rd, $Rs, $Rt
            match = re.match(r'subu\s+(\$\w+),\s*(\$\w+),\s*(\$\w+)', instruction)
            if match:
                rd, rs, rt = map(self.parse_register, match.groups())
                self.registers[rd] = (self.registers[rs] - self.registers[rt]) & 0xFFFFFFFF
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
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('or '):
            # Format: or $Rd, $Rs, $Rt
            match = re.match(r'or\s+(\$\w+),\s*(\$\w+),\s*(\$\w+)', instruction)
            if match:
                rd, rs, rt = map(self.parse_register, match.groups())
                self.registers[rd] = (self.registers[rs] | self.registers[rt]) & 0xFFFFFFFF
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
                self.registers[rd] = (self.registers[rs] + imm) & 0xFFFFFFFF
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('sw'):
            # Format: sw $Rt, Imm($Rs)
            match = re.match(r'sw\s+(\$\w+),\s*(-?\d+|0x[0-9a-fA-F]+)\((\$\w+)\)', instruction)
            if match:
                rt = self.parse_register(match.group(1))
                imm = self.parse_immediate(match.group(2))
                rs = self.parse_register(match.group(3))
                addr = (self.registers[rs] + imm) & 0xFFFFFFFF
                
                # Store word (4 bytes) in big-endian format
                value = self.registers[rt]
                self.memory[addr] = (value >> 24) & 0xFF
                self.memory[addr+1] = (value >> 16) & 0xFF
                self.memory[addr+2] = (value >> 8) & 0xFF
                self.memory[addr+3] = value & 0xFF
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('lw'):
            # Format: lw $Rt, Imm($Rs)
            match = re.match(r'lw\s+(\$\w+),\s*(-?\d+|0x[0-9a-fA-F]+)\((\$\w+)\)', instruction)
            if match:
                rt = self.parse_register(match.group(1))
                imm = self.parse_immediate(match.group(2))
                rs = self.parse_register(match.group(3))
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
            else:
                print(f"Error parsing instruction: {instruction}")
                
        elif instruction.startswith('ori'):
            # Format: ori $Rd, $Rs, Imm
            match = re.match(r'ori\s+(\$\w+),\s*(\$\w+),\s*(0x[0-9a-fA-F]+|\d+)', instruction)
            if match:
                rd = self.parse_register(match.group(1))
                rs = self.parse_register(match.group(2))
                imm = self.parse_immediate(match.group(3))
                self.registers[rd] = (self.registers[rs] | imm) & 0xFFFFFFFF
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

def main():
    if len(sys.argv) < 4:
        print("Usage: python mips_simulator.py <program.asm> <RF.dat> <DM.dat> [RF.out] [DM.out]")
        print("If RF.out and DM.out are provided, the simulation results will be compared with these files")
        return
        
    program_file = sys.argv[1]
    rf_dat_file = sys.argv[2]
    dm_dat_file = sys.argv[3]
    
    # Optional comparison files
    rf_out_file = sys.argv[4] if len(sys.argv) > 4 else None
    dm_out_file = sys.argv[5] if len(sys.argv) > 5 else None
    
    # Create simulator
    simulator = MIPSSimulator()
    
    # Load initial state
    simulator.load_register_file(rf_dat_file)
    simulator.load_data_memory(dm_dat_file)
    
    # Execute program
    simulator.execute_program(program_file)
    
    # Save final state to test files
    simulator.save_register_file("RF_test.out")
    simulator.save_data_memory("DM_test.out")
    
    # Compare with provided output files if available
    if rf_out_file:
        rf_diff = compare_files("RF_test.out", rf_out_file)
        if not rf_diff:
            print("RF.out: CORRECT - Register file output matches exactly")
        else:
            print("RF.out: WRONG - Register file has the following differences:")
            for diff in rf_diff:
                print(f"  - {diff}")
    
    if dm_out_file:
        dm_diff = compare_files("DM_test.out", dm_out_file)
        if not dm_diff:
            print("DM.out: CORRECT - Data memory output matches exactly")
        else:
            print("DM.out: WRONG - Data memory has the following differences:")
            for diff in dm_diff:
                print(f"  - {diff}")

if __name__ == "__main__":
    main()