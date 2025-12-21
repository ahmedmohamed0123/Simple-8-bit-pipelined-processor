module RegFile #(parameter WIDTH = 8, DEPTH = 4, ADDR = 2)
(
   input    wire                clk,
   input    wire                rst_n,
   input    wire                WrEn,
   input    wire                IncEn,
   input    wire                DecEn,
   input    wire   [ADDR-1:0]   W_Add,
   input    wire   [ADDR-1:0]   R_Add_A,
   input    wire   [ADDR-1:0]   R_Add_B,
   input    wire   [WIDTH-1:0]  WrData,

   output   wire   [WIDTH-1:0]  Reg_A,
   output   wire   [WIDTH-1:0]  Reg_B,
   output   reg    [WIDTH-1:0]  Sp
);

   // register file of 4 registers each of 8 bits width
   reg [WIDTH-1:0] regArr [DEPTH-1:0];    

   assign Reg_A = regArr[R_Add_A];
   assign Reg_B = regArr[R_Add_B]; 

   always @ (*) begin

      if (IncEn) begin
         regArr[3] = regArr[3] +1; 
         Sp= regArr[3];
      end

      else if (DecEn) begin 
         Sp= regArr[3];
         regArr[3] = regArr[3] -1;
      end

      else Sp= regArr[3];
   end

   

   always @(posedge clk or negedge rst_n) begin

      if(!rst_n) begin // Asynchronous active low reset 
             
            regArr[0] <= 'b0 ;
            regArr[1] <= 'b0 ;
            regArr[2] <= 'b0 ;
            regArr[3] <= 'd255 ;
                   
       end

      else if (WrEn) begin

           // Register Write Operation  
           regArr[W_Add] <= WrData;
       
      end

   end

endmodule