module RegFile #(parameter WIDTH = 8, DEPTH = 4, ADDR = 2 )

(
   input    wire                CLK,
   input    wire                RST,
   input    wire                WrEn,
   input    wire                IncEn,
   input    wire                DecEn,
   input    wire   [ADDR-1:0]   W_Add,
   input    wire   [ADDR-1:0]   R_Add_A,
   input    wire   [ADDR-1:0]   R_Add_B,
   input    wire   [WIDTH-1:0]  WrData,

   output   wire   [WIDTH-1:0]  REGA,
   output   wire   [WIDTH-1:0]  REGB,
   output   reg    [WIDTH-1:0]  Sp
);

   // register file of 4 registers each of 8 bits width
   reg [WIDTH-1:0] regArr [DEPTH-1:0] ;    

   assign REGA = regArr[R_Add_A] ;
   assign REGB = regArr[R_Add_B] ; 

   always @(posedge CLK or negedge RST) begin

      if(!RST) begin // Asynchronous active low reset 
             
            regArr[0] <= 'b0 ;
            regArr[1] <= 'b0 ;
            regArr[2] <= 'b0 ;
            regArr[3] <= 'd255 ;
                   
       end

      else else begin
            
            // Write instruction
            if (WrEn)
                regArr[W_Add] <= WrData;

            // Stack Pointer update
            if (IncEn)
                Sp <= regArr[3] + 1;    // POP, RTI

            if (DecEn)
              Sp<=regArr[3];
                regArr[3] <= regArr[3] - 1;   // PUSH, interrupt

        end
    end


endmodule