module forward_unit 
(
   input wire       W_E_R_previous,       // write enable for the previous instruction to check write in register (No Write -> No Hazard)
   input wire [1:0] R_ADD_A_current,      // read address reg A for the current instruction (Source register)
   input wire [1:0] R_ADD_B_current,      // read address reg B for the current instruction (Source register)
   input wire [1:0] W_add_B_previous,       // write address for the previous instruction (destination register)
   input wire [1:0] W_add_A_previous,       // write address for the previous instruction (destination register)
   input wire  W_add_S_R , // to select address for last instruction
   input wire [2:0] w_Data_S_R_previous,  // reg write data selection line for the previous instruction (to check if data is from ALU or Memory) (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)
   output reg [1:0] forward_A,            // to forward data for port A for ALU (ALU's A port's MUX select line)
   output reg [1:0] forward_B             // to forward data for port B for ALU (ALU's B port's MUX select line)
);
 reg  [1:0] distination_prev;

always @(*) begin 
   //ideal case
   forward_A = 2'b00;
   forward_B = 2'b00;

   distination_prev=(W_add_S_R)? W_add_B_previous : W_add_A_previous;

   if (W_E_R_previous && (R_ADD_A_current != 2'b11) && (distination_prev==R_ADD_A_current) ) begin
      case (w_Data_S_R_previous)
      // Memory hazard (Dependency RAW) (L_type then arithmetic or logical LDD r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
         3'd0: forward_A = 2'b10;
      // Execution hazard (Dependency RAW) (Arithmetic or logical then arithmetic or logical ADD r1.r2 -> ADD r3,r1)
       3'd1:  forward_A = 2'b01;
       //3'd4: forward_A=2'b11; // Immediate value  (L_type then arithmetic or logical LDI r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
       default : forward_A=2'b00;
   endcase
   end
         
   if (W_E_R_previous && (R_ADD_B_current != 2'b11) && ((distination_prev==R_ADD_B_current) ) ) begin
      case (w_Data_S_R_previous)
      // Memory hazard (Dependency RAW) (L_type then arithmetic or logical LDD r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
         3'd0: forward_B= 2'b10;
      // Execution hazard (Dependency RAW) (Arithmetic or logical then arithmetic or logical ADD r1.r2 -> ADD r3,r1)
       3'd1:  forward_B = 2'b01;
       //3'd4: forward_B=2'b11; // Immediate value  (L_type then arithmetic or logical LDI r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
       default : forward_B=2'b00;
   endcase
   end

end

endmodule
/* ALU has mux for 3 inputs now
00: output from reg file
01: output from alu 
10 : output from memory 
11 : immediate_value 
*/
