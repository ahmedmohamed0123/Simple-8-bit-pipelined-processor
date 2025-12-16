module Hazard_Unit (
    input  wire [3:0] OPCODE,        // instruction opcode in EX stage
	input  wire [1:0] ra_addr,
	input wire [7:0] ra_data,
    input  wire [3:0] CCR,    
    output reg        FLUSH
);

always @(*) begin
    FLUSH = 1'b0;

    // Conditional branches (JZ, JN, JC, JV) and LOOP
    if (OPCODE == 4'd9)
	 begin
	  if((CCR == 4'b1000 && ra_addr == 2'd0)||(CCR == 4'b0100 && ra_addr == 2'd1)||(CCR == 4'b0010 && ra_addr == 2'd2)||(CCR == 4'b0001 && ra_addr == 2'd3))
       FLUSH = 1'b1;
	  else
	   FLUSH = 1'b0; 
     end
	//Loop 
	else if (OPCODE == 4'd10 && ((ra_data-1)!= 0))
	 FLUSH = 1'b1; 
     
    // Unconditional control flow (JMP, CALL, RET, RTI)
    else if (OPCODE == 4'd11 && (ra_addr == 2'd1 || ra_addr == 2'd2 || ra_addr == 2'd3))
     FLUSH = 1'b1;
end

endmodule