module Alu 
(
    input signed[7:0] A,
    input signed[7:0] B,
    input [4:0] Alu_Op,
    output reg signed[7:0] Result
);
wire z, z_old; // zero value
wire N,N_old; // negative value
wire C ; // carry
reg c_result;
wire V,V_old; // over flow
always @(*) begin
    case (Alu_Op)
        5'b00000 , 5'b00001 , 5'b01010,5'b01011,5'b01100,5'b01101 ,  5'b10111 ,5'b11000: Result=B;
        5'b00010: {c_result,Result}=A+B;
        5'b00011: {c_result,Result}=A-B;
        5'b00100: Result= A & B;
        5'b00101: Result=A | B;
        5'b00110: begin 
            c_result=B[7];
         Result= {B[6:0],c_result};
        end
        5'b00111:  begin
            c_result=B[0];
        Result = {c_result,B[7:1]};
        end
        5'b01000 ,  5'b01001 , 5'b11001,5'b11010: Result=0;
        5'b01110 : Result = ~ B;
        5'b01111 : Result = ~B + 1;
        5'b10000 : {c_result,Result}= B + 1;
        5'b10001 : {c_result,Result}= B - 1;
     // B-type
        5'b10010 :  begin
                 if (!z) 
                   Result =0 ;
                   else 
                   Result= B;
                end
        5'b10011 :  begin
                 if (!N) 
                   Result =0 ;
                   else 
                   Result= B;
                end
       5'b10100:   begin
                 if (!C) 
                   Result =0 ;
                   else 
                   Result= B;
                end
       5'b10101:   begin
                 if (!V) 
                   Result =0 ;
                   else 
                   Result= B;
                end
        5'b10110:   begin
                 if (!(A-1)) 
                   Result =0 ;
                   else 
                   Result= B;
                end
                // L-type
         5'b11011,  5'b11100 , 5'b11101 , 5'b11111: Result = B ; // assume immediate value is input at b (Mux)
         5'b11110: Result = A;

    endcase
end
assign Z =  (((Alu_Op== 5'b00010) || (Alu_Op== 5'b00011) || (Alu_Op== 5'b00100) || (Alu_Op== 5'b00101) || (Alu_Op== 5'b01110) || (Alu_Op== 5'b01111)  || (Alu_Op== 5'b10000) || (Alu_Op== 5'b10001) ) && Result==0 )? 1 : 
(Alu_Op==5'b01000 || Alu_Op==5'b01001) ? z_old :0;
assign N =  (((Alu_Op== 5'b00010) || (Alu_Op== 5'b00011) || (Alu_Op== 5'b00100) || (Alu_Op== 5'b00101) || (Alu_Op== 5'b01110) || (Alu_Op== 5'b01111)  || (Alu_Op== 5'b10000) || (Alu_Op== 5'b10001) ) && Result<0 )? 1 : 
(Alu_Op==5'b01000 || Alu_Op==5'b01001) ? N_old :0;
assign C= (Alu_Op==5'b01000)? 1 : ((Alu_Op== 5'b00010) || (Alu_Op==  5'b00011) || (Alu_Op==  5'b00110) ||  (Alu_Op==  5'b00111) || (Alu_Op==  5'b10000) || (Alu_Op==  5'b10001) ) ? c_result : (Alu_Op==5'b01001) ? 0 : C;
assign V =  ((((Alu_Op== 5'b00010) || (Alu_Op==  5'b00011) || (Alu_Op==  5'b00110) ||  (Alu_Op==  5'b00111) || (Alu_Op==  5'b10000) || (Alu_Op==  5'b10001) )) && ((A > 0 && B>0 && Result<0) || (A < 0 && B<0 && Result>0) ) )? 1 : ((Alu_Op==5'b01000 || Alu_Op==5'b01001))?V_old : 0;


endmodule
