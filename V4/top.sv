module Top ( 

	input 	wire			clk,    	// Clock
	input 	wire			rst_n,  	// Asynchronous reset active low
	input	wire			interrupt,  // Signal to inform in case if interrupt
	input 	wire	[7:0]	In_port,

	output 	reg		[7:0]	Out_port
	
);

//*************** Control signal wires ***************//
		
		// pc control signals 
		wire 	[1:0]	S_Target; 		// to choose the target into pc ( 0: M[0], 1: M[1], 2: X[SP], 3: R[rb] )
		wire 			E_Pc;			// change pc or not             
		wire 			E_Imm;			// increment pc 1 or 2          (0: increment 1, 1: increment 2 )
		wire 			load;			// Load target or increment     (0: load target, 1: increment )

		// Register file control signals
		wire			w_E_R;			// Write enable for  file
		wire 			IncSp;			// enable for increment sp in  file
		wire 			DecSp;			// enable for Decrement sp in  file
		wire 			w_Add_S_R;		// Write address selection for  file   (0: ra, 1: rb)
		wire 	[2:0]	w_Data_S_R;		// Write Data selection for  file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		wire  	[3:0]	Alu_Op;    		// Alu opcode
		wire 			SaveFlags;		// save flages in [7:4] if interupt came
		wire 			returnF;    	// returen flags

		// Data memory control signals
		wire 			w_E_M;			// Write enable for Data memory
		wire 			w_SP;			// Write enable for Data memory in stack
		wire			W_Z;			// read M[0]
		wire			W_O;			// read M[1]
		wire 			w_Add_S_M;		// Write address selection for Data memory    (0: IMM, 1: ALU out)
		wire 			w_Data_S_M;		// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
        wire       		w_data_S_M_rb; 	// Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		wire 			Out_E;			// Enable for  Outport

//*************** PC wires ***************//

		wire	[7:0]	Pc;

//*************** Instruction wires ***************//

		wire 	[7:0]	Opcode;
		wire	[7:0]	IMM;


//*************** RegisterFile wires ***************//

	    wire   	[1:0]   W_Add;
        wire   	[1:0]   R_Add_A;
       	wire   	[1:0]  	R_Add_B;
       	reg   	[7:0]  	WrData;

       	wire   	[7:0]  	Reg_A;
      	wire   	[7:0]  	Reg_B;
    	wire   	[7:0]  	Sp;

//*************** Alu wires ***************//

		wire 	[3:0]	CCR;
		wire 	[3:0]	CCR_old;
		wire   	[7:0]  	ALu_Out;

