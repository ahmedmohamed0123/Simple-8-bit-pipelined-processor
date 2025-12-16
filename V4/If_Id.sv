module If_Id  (

		input wire			clk,
		input wire			rst_n,
		input wire			flush,
		input wire			stall,
		input wire 	[7:0]	Pc_pluse1_If,
		input wire 	[7:0]	instr_If,
		input wire 	[7:0]	Imm_If,

		output reg 	[7:0]	Pc_pluse1_Id,
		output reg 	[7:0]	instr_Id,
		output reg 	[7:0]	Imm_Id
);

always @(posedge clk or negedge rst_n) begin 

	if(~rst_n) begin
		Pc_pluse1_Id <= 0;
		instr_Id <= 0;
		Imm_Id <= 0;
	end
	else if (flush) begin
		Pc_pluse1_Id <= 0;
		instr_Id <= 0;
		Imm_Id <= 0;
	end
	else if (!stall) begin
		Pc_pluse1_Id <= Pc_pluse1_If;
		instr_Id <= instr_If ;
		Imm_Id <= Imm_If;
	end
	// else if stall will save data

end
endmodule