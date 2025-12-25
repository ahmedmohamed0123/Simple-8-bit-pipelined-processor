module Top ( 

	input 	wire			clk,    	// Clock
	input 	wire			rst_n,  	// Asynchronous reset active low
	input	wire			interrupt,  // Signal to inform in case if interrupt
	input 	wire	[7:0]	input_port,

	output 	reg		[7:0]	Out_port
	
);

//*************** Control signal wires ***************//
		
		// pc control signals 
		wire 			[1:0]		S_Target; 		// to choose the target into pc ( 0: M[0], 1: M[1], 2: X[SP], 3: R[rb] )
		wire 							E_Pc;			// change pc or not             
		wire 							E_Imm;			// increment pc 1 or 2          (0: increment 1, 1: increment 2 )
		wire 							load;			// Load target or increment     (0: load target, 1: increment )

		// Register file control signals
		wire							w_E_R;			// Write enable for  file
		wire							IncSp;			// enable for increment sp in  file
		wire							DecSp;			// enable for Decrement sp in  file
		wire							w_Add_S_R;		// Write address selection for  file   (0: ra, 1: rb)
		wire 			[2:0]   w_Data_S_R;		// Write Data selection for  file      (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)

		// Alu control signals
		wire  		[3:0]	 	Alu_Op;    		// Alu opcode
		wire							SaveFlags;		// save flages in [7:4] if interupt came
		wire							returnF;    	// returen flags

		// Data memory control signals
		wire							w_E_M;			// Write enable for Data memory
		wire							w_SP;			// Write enable for Data memory in stack
		wire							W_Z;			// read M[0]
		wire							W_O;			// read M[1]
		wire							w_Add_S_M;		// Write address selection for Data memory    (0: IMM, 1: ALU out)
		wire							w_Data_S_M;		// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
    wire							w_data_S_M_rb; 	// Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		wire							Out_E;			// Enable for  Outport

//*************** PC wires ***************//

		wire	[7:0]	Pc;
		reg    [7:0]   Reg_B_forward;
		wire   [7:0] M_0;
		wire   [7:0] M_1;


//*************** Instruction wires ***************//

		wire 	[7:0]	Opcode;
		wire	[7:0]	IMM;
//*************** ALU ports wires ***************//
	reg [7:0] ALU_A;
   reg [7:0] ALU_B;
//*************** RegisterFile wires ***************//

	    wire   	[1:0]   W_Add;
        wire   	[1:0]   R_Add_A_Id;
       	wire   	[1:0]  	R_Add_B_Id;
       	reg   	[7:0]  	WrData;

      wire   	[7:0]  	Reg_A;
      wire   	[7:0]  	Reg_B;
    	wire   	[7:0]  	Sp;
//*************** Pipeline Control ***************//
		wire stall_hazard;
		wire stall_hazard_pc;
		wire [7:0] opcode_out;

//*************** Forward unit  wires ***************//	
		wire [3:0] forward_a;
		wire [3:0] forward_b;
		wire [3:0] forward_b_pc;

//*************** Alu wires ***************//

		wire 	[3:0]	CCR;
		wire 	[3:0]	CCR_old;
		wire   	[7:0]  	ALu_Out;

//*************** DataMem wires ***************//
		wire 	[7:0]	Mux1;
		wire 	[7:0]  	Mem_Add;    // Address
    wire 	[7:0]  	Mem_W_D;    // Write data
    wire  	[7:0]  	X;          // Stack data


// ********** wires to decode stage  *************	

			wire 			interrupt_Id ;
		    wire 	[7:0]	input_port_Id  ;		
		    wire 	[7:0]	Pc_pluse1_Id  ;
		    wire 	[7:0]	instr_Id  ;
		    wire 	[7:0]	Imm_Id  ;