//*************** DataMem wires ***************//
		wire 	[7:0]	Mux1;
		wire 	[7:0]  	Mem_Add;    // Address
      	wire 	[7:0]  	Mem_W_D;    // Write data
     	wire  	[7:0]  	Mem_R_D;    // Memory data 
    	wire  	[7:0]  	X;          // Stack data



    Pc pc(

		.clk(clk),
		.en(E_Pc),
		.load(load),
		.imm(E_Imm),
		.M1(Mem_R_D),  
		.X(X),   
		.rb(Reg_B),   
		.targer_Sel(S_Target),
		.Pc(Pc)

	);



	instr_mem I_m(
	    .PC(Pc),      		// PC input
	    .instr(Opcode),     // instruction  output
	    .next_byte(IMM)  	//immediate value or ea
    
	);


	Control_Unit Cu(

		.Opcode(Opcode),
		.CCR(CCR),
		.rst_n(rst_n),
		.interrupt(interrupt),
		// pc control signals 
		.S_Target(S_Target), 	// to choose the target into pc ( 0: M[0], 1: M[1], 2: X[SP], 3: R[rb] )
		.E_Pc(E_Pc),			// change pc or not             
		.E_Imm(E_Imm),			// increment pc 1 or 2          (0: increment 1, 1: increment 2 )
		.load(load),			// Load target or increment     (0: load target, 1: increment )

		// Register file control signals
		.w_E_R(w_E_R),				// Write enable for Reg file
		.IncSp(IncSp),				// enable for increment sp in Reg file
		.DecSp(DecSp),				// enable for Decrement sp in Reg file
		.w_Add_S_R(w_Add_S_R),		// Write address selection for Reg file   (0: ra, 1: rb)
		.w_Data_S_R(w_Data_S_R),	// Write Data selection for Reg file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		.Alu_Op(Alu_Op),    		// Alu opcode
		.SaveFlags(SaveFlags),		// save flages in [7:4] if interupt came
		.returnF(returnF),    		// returen flags

		// Data memory control signals
		.w_E_M(w_E_M),					// Write enable for Data memory
		.w_SP(w_SP),					// Write enable for Data memory in stack
		.W_Z(W_Z),
		.W_O(W_O),
		.w_Add_S_M(w_Add_S_M),			// Write address selection for Data memory    (0: IMM, 1: ALU out)
		.w_Data_S_M(w_Data_S_M),		// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
    	.w_data_S_M_rb(w_data_S_M_rb), 	// Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		.Out_E(Out_E)					// Enable for Output port
	);




	always @(*) begin 
		case (w_Data_S_R)
			3'b000:WrData =Mem_R_D;
			3'b001:WrData =ALu_Out;
			3'b010:WrData =X;
			3'b011:WrData =In_port;
			3'b100:WrData =IMM;
			default : WrData =Mem_R_D;
		endcase
	end

	assign R_Add_A =Opcode[3:2];
	assign R_Add_B =Opcode[1:0];

	assign W_Add = (w_Add_S_R) ? Opcode[1:0] : Opcode[3:2] ; 
	

	RegFile RF(

	   	.clk(clk),
	   	.rst_n(rst_n),
	   	.WrEn(w_E_R),
	   	.IncEn(IncSp),
	   	.DecEn(DecSp),
	   	.W_Add(W_Add),
	   	.R_Add_A(R_Add_A),
	   	.R_Add_B(R_Add_B),
	   	.WrData(WrData),
	   	.Reg_A(Reg_A),
	   	.Reg_B(Reg_B),
	   	.Sp(Sp)
	);

	CCR CCr1(
		.clk(clk),     
	    .rst(rst_n),                // Clock and Reset for sequential logic in CCR 
	    .saveF(SaveFlags),              // save flages in [7:4] if interupt came
	    .returnF(returnF),           // returen flags 
		.Z(CCR[0]),
	    .N(CCR[1]),
	    .C(CCR[2]),
	    .V(CCR[3]),             //Combinational output flags
	    .CCR_wire(CCR_old)

	);

	ALU Alu(

	    .A(Reg_A), 
	    .B(Reg_B),
	    .ALU_opcode(Alu_Op),
	    .CCR(CCR_old),
	    .out(ALu_Out),			//Combinational output
	    .Z(CCR[0]),
	    .N(CCR[1]),
	    .C(CCR[2]),
	    .V(CCR[3])             //Combinational output flags
	);


	assign Mux1 = w_data_S_M_rb ? Reg_B :ALu_Out ;

	assign Mem_W_D = w_Data_S_M ? (Pc+1) : Mux1 ;

	assign Mem_Add = w_Add_S_M ? ALu_Out : IMM ;

	DataMEM DM(

	    .Clk(clk),
	    .rst_n(rst_n),
	    .WE(w_E_M),     // Write Enable
	    .W_Sp(w_SP),    // Write using Stack
	    .W_Z(W_Z),		// read m[0]
	    .W_O(W_O),		// read m[0]
	    .Sp(Sp),       	// Stack pointer
	    .A(Mem_Add),   	// Address
	    .WD(Mem_W_D), 	// Write data
	    .RD(Mem_R_D), 	// Memory data 
	    .X(X)         	// Stack data

		);
always @(posedge clk) begin
	if (Out_E) Out_port <= ALu_Out;
	DM.mem[DM.Sp] = (Cu.Opcode[7:4]==4'h7 && Cu.Opcode[3:2]==2'b01 ) ? 0 : DM.mem[DM.Sp];
end

endmodule 