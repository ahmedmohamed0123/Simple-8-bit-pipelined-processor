// any S means Selection line to mux 
// any E means Enable 


module Control_Unit (

		input wire 	[7:0]	Opcode,
		input wire 	[3:0]	CCR,
		
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
			w_Data_S_R	= 3'h0;	

	// Alu control signals
			Alu_Op	= 4'h0;

	// Data memory control signals
			w_E_M	=1'b0;
			w_Add_S_M	=1'b0;
			w_Data_S_M	=1'b0;

			Out_E	=1'b0;

		case (Opcode[7:4])

			4'h0: begin                    //NOP

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;          // Enable PC update		
					E_Imm	= 1'b0;		     // Increment by 1
					load	= 1'b1;          // Increment

			end

			4'h1: begin                    //MOV

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write

			// Alu control signals
					Alu_Op	= 4'h0;      // Pass B to output

			end

			4'h2: begin                    //ADD

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h1;         // Addition

			end

			4'h3: begin                     //SUB

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h2;         // Subtraction

			end

			4'h4: begin                     //AND

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h3;         // AND

			end

			4'h5: begin                     //OR

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h4;         // OR

			end

			4'h6: begin

				case (Opcode[3:2])         // Depending on ra value

					2'h0: begin            //RLC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

					// Alu control signals
						Alu_Op	= 4'h5;         // Rotate Left with Carry (RLC)

					end

					2'h1: begin                 // RRC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

					// Alu control signals
						Alu_Op	= 4'h6;         // Rotate Right with Carry (RRC)

					end

					2'h2: begin                  // SETC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Alu control signals
						Alu_Op	= 4'h7;         // SETC

					end

					2'h3: begin                // CLRC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Alu control signals
						Alu_Op	= 4'h8;         // CLRC

					end
				
				endcase

			end

			4'h7: begin

			case (Opcode[3:2])                  // Depending on ra value

					2'h0: begin

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
							w_E_R	=1'b0;		
							w_Add_S_R	=1'b0;	
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
					w_Data_S_R	= 3'h0;	

			// Alu control signals
					Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
							w_Data_S_R	= 3'h0;	

					// Alu control signals
							Alu_Op	= 4'h0;

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
					w_Data_S_R	= 3'h0;	

			// Alu control signals
					Alu_Op	= 4'h0;

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
					w_Data_S_R	= 3'h0;	

			// Alu control signals
					Alu_Op	= 4'h0;

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
					w_Data_S_R	= 3'h0;	

			// Alu control signals
					Alu_Op	= 4'h0;

			// Data memory control signals
					w_E_M	=1'b0;
					w_Add_S_M	=1'b0;
					w_Data_S_M	=1'b0;

					Out_E	=1'sb0;
			end

		endcase
		
end


endmodule