// ********************** wires to excute stage ************************

		// register file control signals
		    wire 				w_E_R_EX  ;		// Write enable for reg  file
		    wire 				w_Add_S_R_EX  ;	// Write address selection for reg  file   (0: ra  ; 1: rb)
		    wire 		[2:0]	w_Data_S_R_EX  ;	// Write Data selection for reg  file      (0: Mem  ; 1: ALU out   ; 2: SP  ; 3:      ; 4: IMM)

		// Alu control signals
		    wire    	[3:0]	Alu_Opcode_Ex  ;    	// Alu opcode
		    wire 				SaveFlags_EX  ; 	// save flages in [7:4] if interupt came
		    wire 				returnF_EX  ;       // returen flags

		// Data memory control signals
		    wire 				w_E_M_EX  ;		// Write enable for Data memory
		    wire 				w_SP_EX  ;		// Write enable for Data memory in stack
		    wire 				w_Add_S_M_EX  ;	// Write address selection for Data memory    (0: IMM  ; 1: ALU out)
		    wire 				w_Data_S_M_EX  ;	// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb]  ; 1: PC+1)
    	    wire       			w_data_S_M_rb_EX ; // Write  Data selection to select rb incase of (STI) (0: ALU out  ; 1: R[rb])
		    wire 				Out_E_EX  ;		// Enable for output port
		    wire 		[7:0]	Pc_pluse1_EX  ;
		    wire 		[7:0]	Imm_EX  ;
		    wire 		[1:0]	ra_EX  ;
		    wire 		[1:0]	rb_EX  ;
		    wire 		[7:0]	R_ra_EX  ;
		    wire 		[7:0]	R_rb_EX  ;
		    wire 		[7:0]	Sp_EX  ;
			wire 		[7:0]	input_port_EX;
			wire        [7:0]   Opcode_MEM;



// ********************** wires to Mem stage ************************

		 // register file control signals
		    wire 				w_E_R_MEM  ;		// Write enable for reg  file
		    wire 				w_Add_S_R_MEM  ;	// Write address selection for reg  file   (0: ra  ; 1: rb)
		    wire 		[2:0]	w_Data_S_R_MEM  ;	// Write Data selection for reg  file      (0: Mem  ; 1: ALU out   ; 2: SP  ; 3:      ; 4: IMM)

		// Alu control signals
		    wire    	[7:0]	Alu_out_MEM_1  ;    	// Alu out

		// Data memory control signals
		    wire 				w_E_M_MEM  ;		// Write enable for Data memory
		    wire 				w_SP_MEM  ;		// Write enable for Data memory in stack
		    wire 				w_Add_S_M_MEM  ;	// Write address selection for Data memory    (0: IMM  ; 1: ALU out)
		    wire 				w_Data_S_M_MEM  ;	// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb]  ; 1: PC+1)
    	    wire       			w_data_S_M_rb_MEM ; // Write  Data selection to select rb incase of (STI) (0: ALU out  ; 1: R[rb])
		    wire 				Out_E_MEM  ;		// Enable for output port
		    wire 		[7:0]	Pc_pluse1_MEM  ;
		    wire 		[7:0]	Imm_MEM  ;
		    wire 		[1:0]	ra_MEM  ;
		    wire 		[1:0]	rb_MEM  ;
			wire        [7:0]   R_ra_MEM; 
		    wire 		[7:0]	R_rb_MEM  ;
		    wire 		[7:0]	Sp_MEM_1  ;
			wire 		[7:0]	input_port_MEM;

		// mem data out 
		    wire         [7:0]	out_MEM;

// *********** wires to  WB stage ************

        // register file control signals
		    wire 				w_E_R_WB  ;		// Write enable for reg  file
		    wire 				w_Add_S_R_WB  ;	// Write address selection for reg  file   (0: ra  ; 1: rb)
		    wire 		[2:0]	w_Data_S_R_WB  ;	// Write Data selection for reg  file      (0: WB  ; 1: ALU out   ; 2: SP  ; 3:      ; 4: IMM)

		// Alu control signals
		    wire    	[7:0]	Alu_out_WB  ;    	// Alu out

		// Data memory control signals
		    wire 				Out_E_WB  ;		// Enable for output port
		    wire 		[7:0]	Imm_WB  ;
		    wire 		[1:0]	ra_WB  ;
		    wire 		[1:0]	rb_WB  ;
			wire        [7:0]   R_ra_WB;   
		    wire 		[7:0]	R_rb_WB ;
		    wire 		[7:0]	Sp_WB  ;
			wire 		[7:0]	input_port_WB;  
			wire        [7:0]   Opcode_WB;

		// mem data out 
		    wire         [7:0]	out_WB;

		    wire 	[7:0] AL_A;
		    wire 	[7:0] AL_B;
		    reg 	[7:0] Count;
			reg 	[7:0] Alu_A_re;
			reg 	[7:0] Alu_B_re;

    Pc pc(

		.clk(clk),
		.rst(rst_n),
		.interrupt (interrupt),
		.en(E_Pc),
		.load(load),
		.imm(E_Imm),
		.M_0(M_0),
		.X(X),
		.rb(Reg_B_forward),   
		.targer_Sel(S_Target),
		.Pc(Pc) ,
		.stall(stall_hazard_pc)

	);

