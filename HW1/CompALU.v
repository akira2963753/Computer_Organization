/*
 *	Template for Homework 1
 *	Copyright (C) 2022  Chen Chia Yi or any person belong ESSLab.
 *	All Right Reserved.
 *
 *	This program is free software: you can redistribute it and/or modify
 *	it under the terms of the GNU General Public License as published by
 *	the Free Software Foundation, either version 3 of the License, or
 *	(at your option) any later version.
 *
 *	This program is distributed in the hope that it will be useful,
 *	but WITHOUT ANY WARRANTY; without even the implied warranty of
 *	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *	GNU General Public License for more details.
 *
 *	You should have received a copy of the GNU General Public License
 *	along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 *	This file is for people who have taken the cource (1102 Computer
 *	Organizarion) to use.
 *	We (ESSLab) are not responsible for any illegal use.
 *
 */

/*
 * Declaration of top entry for this project.
 * CAUTION: DONT MODIFY THE NAME AND I/O DECLARATION.
 */
module CompALU(
	//	Inputs
	Instruction,
	//	Outputs
	CompALU_out,
	CompALU_zero,
	CompALU_carry
);
	input [31:0] Instruction;  //31-26 25-21 20-16 15-11 10-6 5-0 
    	output [31:0] CompALU_out;
    	output CompALU_zero;
    	output CompALU_carry;
	
	wire [31:0] Src_1,Src_2;
    	RF Register_File(Instruction[25:21],Instruction[20:16],Src_1,Src_2);
    	ALU Arithmetic_Logical_Unit(Src_1,Src_2,Instruction[10:6],Instruction[5:0],CompALU_out,CompALU_zero,CompALU_carry);
endmodule
