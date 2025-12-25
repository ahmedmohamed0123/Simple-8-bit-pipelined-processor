module forward_unit_pc 
(

   input wire       W_E_R_previous,       // write enable for the previous instruction to check write in register (No Write -> No Hazard)
   input wire       W_E_R_previous_previous,
   input wire       W_add_S_previous,     // write address select for the previous instruction to know which reg is being written  (0: A, 1: B)
   input wire       W_add_S_previous_previous,
   input wire [1:0] R_ADD_B_current,      // read address reg B of current instruction (Source register)
   input wire [1:0] W_add_B_previous,     // write address reg B address of previous instruction     
   input wire [1:0] W_add_B_previous_previous,
   input wire [2:0] w_Data_S_R_previous,  // reg write data selection line for the previous instruction (0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)
   input wire [2:0] w_Data_S_R_previous_previous,
   output reg [3:0] forward_B             // to forward data for port B for ALU (ALU's B port's MUX select line)
);

// Select actual destination register

always @(*) begin 
   //ideal case
   forward_B = 4'b0010;

   //Forwarding B
   //Previous Prevoius instruction
   if (W_E_R_previous_previous && (R_ADD_B_current != 2'b11) && (W_add_B_previous_previous == R_ADD_B_current)) begin
      case (w_Data_S_R_previous_previous)
         3'b000: begin
            // Memory hazard (Dependency RAW) (L_type then arithmetic or logical LDI/LDD r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
            forward_B = 4'b1000; 
         end

         3'b001: begin
            // Execution hazard (Dependency RAW) (Arithmetic or logical then arithmetic or logical ADD r1.r2 -> ADD r3,r1)
            forward_B = 4'b1001;
         end

         3'b011: begin
            // Input hazard (Dependency RAW) (IN r1 -> ADD r2,r1)
            forward_B = 4'b1011;
         end

         3'b100: begin
            // Immediate hazard (Dependency RAW) (LDI r1,imm -> ADD r2,r1)
            forward_B = 4'b1100;
         end
         
         default: forward_B = 4'b0010; // No hazard and no forwarding needed (Normal case)
      endcase
   end

   //Previous instruction
   if (W_E_R_previous && (R_ADD_B_current != 2'b11) && (W_add_B_previous == R_ADD_B_current)) begin
      case (w_Data_S_R_previous)
         3'b000: begin
            // Memory hazard (Dependency RAW) (L_type then arithmetic or logical LDI/LDD r1,r2(0) -> ADD r3,r1) (Will still have one stall cycle)
            forward_B = 4'b0000; 
         end

         3'b001: begin
            // Execution hazard (Dependency RAW) (Arithmetic or logical then arithmetic or logical ADD r1.r2 -> ADD r3,r1)
            forward_B = 4'b0001;
         end

         3'b011: begin
            // Input hazard (Dependency RAW) (IN r1 -> ADD r2,r1)
            forward_B =4'b0011;
         end

         3'b100: begin
            // Immediate hazard (Dependency RAW) (LDI r1,imm -> ADD r2,r1)
            forward_B = 4'b0100;
         end
         
         default: forward_B = 4'b0010; // No hazard and no forwarding needed (Normal case)
      endcase
   end
   
end

endmodule
//(0: Mem, 1: ALU out , 2: SP, 3: INPUT, 4: IMM)
/* ALU has mux for 5 inputs now
0000: output from Memory (Previous instruction)
0001: output from ALU    (Previous instruction)
0011: Input port         (Previous instruction)
0100: Immediate Value    (Previous instruction)

1000: output from Memory (Previous Previous instruction)
1001: output from ALU    (Previous Previous instruction)
1011: Input port         (Previous Previous instruction)
1100: Immediate Value    (Previous Previous instruction)
Default (0010): Output from Register File (Normal case)
*/