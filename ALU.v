module ALU 
(
    input clk, rst,                 //Clock and Reset for sequential logic in CCR 
    input signed [7:0] A, B,
    input [3:0] ALU_opcode,
    output reg signed [7:0] out,    //Combinational output
    output reg Z,N,C,V              //Combinational output flags
);

reg [3:0] CCR;                      //Condition Code Register [V C N Z]

//Sequential logic to update CCR
always @(posedge clk or posedge rst) begin
    if (rst)
        CCR <= 0;
    else
        CCR <= {V,C,N,Z};
end

//Combinational logic for ALU operations
always @(*) begin
    Z = CCR[0];
    N = CCR[1];
    C = CCR[2];
    V = CCR[3];
    out = 0;

    case (ALU_opcode)
        4'b0000:    out = B;                      //Pass B (MOV - PUSH - OUT - JZ - JN- JC - JV - JMP - CALL - STD - STI - LOOP)

        4'b0001: begin                            //Addition (ADD)
            {C,out} = A + B;                                       //Carry bit
            V = ((A[7] == B[7]) && (out[7] != A[7])) ? 1 : 0;      //Same inputs sign, different out sign --> overflow 
            N = out[7];                                            //Most significant bit indicates negative
            Z = !out ? 1 : 0;                  
        end

        4'b0010: begin                            //Subtraction (SUB)
            {C,out} = A - B;                                       //Borrow bit  
            V = ((A[7] != B[7]) && (out[7] != A[7])) ? 1 : 0;      //Different inputs sign, out sign doesn't match A sign --> overflow 
            N = out[7];                                          
            Z = !out ? 1 : 0;                  
        end

        4'b0011: begin                            //AND
            out = A & B;
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b0100: begin                            //OR
            out = A | B;
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b0101: begin                            //Rotate Left with Carry (RLC)
            out = {B[6:0], C};
            C = B[7];
            V = (out[7] != B[7]) ? 1 : 0;            //Change in the sign --> overflow
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b0110: begin                           //Rotate Right with Carry (RRC)
            out = {C, B[7:1]};
            C = B[0];
            V = (out[7] != B[7]) ? 1 : 0;            //Change in the sign --> overflow
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b0111:    C = 1;                       //Set Carry (SETC) and save last values of Z,C,V,N

        4'b1000:    C = 0;                       //Clear Carry (CLRC) and save last values of Z,C,V,N

        4'b1001: begin                           //NOT
            out = !B;
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b1010: begin                           //NEG
            out = !B + 1;
            N = out[7];                                          
            Z = !out ? 1 : 0; 
        end

        4'b1011: begin                           //Increase B (INC)
            {C,out} = B + 1;                                       
            V = (!B[7]) && (out[7]) ? 1 : 0;                       //Same inputs sign, different out sign --> overflow 
            N = out[7];                                          
            Z = !out ? 1 : 0;                  
        end

        4'b1100: begin                           //Decrease B (DEC)
            {C,out} = B - 1;                                       
            V = ((B[7]) && (out[7] != B[7])) ? 1 : 0;      //Different inputs sign, out sign doesn't match B sign --> overflow 
            N = out[7];                                          
            Z = !out ? 1 : 0;                  
        end

        4'b1101: begin                           //Decrease A (LOOP)
            {C,out} = A - 1;                                       
            V = ((A[7]) && (out[7] != A[7])) ? 1 : 0;      //Different inputs sign, out sign doesn't match A sign --> overflow 
            N = out[7];                                          
            Z = !out ? 1 : 0;                  
        end

        4'b1110:    out = A;                     //Pass A (LDI - STI)

        default: {out,Z,N,C,V} = 0;              //Default case
    endcase

end

endmodule