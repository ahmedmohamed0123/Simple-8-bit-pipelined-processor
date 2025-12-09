// any S means Selection line to mux 
// any E means Enable 


module Control_Unit (

		input wire 	[7:0]	Opcode,
		input wire 	[3:0]	CCR, 
az
		
		// pc control signals 
		output reg	[1:0]	S_Target, 	// to choose the target into pc
		output reg			E_Pc,		// change pc or not
		output reg			E_Imm,		// increment pc 1 or 2
		output reg			load,		// Load target or increment

		// Register file control signals
		output reg			w_E_R,		// Write enable for Reg file
		output reg			IncSp,		// enable for increment sp in Reg file
		output reg			DecSp,		// enable for Decrement sp in Reg file
		output reg			w_Add_S_R,	// Write address selection for aReg file
		output reg	[2:0]	w_Data_S_R,	// Write Data selection for aReg file

		// Alu control signals
		output reg 	[3:0]	Alu_Op,    	// Alu opcode
		output reg			SaveFlags,	// save flages in [7:4] if interupt came
		output reg			returnF,    // returen flags

		// Data memory control signals
		output reg			w_E_M,		// Write enable for Data memory
		output reg			w_Add_S_M,	// Write address selection for Data memory
		output reg			w_Data_S_M,	// Write Data selection for Data memory
 
		output reg			Out_E		// Enable for Output port
	);


always @(*)	begin
	
	// pc control signals 
			S_Taeget	=2'b00;
			E_Pc	=1'b0;	
			E_Imm	=1'b0;		
			load	=1'b0;

	// Register file control signals
			w_E_R	=1'b0;		
			w_Add_S_R	=1'b0;	
			w_Data_S_R	=2'b00;	

	// Alu control signals
			Alu_Op	=3'b000;

	// Data memory control signals
			w_E_M	=1'b0;
			w_Add_S_M	=1'b0;
			w_Data_S_M	=1'b0;

			Out_E	=1'b0;

		case (Opcode[7:4])

			4'h0: begin                    //NOP

			// pc control signals 	
					E_Pc	=1'b1;		
					E_Imm	=1'b0;		
					load	=1'b0;

			end

			4'h1: begin                    //MOV

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'h2: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'h3: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'h4: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'h5: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'h6: begin

				case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'h7: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'h8: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'h9: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'hA: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'hB: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'hC: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h1: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h2: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end

					2'h3: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	=2'b00;	

					// Alu control signals
							Alu_Op	=3'b000;

					// Data memory control signals
							w_E_M	=1'b0;
							w_Add_S_M	=1'b0;
							w_Data_S_M	=1'b0;

							Out_E	=1'b0;


					end
				
				endcase

			end

			4'hD: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end

			4'hE: begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'b0;

			end			

			default : begin

			// pc control signals 
					S_Taeget	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;

			// Register file control signals
					w_E_R	=1'b0;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	=2'b00;	

			// Alu control signals
					Alu_Op	=3'b000;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'sb0;
			end

		endcase
		
end


endmodule