PC_Control_Unit pcCu(
    .Opcode(Opcode),
    .CCR(CCR),
	.S_Target(S_Target),
	.E_Pc(E_Pc),
	.E_Imm(E_Imm),
	.load(load)
	);


	instr_mem I_m(
		.rst      (rst_n),
		.interrupt(interrupt),
	    .PC(Pc),      		// PC input
	    .instr(Opcode),     // instruction  output
	    .next_byte(IMM),  	//immediate value or ea
	    .M_0      (M_0)
    
	);


	If_Id If_Id  (

	  .clk(clk),
	  .interrupt    (interrupt),
	  .stall(stall_hazard),
	  .Pc_pluse1_If(Pc+1),	 
	  .instr_If(Opcode), 
	  .Imm_If(IMM),
     .input_port_If(input_port),
     .interrupt_Id (interrupt_Id),
	.Pc_pluse1_Id(Pc_pluse1_Id),
     .instr_Id(instr_Id),
     .Imm_Id(Imm_Id),
     .input_port_Id(input_port_Id)
    );

	
	Control_Unit Cu(

		.Opcode(instr_Id),
		.CCR(CCR_old),
		.interrupt(interrupt_Id),
		// pc control signals 
		
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
		.w_Add_S_M(w_Add_S_M),			// Write address selection for Data memory    (0: IMM, 1: ALU out)
		.w_Data_S_M(w_Data_S_M),		// Write Data selection for Data memory       (0: Mux for Alu_out & R[rb], 1: PC+1)
    	.w_data_S_M_rb(w_data_S_M_rb), 	// Write  Data selection to select rb incase of (STI) (0: ALU out, 1: R[rb])
		.Out_E(Out_E)					// Enable for Output port
	);

	always @(*) begin 
		case (w_Data_S_R_WB)
			3'b000:WrData =out_WB;
			3'b001:WrData =Alu_out_WB;
			3'b010:WrData =Sp_WB;
			3'b011:WrData =input_port_WB;
			3'b100:WrData =Imm_WB;
			default : WrData =out_WB;
		endcase
	end

	assign R_Add_A_Id =instr_Id[3:2];
	assign R_Add_B_Id =instr_Id[1:0];

	assign W_Add = (w_Add_S_R_WB) ? rb_WB : ra_WB ; 
	

	RegFile RF(

	   	.clk(clk),
	   	.WrEn(w_E_R_WB),
	   	.IncEn(IncSp),
	   	.DecEn(DecSp),
	   	.W_Add(W_Add),
	   	.R_Add_A(R_Add_A_Id),
	   	.R_Add_B(R_Add_B_Id),
	   	.WrData(WrData),
	   	.Reg_A(Reg_A),
	   	.Reg_B(Reg_B),
	   	.Sp(Sp)
	);
    
	Id_Ex Id_Ex(
	  .clk(clk),
	  .instruction_Id(instr_Id),
       //register file control signals
      .w_E_R_Id(w_E_R),		
      .w_Add_S_R_Id(w_Add_S_R),	
      .w_Data_S_R_Id(w_Data_S_R),

       //alu control signals
      .Alu_Op_Id(Alu_Op),    	
      .SaveFlags_Id(SaveFlags),	
      .returnF_Id(returnF),    

       // Data memory control signals
      .w_E_M_Id(w_E_M),		
      .w_SP_Id(w_SP),		
      .w_Add_S_M_Id(w_Add_S_M),	
      .w_Data_S_M_Id(w_Data_S_M),	
      .w_data_S_M_rb_Id(w_data_S_M_rb),
      .Out_E_Id(Out_E),		
      .Pc_pluse1_Id(Pc_pluse1_Id),
      .Imm_Id(Imm_Id),
      .ra_Id(R_Add_A_Id),
      .rb_Id(R_Add_B_Id),
      .R_ra_Id(Reg_A),
      .R_rb_Id(Reg_B),
      .Sp_Id(Sp),
      .input_port_Id(input_port_Id),

       // Register file control signals
      .w_E_R_Ex(w_E_R_EX),		
      .w_Add_S_R_Ex(w_Add_S_R_EX),	
      .w_Data_S_R_Ex(w_Data_S_R_EX),

       // Alu control signals
      .Alu_Op_Ex(Alu_Opcode_Ex),    	
      .SaveFlags_Ex(SaveFlags_EX),	
      .returnF_Ex(returnF_EX),   

      // Data memory control signals
      .w_E_M_Ex(w_E_M_EX),		
      .w_SP_Ex(w_SP_EX),		
      .w_Add_S_M_Ex(w_Add_S_M_EX),	
      .w_Data_S_M_Ex(w_Data_S_M_EX),	
      .w_data_S_M_rb_Ex(w_data_S_M_rb_EX),
      .Out_E_Ex(Out_E_EX),	
      .Pc_pluse1_Ex(Pc_pluse1_EX),
      .Imm_Ex(Imm_EX),
      .ra_Ex(ra_EX),
      .rb_Ex(rb_EX),
      .R_ra_Ex(R_ra_EX),
      .R_rb_Ex(R_rb_EX),
      .Sp_Ex(Sp_EX),
      .input_port_Ex(input_port_EX),
	  .instruction_Ex(opcode_out)
    );

	//Forward unit 
	 forward_unit  Fu 
	 (
	 	.clk                (clk),
		.W_E_R_previous(w_E_R_EX),           // output after ID/EX stage
		.W_E_R_previous_previous(w_E_R_MEM),  // output after EX/MEM stage
		.W_add_S_previous(w_Add_S_R_EX),     // output after ID/EX stage	
		.W_add_S_previous_previous(w_Add_S_R_MEM),   // output after EX/MEM stage
		.R_ADD_A_current(R_Add_A_Id),             // output after IF/ID stage
		.R_ADD_B_current(R_Add_B_Id),             // output after IF/ID stage
		.W_add_B_previous(rb_EX),            // output after ID/EX stage
		.W_add_B_previous_previous(rb_MEM),   // output after EX/MEM stage
		.W_add_A_previous(ra_EX),            // output after ID/EX stage
		.W_add_A_previous_previous(ra_MEM),   // output after EX/MEM stage
		.w_Data_S_R_previous(w_Data_S_R_EX), // output after ID/EX stage
		.w_Data_S_R_previous_previous(w_Data_S_R_MEM), // output after EX/MEM stage
		.forward_A(forward_a),               // selection for mux at alu input port (port a)
		.forward_B(forward_b)                // selection for mux at alu input port (port b)
	 );
     wire forward_A_pc;
			forward_unit_pc Fu_Pc (
			.W_E_R_previous(w_E_R_EX),
			.W_E_R_previous_previous(w_E_R_MEM),
			.W_add_S_previous(w_Add_S_R_EX),
			.W_add_S_previous_previous(w_Add_S_R_MEM),
			.R_ADD_B_current(R_Add_B_Id),

			.W_add_B_previous(rb_EX),
			.W_add_B_previous_previous(rb_MEM),

			.w_Data_S_R_previous(w_Data_S_R_EX),
			.w_Data_S_R_previous_previous(w_Data_S_R_MEM),

			.forward_B(forward_b_pc)
		);

     

	CCR CCr1(
		.clk(clk),                     // Clock  
	    .saveF(SaveFlags_EX),              // save flages in [7:4] if interupt came
	    .returnF(returnF_EX),           // returen flags 
		.Z(CCR[0]),
	    .N(CCR[1]),
	    .C(CCR[2]),
	    .V(CCR[3]),             //Combinational output flags
	    .CCR_wire(CCR_old)
	);
	
	// Hazard unit 
	 Hazard_Unit HU
	 (
		.OPCODE_ID(instr_Id),
        .OPCODE_memory(Opcode_MEM),
		.OPCODE_fetch(Opcode), 
		.OPCODE_EX    (opcode_out),
		.ra_addr_fetch(Opcode[3:2]),
		.ra_addr_EX(ra_EX),
		.rb_addr_EX(rb_EX),
		.W_E_R_EX(w_E_R_EX),
		.W_add_S_EX(w_Add_S_R_EX),
		.w_Data_S_R_EX(w_Data_S_R_EX),
		.R_ADD_A_ID(R_Add_A_Id),
		.R_ADD_B_ID(R_Add_B_Id),
		.STALL(stall_hazard),
		.STALL_pc(stall_hazard_pc)
	 );

	ALU Alu(

	    .A(AL_A), 
		.B(ALU_B),
	    .Alu_opcode(Alu_Opcode_Ex),
	    .CCR(CCR_old),
	    .out(ALu_Out),			//Combinational output
	    .Z(CCR[0]),
	    .N(CCR[1]),
	    .C(CCR[2]),
	    .V(CCR[3])             //Combinational output flags
	);


    regExecuteMemory EX_MEM (
		  .opcode_ex(opcode_out),
          .clk(clk),
          .Imm_EX(Imm_EX),
          .Pc_plus1_EX(Pc_pluse1_EX),
          .ALU_out_EX(ALu_Out),
          .Sp_EX(Sp_EX),
          .reg_rb_EX(R_rb_EX),
          .input_port_EX(input_port_EX),
          .w_E_M_EX(w_E_M_EX),
          .w_Add_S_M_EX(w_Add_S_M_EX),
          .w_Data_S_M_EX(w_Data_S_M_EX),
          .w_data_S_M_rb_EX(w_data_S_M_rb_EX),
          .w_Sp_EX(w_SP_EX),
          .Out_E_EX(Out_E_EX),
          .w_E_R_EX(w_E_R_EX),
          .w_Add_S_R_EX(w_Add_S_R_EX),
          .w_Data_S_R_EX(w_Data_S_R_EX),
          .ra_EX(ra_EX),
          .rb_EX(rb_EX),
          .Imm_MEM(Imm_MEM),
          .Pc_plus1_MEM(Pc_pluse1_MEM ),
          .ALU_out_MEM(Alu_out_MEM_1),
          .Sp_MEM(Sp_MEM_1),
          .reg_rb_MEM(R_rb_MEM),
          .input_port_MEM(input_port_MEM),
          .w_E_M_MEM(w_E_M_MEM),
          .w_Add_S_M_MEM(w_Add_S_M_MEM),
          .w_Data_S_M_MEM(w_Data_S_M_MEM),
          .w_data_S_M_rb_MEM(w_data_S_M_rb_MEM),
          .w_Sp_MEM(w_SP_MEM),
          .Out_E_MEM(Out_E_MEM),
          .w_E_R_MEM(w_E_R_MEM),
          .w_Add_S_R_MEM(w_Add_S_R_MEM),
          .w_Data_S_R_MEM(w_Data_S_R_MEM),
 		  .ra_MEM(ra_MEM),
		  .rb_MEM(rb_MEM),
		  .opcode_mem(Opcode_MEM)
	);
		// Mux at input port for alu to forward data

		always @(*) begin
			case (forward_a)
				4'b0000: ALU_A = out_MEM;                          // From Data Memory     (Previous instruction)
				4'b0001: ALU_A = Alu_out_MEM_1;                    // From ALU output      (Previous instruction)
				4'b0011: ALU_A = input_port_MEM;                   // From Input Port      (Previous instruction)
				4'b0100: ALU_A = Imm_MEM;                          // From Immediate Value (Previous instruction)
				4'b1000: ALU_A = out_WB;                           // From Data Memory     (Previous Previous instruction)
				4'b1001: ALU_A = Alu_out_WB;                       // From ALU output      (Previous Previous instruction)
				4'b1011: ALU_A = input_port_WB;                    // From Input Port	   (Previous Previous instruction)
				4'b1100: ALU_A = Imm_WB;                    // From Immediate Value (Previous Previous instruction)
				default: ALU_A = R_ra_EX ;                         // From Register File   (Normal case)
			endcase

			case (forward_b)
				4'b0000: ALU_B = out_MEM;                          // From Data Memory     (Previous instruction)
				4'b0001: ALU_B = Alu_out_MEM_1;                    // From ALU output      (Previous instruction)
				4'b0011: ALU_B = input_port_MEM;                   // From Input Port      (Previous instruction)
				4'b0100: ALU_B = Imm_MEM;                          // From Immediate Value (Previous instruction)
				4'b1000: ALU_B = out_WB;                           // From Data Memory     (Previous Previous instruction)
				4'b1001: ALU_B = Alu_out_WB;                       // From ALU output      (Previous Previous instruction)
				4'b1011: ALU_B = input_port_WB;                    // From Input Port	   (Previous Previous instruction)
				4'b1100: ALU_B = Imm_WB;                           // From Immediate Value (Previous Previous instruction)
				default: ALU_B = R_rb_EX ;                         // From Register File   (Normal case)
			endcase

				case (forward_b_pc)
				4'b0000: Reg_B_forward = out_MEM;                          // From Data Memory     (Previous instruction)
				4'b0001: Reg_B_forward = ALu_Out;                    // From ALU output      (Previous instruction)
				4'b0011: Reg_B_forward = input_port_EX;                   // From Input Port      (Previous instruction)
				4'b0100: Reg_B_forward= Imm_EX;                          // From Immediate Value (Previous instruction)
				4'b1000: Reg_B_forward= out_MEM;                           // From Data Memory     (Previous Previous instruction)
				4'b1001:Reg_B_forward= Alu_out_MEM_1;                       // From ALU output      (Previous Previous instruction)
				4'b1011: Reg_B_forward = input_port_MEM;                    // From Input Port	   (Previous Previous instruction)
				4'b1100: Reg_B_forward = Imm_MEM;                           // From Immediate Value (Previous Previous instruction)
				default: Reg_B_forward = Reg_B ;                         // From Register File   (Normal case)
			endcase

		end



	always @(negedge stall_hazard) begin
		
	   Alu_A_re=ALU_A;
	   Alu_B_re=ALU_B;
	   Count=0;

	end

	always @(posedge clk) begin
		Count =Count+1;
	end

	assign AL_A = (Count==1) ? Alu_A_re :ALU_A;
	assign AL_B = (Count==1) ? Alu_B_re :ALU_B;



    assign Mux1 = w_data_S_M_rb_MEM ? R_rb_MEM :Alu_out_MEM_1;

	assign Mem_W_D = w_Data_S_M_MEM ? Pc_pluse1_MEM : Mux1 ;

	assign Mem_Add = w_Add_S_M_MEM ? Alu_out_MEM_1 : Imm_MEM ;

	DataMEM DM(

	    .Clk(clk),
	    .WE(w_E_M_MEM),     // Write Enable
	    .W_Sp(w_SP_MEM),    // Write using Stack
	    .Sp(Sp_MEM_1),       	// Stack pointer
	    .A(Mem_Add),   	// Address
	    .WD(Mem_W_D), 	// Write data
	    .RD(out_MEM), 	// Memory data 
	    .X(X)         	// Stack data

		);

    MEM_WB_Register MEM_WB(   
		  .opcode_mem(Opcode_MEM),    	   
		  .clk(clk), 
          .alu_out_MEM(Alu_out_MEM_1),
          .mem_data_MEM(out_MEM),
          .Sp_MEM(X),
          .imm_MEM(Imm_MEM),
          .input_port_MEM(input_port_MEM),   
		  .R_ra_MEM(R_ra_MEM),     	  
		  .R_rb_MEM(R_rb_MEM),
          .w_E_R_MEM(w_E_R_MEM),
          .w_Add_S_R_MEM(w_Add_S_R_MEM),
          .w_Data_S_R_MEM(w_Data_S_R_MEM),
          .Out_E_MEM(Out_E_MEM),        // Output port enable        	
          .rb_MEM(rb_MEM),        	
          .ra_MEM(ra_MEM),
		  .ra_WB(ra_WB),
		  .rb_WB(rb_WB),
          .alu_out_WB(Alu_out_WB), 
          .mem_data_WB(out_WB),
          .Sp_WB(Sp_WB),
          .imm_WB(Imm_WB), 
          .input_port_WB(input_port_WB), 
		  .R_ra_WB(R_ra_WB),          
		  .R_rb_WB(R_rb_WB),
          .w_E_R_WB(w_E_R_WB),
          .w_Add_S_R_WB(w_Add_S_R_WB),
          .w_Data_S_R_WB(w_Data_S_R_WB),
          .Out_E_WB(Out_E_WB) ,       // Output port enable 
		  .opcode_wb(Opcode_WB)
        );

   always @(posedge clk) begin
	if (Out_E_WB) Out_port <= Alu_out_WB;
	DM.mem[DM.Sp] = (Cu.Opcode[7:4]==4'h7 && Cu.Opcode[3:2]==2'b01 ) ? 8'hxx : DM.mem[DM.Sp];

end
endmodule  
