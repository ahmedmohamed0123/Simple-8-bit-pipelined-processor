// any S means Selection line to mux 
// any E means Enable 


Control_Unit module (

		input wire			clk,
		input wire			rst_n,
		input wire 	[7:0]	Opcode,
		input wire 	[7:0]	Imm,
		input wire 	[3:0]	CCR, 

		output reg 	[3:0]	Alu_Op,
		output reg 	[3:0]	W_address,
		output reg			S_Wdata,
		output reg			E_Out,
		output reg	[1:0]	S_Pc,

 

	);


always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		// reset
		
	end
	else  begin

		case (Opcode[7:4])

			4'h0: begin

			end

			4'h1: begin

			end

			4'h2: begin

			end

			4'h3: begin

			end

			4'h4: begin

			end

			4'h5: begin

			end

			4'h6: begin

			end

			4'h7: begin

			end

			4'h8: begin

			end

			4'h9: begin

			end

			4'hA: begin

			end

			4'hB: begin

			end

			4'hC: begin

			end

			4'hD: begin

			end

			4'hE: begin

			end			

			default : /* default */;
		endcase
		
	end
end


endmodule