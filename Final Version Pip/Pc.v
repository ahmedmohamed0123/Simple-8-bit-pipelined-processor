//PC reset is handled by control logic, not hardcoded.

module Pc (

		input wire			clk,
		input wire			rst,
		input wire			interrupt,
		input wire			en,            //Enable Pc update
		input wire			load,          //E_Load to choose between loading Pc from immediate or incrementing Pc ( 0 -> load , 1 -> increment)
		input wire			imm,           //E_Imm to choose between Pc+1 or Pc+2 (0 -> Pc+1 , 1 -> Pc+2)
		input wire	[7:0]	M_0,  		   // M[1 or 0] in case interrupt or reset
		input wire	[7:0]	X,   		   // SP
		input wire	[7:0]	rb,   	       
		input wire 	[1:0]  	targer_Sel,    // Select immediate Target (00 -> M0 , 01 -> M1 , 10 -> X , 11 -> rb)
        input wire 			stall,
		output reg	[7:0] 	Pc

	);


always @(posedge clk ) begin

	if (!rst || interrupt) begin
		Pc <=M_0;
	end

	else if (en && !stall) begin
		
		if (!load) begin
			case(targer_Sel)
              2'b10 :Pc <=X;
			  2'b11 :Pc <=rb;
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