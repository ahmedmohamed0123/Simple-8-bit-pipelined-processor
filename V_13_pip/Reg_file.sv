module RegFile #(parameter WIDTH = 8, DEPTH = 4, ADDR = 2)
(
   input    wire                clk,
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
   reg [7:0] regArr [2:0];
   reg [7:0] reg_sp;    

   assign Reg_A = regArr[R_Add_A];
   assign Reg_B = regArr[R_Add_B]; 

   always @ (*) begin

      if (IncEn) begin
         reg_sp = reg_sp +1; 
         Sp= reg_sp;
      end

      else if (DecEn) begin 
         Sp= reg_sp;
         reg_sp = reg_sp -1;
      end

      else Sp= reg_sp;
   end

   
   always @(posedge clk ) begin

     

      if (WrEn) begin

           // Register Write Operation  
           regArr[W_Add] <= WrData;
       
      end

   end

endmodule