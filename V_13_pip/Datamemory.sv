module DataMEM (
    input  wire        Clk,
    input  wire        WE,          // Write Enable
    input  wire        W_Sp,        // Write using Stack
    input  wire [7:0]  Sp,          // Stack pointer
    input  wire [7:0]  A,           // Address
    input  wire [7:0]  WD,          // Write data
    output reg  [7:0]  RD,          // Memory data 
    output reg  [7:0]  X            // Stack data
);

// 256 x 8-bit memory
    reg [7:0] mem [0:255];
      
   always @ (*) begin

           if (!W_Sp) begin
                X <= mem[Sp];  
           end
           
            RD = mem[A];  
    end

    
    // Synchronous memory operations
    always @(posedge Clk ) begin
    
       
        if (W_Sp) begin 
                mem[Sp] <= WD;           
        end
        else if (WE) begin
                mem[A] <= WD;           
        end
     
    end
    
endmodule