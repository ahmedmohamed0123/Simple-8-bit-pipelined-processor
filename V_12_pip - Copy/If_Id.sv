module If_Id  (

		input wire			clk,
		input wire			interrupt,
		input wire			stall,
		input wire 	[7:0]	Pc_pluse1_If,
		input wire 	[7:0]	instr_If,
		input wire 	[7:0]	Imm_If,
		input wire 	[7:0]    input_port_If,

		output reg			interrupt_Id,
		output reg 	[7:0]	Pc_pluse1_Id,
		output reg 	[7:0]	instr_Id,
		output reg 	[7:0]	Imm_Id,
		output reg 	[7:0]  	input_port_Id
);

always @(posedge clk ) begin 

	
	if (!stall) begin
		interrupt_Id <= interrupt;
		Pc_pluse1_Id <= Pc_pluse1_If;
		instr_Id <= instr_If ;
		Imm_Id <= Imm_If;
		input_port_Id <= input_port_If;
	end
	// else if stall will save data

end
endmodule