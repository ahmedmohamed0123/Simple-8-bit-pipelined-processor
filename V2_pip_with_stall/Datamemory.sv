module DataMEM (
    input  wire        Clk,
    input  wire        rst_n,
    input  wire        WE,          // Write Enable
    input  wire        W_Sp,        // Write using Stack
    input  wire        W_Z,         // read m[0]
    input  wire        W_O,         // read m[1]
    input  wire [7:0]  Sp,          // Stack pointer
    input  wire [7:0]  A,           // Address
    input  wire [7:0]  WD,          // Write data
    output reg  [7:0]  RD,          // Memory data 
    output reg  [7:0]  X            // Stack data
);

// 256 x 8-bit memory
    reg [7:0] mem [0:255];
    integer i;

    initial begin 
           for (i=0;i<256;i=i+1) begin
                mem[i]=8'h00;
            end
    end
      
   always @ (*) begin
           if (!W_Sp)
            X <= mem[Sp];    
    end

    always @ (*) begin

        if (W_Z) begin
            RD = mem[0];
        end

        else if (W_O) begin
            RD = mem[1];
        end

        else begin
            RD = mem[A];
        end
            
    end 
    
    // Synchronous memory operations
    always @(posedge Clk or negedge rst_n) begin
        if(!rst_n) begin 
            for (i=0;i<256;i=i+1) begin
            mem[i] <= 8'h00;
            end
            X <= 8'h00;
        end 
        else begin 
            if (W_Sp) begin 
                mem[Sp] <= WD;           
            end
            else if (WE) begin
                mem[A] <= WD;           
            end
        end
    end
    
endmodule