module Pc (

		input wire			clk,
		input wire			rst_n,
		input wire			en,
		input wire			load,
		input wire			imm,
		input wire	[7:0]	Target,
		input wire	[7:0]	M0,  //M[0] incase reset
		input wire	[7:0]	M1,  //M[1] incase interrupt
		input wire	[7:0]	X,   //SP
		input wire	[7:0]	B,   // R(b)
		input wire [1:0]  targer_Sel,

		output reg	[7:0] 	Pc

	);


always @(posedge clk or negedge rst_n) begin

	if(~rst_n) begin
		Pc <= 0;
	end 

	else if (en) begin

		if (!load) begin
			case(targer_Sel)
              2'b00 :Target=M0;
              2'b01 :Target=M1;
              2'b10: Target=X;
			  2'b11 :Target=B;

			endcase
		Pc <= Target;
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