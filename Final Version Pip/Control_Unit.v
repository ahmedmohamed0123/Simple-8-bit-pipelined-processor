// any S means Selection line to mux 
// any E means Enable (0: disable, 1: enable)

module Control_Unit (

		input wire 	[7:0]	    Opcode,
		input wire 	[3:0]	    CCR,
		input wire				interrupt,

		// Register file control signals
		output reg				w_E_R,		    // Write enable for Reg file
		output reg				IncSp,		    // enable for increment sp in Reg file
		output reg				DecSp,		    // enable for Decrement sp in Reg file
		output reg				w_Add_S_R,	    // Write address selection for Reg file   (0: ra, 1: rb)
		output reg	[2:0]	    w_Data_S_R,	    // Write Data selection for Reg file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		output reg 	[3:0]	    Alu_Op,    	    // Alu opcode
		output reg				SaveFlags,	    // save flages in [7:4] if interupt came
		output reg				returnF,        // returen flags

		// Data memory control signals
		output reg				w_E_M,		    // Write enable for Data memory
		output reg				w_SP,		    // Write enable for Data memory in stack
		output reg				w_Add_S_M,	    // Write address selection for Data memory    (0: IMM, 1: ALU out)
		output reg				w_Data_S_M,	    // Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
        output reg      	    w_data_S_M_rb,  // Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		
		output reg				Out_E		    // Enable for Output port
	);


always @(*)	begin

	// Register file control signals
			w_E_R	=1'b0;		
			w_Add_S_R	=1'b0;	
			w_Data_S_R	= 3'h0;	
			IncSp = 1'b0;
			DecSp = 1'b0;

	// Alu control signals
			Alu_Op	= 4'h0;
			SaveFlags =0;
			returnF =0;

	// Data memory control signals
			w_E_M	=1'b0;
			w_Add_S_M	=1'b0;
			w_Data_S_M	=1'b0;
			w_data_S_M_rb=0;
			w_SP=1'b0;
			Out_E	=1'b0;
			

			if(interrupt) begin    //(M[1] -> pc)

				// Register file control signals 
					DecSp 	= 1'b1; // to decrement sp 

				// Data memory control signals
					
					w_SP=1'b1;                 // to write pc in stack 
					w_Data_S_M=1'b1; // to  store pc+1 incase of interrupt 


				// Alu control signals
					SaveFlags = 1'b1;          // Save flags in CCR[7:4]
			end

      	else begin


		case (Opcode[7:4])
		
