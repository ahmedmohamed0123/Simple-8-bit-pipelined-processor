// any S means Selection line to mux 
// any E means Enable (0: disable, 1: enable)

module PC_Control_Unit (

		input wire 	[7:0]	    Opcode,
		input wire 	[3:0]	    CCR,
		
		// pc control signals 
		output reg	[1:0]	    S_Target, 	    // to choose the target into pc ( 0: M[0], 1: M[1], 2: X[SP], 3: R[rb] )
		output reg				E_Pc,		    // change pc or not             
		output reg				E_Imm,		    // increment pc 1 or 2          (0: increment 1, 1: increment 2 )
		output reg				load		    // Load target or increment     (0: load target, 1: increment )
	);


always @(*)	begin

	// pc control signals 
			S_Target	=2'b00;
			E_Pc	=1'b0;	
			E_Imm	=1'b0;		
			load	=1'b0;
			

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

			end

			4'h2: begin                    //ADD

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

			4'h3: begin                     //SUB

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

			4'h4: begin                     //AND

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

			4'h5: begin                     //OR

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

			4'h6: begin

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

            4'h7: begin

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

			4'h8: begin

			// PC control signals   (PC = PC + 1)	
					E_Pc	= 1'b1;         // Enable PC update		
					E_Imm	= 1'b0;		    // Increment by 1
					load	= 1'b1;         // Increment

			end

/*------------------------------------- B-Format -------------------------------------*/

			4'h9: begin

			case (Opcode[3:2])

					2'h0: begin      //JZ
						E_Pc	=1'b1;
                        if(CCR[0]==1'b0)   begin   
				            // pc<--pc+1
						    E_Imm	=1'b0;		
							load	=1'b1;
						end
                        else   begin 
						// pc<--rb
						    S_Target	=2'b11;
						    load	=1'b0;
                            E_Imm	=1'bx;	
						end
			
					end

					2'h1: begin       //JN
                     E_Pc	=1'b1;
                          if(CCR[1]==1'b0)   begin
					 // pc<--pc+1
							E_Imm	=1'b0;		
							load	=1'b1;
							end
                           else   begin
					 // pc<--rb
						  S_Target	=2'b11;
						  load	=1'b0;
                          E_Imm	=1'bx;	
						end
			
					end

					2'h2: begin            //JC

					E_Pc	=1'b1;
                          if(CCR[2]==1'b0)   begin
					// pc<--pc+1
							E_Imm	=1'b0;		
							load	=1'b1;
							end
                           else   begin
					// pc<--rb
						  S_Target	=2'b11;
						  load	=1'b0;	
						end
			
					end

					2'h3: begin              //JV
                    E_Pc	=1'b1;
                          if(CCR[3]==1'b0)   begin
					    // pc<--pc+1
							E_Imm	=1'b0;		
							load	=1'b1;
							end
                           else   begin
					     // pc<--rb
						  S_Target	=2'b11;
						  load	=1'b0;
						end
			
					end
				
				endcase

			end
 
			4'hA: begin    //LOOP

                    E_Pc	=1'b1;	
				   if (CCR[0] == 1'b0)begin
				     //  pc<--rb
					S_Target	=2'b11;		
					load	=1'b0;
				   end
				   else begin
				    //pc<--pc+1
                      E_Imm	=1'b0;
					  load	=1'b1;
				   end

			end

			4'hB: begin               

			case (Opcode[3:2])

					2'h0: begin    //JUMP
                    
					//pc<--rb
							S_Target	=2'b11;
							E_Pc	=1'b1;		
							load	=1'b0;

					end

					2'h1: begin       //CALL
                          //  pc<--rb              
							S_Target	=2'b11;
							E_Pc	=1'b1;			
							load	=1'b0;
					end

					2'h2: begin        //RET
					   //  pc<--sp             
							S_Target	=2'b10;
							E_Pc	=1'b1;			
							load	=1'b0;
					end

					2'h3: begin            //RTI
					   //     pc<--sp             
							S_Target	=2'b10;
							E_Pc	=1'b1;		
							load	=1'b0;
					end
				
				endcase

			end


/*------------------------------------- L-Format -------------------------------------*/

			4'hC: begin //(pc+2->pc)

			case (Opcode[3:2]) // select depending on ra

					2'h0: begin //LDM (R[rb] ← imm)

					// pc control signals 	
						E_Pc	=1'b1;	// high to pass data
						E_Imm	=1'b1;		// increment by 2
						load	=1'b1; // select pc+2

					end

					2'h1: begin //LDD (R[rb] ← M[ea])

					// pc control signals 
							E_Pc	=1'b1;	// high to pass data
							E_Imm	=1'b1;		// increment by 2
							load	=1'b1; // select pc+2

					end

					2'h2: begin //STD ( M[ea] ← R[rb])

						E_Pc	=1'b1;	// high to pass data
						E_Imm	=1'b1;		// increment by 2
						load	=1'b1; // select pc+2

					end

					default: begin

					// pc control signals 
							S_Target	=2'b00;
							E_Pc	=1'b0;	
							E_Imm	=1'b0;		
							load	=1'b0;

					end
				
				endcase

			end

			4'hD: begin //LDI(R[rb] ← M[R[ra]])

			// pc control signals (pc+1->pc)
					
					E_Pc	=1'b1;	 // high to pass data
					E_Imm	=1'b0;	 // to increment 1	
					load	=1'b1;  // select pc+1
				
			end

			4'hE: begin    // STI (M[R[ra]] ←R[rb])

			// pc control signals 
					E_Pc	=1'b1;	 // high to pass data
					E_Imm	=1'b0;	 // to increment 1	
					load	=1'b1;  // select pc+1

			end			

			default : begin

			// pc control signals 
					S_Target	=2'b00;
					E_Pc	=1'b0;	
					E_Imm	=1'b0;		
					load	=1'b0;
			end

		endcase
		
end
endmodule