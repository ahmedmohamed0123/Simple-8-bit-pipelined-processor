module Pc (

		input wire			clk,
		input wire			rst_n,
		input wire			en,
		input wire			load,
		input wire			imm,
		input wire	[7:0]	mem,  		//M[0] incase reset & M[1]
		input wire	[7:0]	X,   		//SP
		input wire	[7:0]	Alu_out,   	// Alu_out
		input wire 	[1:0]  	targer_Sel,

		output reg	[7:0] 	Pc

	);


initial begin 
	Pc <=0;
end
	
always @(posedge clk or negedge rst_n) begin

	if (en) begin
		
		if (!load) begin
			case(targer_Sel)
              2'b00 :Pc <=mem;
              2'b10 :Pc <=X;
			  2'b11 :Pc <=Alu_out;
			  default:Pc<=Pc;
			endcase
		end
		
		else if (imm) begin
		Pc <= Pc+2;
		end
		
		else begin
		Pc <= Pc+1;
		end

	end
	
end


endmodule 