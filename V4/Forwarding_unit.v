module forward_unit 
(
   input wire  W_E_R_next, // write enable for the current cycle ( o/p from pipeline  after fetch ) to check write in register
   input wire [1:0] R_ADD_A_next , // read reg A for the current cycle ( o/p from pipeline  after fetch ) 
   input wire [1:0]  R_ADD_B_next, // read reg B  for the current cycle ( o/p from pipeline  after fetch )
   input wire [1:0] W_add_last, // write addrees for the last cycle
   input wire W_E_M_last, // to check there is load data from memory if it low
   output reg [1:0] forward_A, // to forward data for port A for ALU
   output reg [1:0] forward_B // to forward data for port  B for ALU

);
always @(*) begin 
    //ideal case
    forward_A= 2'b00;
    forward_B=2'b00;
    // execution hazard (Dependency RAW) (Arithmetic or logical then arithmetic or logical ADD r1.r2 -> ADD r1,r3)
    if(W_E_R_next && (R_ADD_A_next!=2'b11) && (W_add_last==R_ADD_A_next))
    forward_A=2'b01;

    if(W_E_R_next && (R_ADD_B_next!=2'b11) && (W_add_last==R_ADD_B_next))
    forward_B=2'b01;

    // Memory hazard (Dependency RAW) (L_type then arithmetic or logical LDI/LDD/LDM r1,r2(0) -> ADD r1,r3)
      if(W_E_R_next && !(W_E_M_last) && (R_ADD_A_next!=2'b11) && (W_add_last==R_ADD_A_next))
      forward_A=2'b10;

       if(W_E_R_next && !(W_E_M_last) && (R_ADD_B_next!=2'b11) && (W_add_last==R_ADD_B_next))
      forward_B=2'b10;

end

endmodule 
/* ALU has mux for 3 inputs now
00: output from reg file
01: output from alu 
10 : output from memory 
/*