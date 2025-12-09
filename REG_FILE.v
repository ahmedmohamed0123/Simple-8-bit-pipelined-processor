module RegFile #(parameter WIDTH = 8, DEPTH = 4, ADDR = 2 )

(
input    wire                CLK,
input    wire                RST,
input    wire                WrEn,
input    wire                RdEn,
input    wire   [ADDR-1:0]   W_Add,
input    wire   [ADDR-1:0]   R_Add_A,
input    wire   [ADDR-1:0]   R_Add_B,
input    wire   [WIDTH-1:0]  WrData,
output   reg                 RdData_VLD,
output   wire   [WIDTH-1:0]  REGA,
output   wire   [WIDTH-1:0]  REGB,
output   wire   [WIDTH-1:0]  Sp
);

integer I ; 
  
// register file of 4 registers each of 8 bits width
reg [WIDTH-1:0] regArr [DEPTH-1:0] ;    

always @(posedge CLK or negedge RST) begin

   if(!RST) begin // Asynchronous active low reset 

     RdData_VLD <= 1'b0 ;
        for (I=0 ; I < DEPTH ; I = I +1) begin
          
           if(I==3)
              regArr[I] <= 'd255 ;
           else
              regArr[I] <= 'b0 ;  
        end
    end

   else begin
     
      Sp<= regArr[3];

      if (RdEn) begin // Register Read Operation,Read has higher priority
       
          REGA <= regArr[R_Add_A] ;
          REGB <= regArr[R_Add_B] ;
          RdData_VLD <= 1'b1 ;

      end
      else begin
          RdData_VLD <= 1'b0 ;
      end
       
     if (WrEn) begin // Register Write Operation  
        regArr[W_Add] <= WrData;
      end    
   end
end

endmodule