/*------------------------------------- A-Format -------------------------------------*/

			4'h1: begin                    //MOV

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write

			// Alu control signals
					Alu_Op	= 4'h0;      // Pass B to output

			end

			4'h2: begin                    //ADD

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h1;         // Addition

			end

			4'h3: begin                     //SUB

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h2;         // Subtraction

			end

			4'h4: begin                     //AND

			// Register file control signals
					w_E_R	    = 1'b1;     // Enable write to Reg file		
					w_Add_S_R	= 1'b0;	    // Select Ra address from instruction
					w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

			// Alu control signals
					Alu_Op	= 4'h3;         // AND

			end

			4'h5: begin                     //OR

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

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

					// Alu control signals
						Alu_Op	= 4'h5;         // Rotate Left with Carry (RLC)

					end

					2'h1: begin                 // RRC

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write	

					// Alu control signals
						Alu_Op	= 4'h6;         // Rotate Right with Carry (RRC)

					end

					2'h2: begin                  // SETC

					// Alu control signals
						Alu_Op	= 4'h7;         // SETC

					end

					2'h3: begin                // CLRC

					// Alu control signals
						Alu_Op	= 4'h8;         // CLRC

					end
				
				endcase

			end

			4'h7: begin

			case (Opcode[3:2])                  // Depending on ra value

					2'h0: begin                 // PUSH

					// Register file control signals
							DecSp 	= 1'b1;  // decrement sp before using it

					// Alu control signals
							Alu_Op	= 4'h0;     // Pass B to output

					// Data memory control signals
							w_E_M	= 1'b1;
							w_SP=1'b1;
							w_Data_S_M	= 1'b0;
							w_data_S_M_rb=1'b0;

					end

					2'h1: begin              // POP

					// Register file control signals
							w_Add_S_R	=1'b1;		// write in rb as address
							w_Data_S_R	= 3'h2;		// write drom stack
							IncSp 	= 1'b1; 		// Increment sp before using it
                    // Register file control signals
						w_SP=1'b0;	    // Select Rb address from instruction
						w_E_R	    = 1'b1;
					end

					2'h2: begin            // OUT

					// Alu control signals
							Alu_Op	= 4'h0;     // Pass B to output

							Out_E	=1'b1;      // Enable output port


					end

					2'h3: begin           // IN

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

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'h9;     // NOT

					end

					2'h1: begin                 // NEG

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'hA;     // NEG

					end

					2'h2: begin                 // INC

					// Register file control signals
						w_E_R	    = 1'b1;     // Enable write to Reg file		
						w_Add_S_R	= 1'b1;	    // Select Rb address from instruction
						w_Data_S_R	= 3'h1;	    // Select ALU output as data to write		

					// Alu control signals
							Alu_Op	= 4'hB;     // INC

					end

					2'h3: begin                 // DEC

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

					2'h0: begin      //JZ
                        	if(CCR[0]==1'b1) begin   
						  		Alu_Op	= 4'h0; // to pass R[rb]
							end
						end

					2'h1: begin       //JN
                        	if(CCR[1]==1'b1) begin
								Alu_Op	= 4'h0; // to pass R[rb]
							end
						end

					2'h2: begin            //JC
							if(CCR[2]==1'b1) begin
								Alu_Op	= 4'h0; // to pass R[rb]
							end
					end

					2'h3: begin              //JV
                          if(CCR[3]==1'b1) begin
								Alu_Op	= 4'h0; // to pass R[rb]
							end
					end
				
				endcase

			end
 
			4'hA: begin    //LOOP
 
                    // ra-1
					Alu_Op	= 4'b1101;     

                   // ra<--alu_output
					w_E_R	=1'b1;		
					w_Add_S_R	=1'b0;	
					w_Data_S_R	= 3'h1;

			end

			4'hB: begin               

			case (Opcode[3:2])

					2'h0: begin    //JUMP
                    
					 Alu_Op	= 4'h0; // to pass R[rb]

					end

					2'h1: begin       //CALL

					   //    pc<--( pc+1)
						//	E_Pc	=1'b1;	
						//	E_Imm	=1'b0;		
						//	load	=1'b1;
                             
						 //   sp<--(pc+1)
						//w_E_M	=1'bx;
						//w_Add_S_M	=1'b0;
						w_Data_S_M	=1'b1;
                        w_SP =1'b1;
							
                         DecSp =1'b1;    // sp=sp-1
						 Alu_Op	= 4'h0; // to pass R[rb]

					end

					2'h2: begin        //RET

					// sp=sp+1
                            IncSp=1'b1;
				     
					end

					2'h3: begin            //RTI

					//     sp=sp+1
                            IncSp=1'b1;

					  //    restore flag
                            returnF =1'b1;
					end
				
				endcase

			end


/*------------------------------------- L-Format -------------------------------------*/

			4'hC: begin //(pc+2->pc)

			case (Opcode[3:2]) // select depending on ra

					2'h0: begin //LDM (R[rb] ← imm)

					// Register file control signals
							w_E_R	=1'b1;		 // to write imm in R[rb] 
							w_Add_S_R	=1'b1;	 // to select rb
							w_Data_S_R	= 3'h4;	 // to select imm

					end

					2'h1: begin //LDD (R[rb] ← M[ea])

					// Register file control signals
							w_E_R	=1'b1;		 // to write imm in R[rb] 
							w_Add_S_R	=1'b1;	 // to select rb
							w_Data_S_R	= 3'h0;	 // to select memory output

					// Data memory control signals
							w_E_M	=1'b0; //we will read from memory
							w_Add_S_M	=1'b0; // select effective adderess(imm)

					end

					2'h2: begin //STD ( M[ea] ← R[rb])

					// Register file control signals
							w_E_R	=1'b0;		// read from register
							w_Add_S_R	=1'b0;	// we don't use it

					// Alu control signals
							Alu_Op	= 4'h0; // to pass R[rb]

					// Data memory control signals
							w_E_M	=1'b1; // to write in memory
							w_Add_S_M	=1'b0;  // to choose effective address (imm)
							w_Data_S_M	=1'b0; // to choose R[rb] data from alu out
					end

					default: begin

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

					end
				
				endcase

			end

			4'hD: begin //LDI(R[rb] ← M[R[ra]])

			// Register file control signals
					w_E_R	=1'b1;		// write in reg file
					w_Add_S_R	=1'b1;	// write in rb
					w_Data_S_R	= 3'h0;	 // data from memory output

			// Alu control signals
					Alu_Op	= 4'hE; // pass R[ra]

			// Data memory control signals
					w_E_M	=1'b0; // read from memory 
					w_Add_S_M	=1'b1;  // choose alu_out
					w_Data_S_M	=1'b0; // we don't use it

					

			end

			4'hE: begin    // STI (M[R[ra]] ←R[rb])

			// Register file control signals
					w_E_R	=1'b0;	 // read from reg file	
					w_Add_S_R	=1'b1;	// we don't use it
					w_Data_S_R	= 3'h0;	 // we don't use it
			// Alu control signals
					Alu_Op	= 4'hE; // pass R[ra]

			// Data memory control signals
					w_E_M	=1'b1; // write in memory
					w_Add_S_M	=1'b1;  // choose alu_out
					w_Data_S_M	=1'b0; // choose mux with (alu_ot , R[rb])
					w_data_S_M_rb=1'b1; // select R[rb]

			end			

			default : begin

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
end
endmodule