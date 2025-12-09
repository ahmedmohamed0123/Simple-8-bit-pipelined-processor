// any S means Selection line to mux 
// any E means Enable (0: disable, 1: enable)

module Control_Unit (

		input wire 	[7:0]	Opcode,
		input wire 	[3:0]	CCR,
		
		// pc control signals 
		output reg	[1:0]	S_Target, 	// to choose the target into pc ( 0: M[0], 1: M[1], 2: X[SP], 3: R[rb] )
		output reg			E_Pc,		// change pc or not             
		output reg			E_Imm,		// increment pc 1 or 2          (0: increment 1, 1: increment 2 )
		output reg			load,		// Load target or increment     (0: load target, 1: increment )

		// Register file control signals
		output reg			w_E_R,		// Write enable for Reg file
		output reg			IncSp,		// enable for increment sp in Reg file
		output reg			DecSp,		// enable for Decrement sp in Reg file
		output reg			w_Add_S_R,	// Write address selection for Reg file   (0: ra, 1: rb)
		output reg	[2:0]	w_Data_S_R,	// Write Data selection for Reg file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		output reg 	[3:0]	Alu_Op,    	// Alu opcode
		output reg			SaveFlags,	// save flages in [7:4] if interupt came
		output reg			returnF,    // returen flags

		// Data memory control signals
		output reg			w_E_M,		// Write enable for Data memory
		output reg			w_SP,		// Write enable for Data memory in stack
		output reg			w_Add_S_M,	// Write address selection for Data memory    (0: IMM, 1: ALU out)
		output reg			w_Data_S_M,	// Write Data selection for Data memory       (0: ALU out, 1: PC+1)
 
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
			w_SP		=1'b0;

			Out_E	=1'b0;

		case (Opcode[7:4])
		
/*------------------------------------- A-Format -------------------------------------*/

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

					2'h0: begin                 // PUSH

					// PC control signals   (PC = PC + 1)	
							E_Pc	= 1'b1;         // Enable PC update		
							E_Imm	= 1'b0;		    // Increment by 1
							load	= 1'b1;         // Increment

					// Register file control signals
							DecSp 	= 1'b1  // decrement sp before using it

					// Alu control signals
							Alu_Op	= 4'h0;     // Pass B to output

					// Data memory control signals
							w_E_M	= 1'b0;     // don't use adderss 
							w_Add_S_M	= 1'b0;	// don't care
							w_Data_S_M	= 1'b0; // Alu output
							w_SP		= 1'b1;	// using sp ass adderss

					end

					2'h1: begin              // POP

					// PC control signals   (PC = PC + 1)	
							E_Pc	= 1'b1;         // Enable PC update		
							E_Imm	= 1'b0;		    // Increment by 1
							load	= 1'b1;         // Increment

					// Register file control signals
							w_E_R	=1'b1;			// write in rf
							w_Add_S_R	=1'b1;		// write in rb as address
							w_Data_S_R	= 3'h2;		// write drom stack
							IncSp 	= 1'b1  		// Increment sp before using it

					// Alu control signals
							Alu_Op	= 4'h0;

					// Data memory control signals
							w_E_M	=1'b0;  		// don't care
							w_Add_S_M	=1'b0;		// don't care
							w_Data_S_M	=1'b0;		// don't care
							

							Out_E	=1'b0;

					end

					2'h2: begin            // OUT

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Alu control signals
							Alu_Op	= 4'h0;     // Pass B to output

							Out_E	=1'b1;      // Enable output port


					end

					2'h3: begin           // IN

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h3;	    // Select INPUT port as data to write		

					end
				
				endcase

			end

			4'h8: begin

			case (Opcode[3:2])                   // Depending on ra value

					2'h0: begin                  // NOT

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'h9;     // NOT

					end

					2'h1: begin                 // NEG

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'hA;     // NEG

					end

					2'h2: begin                 // INC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'hB;     // INC

					end

					2'h3: begin                 // DEC

					// PC control signals   (PC = PC + 1)	
						E_Pc	= 1'b1;         // Enable PC update		
						E_Imm	= 1'b0;		    // Increment by 1
						load	= 1'b1;         // Increment

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'hC;     // DEC

					end
				
				endcase

			end

/*------------------------------------- B-Format -------------------------------------*/

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

/*------------------------------------- L-Format -------------------------------------*/

			4'hC: begin

			case (Opcode[3:2])

					2'h0: begin

					// pc control signals 
							S_Taeget	=2'b00;
							E_Pc	=1'b1;	
							E_Imm	=1'b1;		
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

