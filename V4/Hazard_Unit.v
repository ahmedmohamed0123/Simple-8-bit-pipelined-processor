/*The normal code flow is incrementing the PC, but in case of taken branches, jumps, calls, returns, and interrupts,
the PC needs to be updated to a different address. In such cases, the instructions that were fetched after the branch
instruction but before the new PC is known must be flushed from the pipeline to prevent them from executing incorrectly.*/

module Hazard_Unit (
    input  wire [3:0] OPCODE,        // instruction opcode in EX stage
	input  wire [1:0] ra_addr,
	input  wire [7:0] ra_data,
    input  wire [3:0] CCR,    
    output reg        FLUSH
);

always @(*) begin
    FLUSH = 1'b0;

    // Conditional branches (JZ, JN, JC, JV) and LOOP
    if (OPCODE == 4'd9) begin
	    if ((ra_addr == 2'd0 && CCR[0] == 1'b1)      //JZ
         || (ra_addr == 2'd1 && CCR[1] == 1'b1)      //JN
         || (ra_addr == 2'd2 && CCR[2] == 1'b1)      //JC
         || (ra_addr == 2'd3 && CCR[3] == 1'b1))     //JV
            FLUSH = 1'b1;
	    else
	        FLUSH = 1'b0; 
    end
    
	//Loop 
	else if (OPCODE == 4'd10 && !CCR[0])
	    FLUSH = 1'b1; 
     
    // Unconditional control flow (JMP, CALL, RET, RTI)
    else if (OPCODE == 4'd11)
        FLUSH = 1'b1;

end

endmodule