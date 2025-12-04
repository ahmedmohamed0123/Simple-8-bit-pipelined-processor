module Pc (

		input wire			clk,
		input wire			rst_n,
		input wire			en,
		input wire			load,
		input wire			imm,
		input wire	[7:0]	Target,
		output reg	[7:0] 	Pc

	);


always @(posedge clk or negedge rst_n) begin
	if(~rst_n) begin
		Pc <= 0;
	end 
	else if (en) begin

		else if (load) begin
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