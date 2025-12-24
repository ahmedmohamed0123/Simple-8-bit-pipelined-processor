module Id_Ex  (

		input wire				clk,

		// hazard unit wires
		input wire  [7:0] instruction_Id , 
		

		// register file control signals
		input wire 				w_E_R_Id,		// Write enable for reg  file
		input wire 				w_Add_S_R_Id,	// Write address selection for reg  file   (0: ra, 1: rb)
		input wire 		[2:0]	w_Data_S_R_Id,	// Write Data selection for reg  file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		input wire  	[3:0]	Alu_Op_Id,    	// Alu opcode
		input wire 				SaveFlags_Id,	// save flages in [7:4] if interupt came
		input wire 				returnF_Id,    // returen flags

		// Data memory control signals
		input wire 				w_E_M_Id,		// Write enable for Data memory
		input wire 				w_SP_Id,		// Write enable for Data memory in stack
		input wire       		W_Z_Id,         // read m[0]
    	input wire       		W_O_Id,         // read m[1]
		input wire 				w_Add_S_M_Id,	// Write address selection for Data memory    (0: IMM, 1: ALU out)
		input wire 				w_Data_S_M_Id,	// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
    	input wire       		w_data_S_M_rb_Id, // Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		
		input wire 				Out_E_Id,		// Enable for output port

		input wire 		[7:0]	Pc_pluse1_Id,
		input wire 		[7:0]	Imm_Id,

		input wire 		[1:0]	ra_Id,
		input wire 		[1:0]	rb_Id,

		input wire 		[7:0]	R_ra_Id,
		input wire 		[7:0]	R_rb_Id,
		input wire 		[7:0]	Sp_Id,
		input wire      [7:0]  input_port_Id,
        


		// Register file control signals
		output reg				w_E_R_Ex,		// Write enable for Reg file
		output reg				w_Add_S_R_Ex,	// Write address selection for Reg file   (0: ra, 1: rb)
		output reg	[2:0]		w_Data_S_R_Ex,	// Write Data selection for Reg file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		output reg 	[3:0]		Alu_Op_Ex,    	// Alu opcode
		output reg				SaveFlags_Ex,	// save flages in [7:4] if interupt came
		output reg				returnF_Ex,    // returen flags

		// Data memory control signals
		output reg				w_E_M_Ex,		// Write enable for Data memory
		output reg				w_SP_Ex,		// Write enable for Data memory in stack
		output reg      		W_Z_Ex,         // read m[0]
    	output reg      		W_O_Ex,         // read m[1]
		output reg				w_Add_S_M_Ex,	// Write address selection for Data memory    (0: IMM, 1: ALU out)
		output reg				w_Data_S_M_Ex,	// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
    	output reg      		w_data_S_M_rb_Ex, // Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		output reg				Out_E_Ex,		// Enable for Output port

		output reg 		[7:0]	Pc_pluse1_Ex,
		output reg 		[7:0]	Imm_Ex,

		output reg 		[1:0]	ra_Ex,
		output reg 		[1:0]	rb_Ex,

		output reg 		[7:0]	R_ra_Ex,
		output reg 		[7:0]	R_rb_Ex,
		output reg 		[7:0]	Sp_Ex,
		output reg 		[7:0]  input_port_Ex,
		output reg      [7:0]  instruction_Ex
);

always @(posedge clk ) begin 



		w_E_R_Ex         <= w_E_R_Id;
		w_Add_S_R_Ex     <= w_Add_S_R_Id;
		w_Data_S_R_Ex    <= w_Data_S_R_Id;
		Alu_Op_Ex        <= Alu_Op_Id;
		SaveFlags_Ex     <= SaveFlags_Id;
		returnF_Ex       <= returnF_Id;
		w_E_M_Ex         <= w_E_M_Id;
		w_SP_Ex          <= w_SP_Id;
		W_Z_Ex           <= W_Z_Id;
		W_O_Ex           <= W_O_Id;
		w_Add_S_M_Ex     <= w_Add_S_M_Id;
		w_Data_S_M_Ex    <= w_Data_S_M_Id;
		w_data_S_M_rb_Ex <= w_data_S_M_rb_Id;
		Out_E_Ex         <= Out_E_Id;
		Pc_pluse1_Ex     <= Pc_pluse1_Id;
		Imm_Ex           <= Imm_Id;
		ra_Ex            <= ra_Id;
		rb_Ex            <= rb_Id;
		R_ra_Ex          <= R_ra_Id;
		R_rb_Ex          <= R_rb_Id;
		Sp_Ex            <= Sp_Id; 
		input_port_Ex <= input_port_Id;
		instruction_Ex<=instruction_Id;
	// else if stall will save data

end
endmodule