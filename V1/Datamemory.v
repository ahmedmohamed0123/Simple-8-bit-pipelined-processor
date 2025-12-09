module DataMEM (
    input  wire        Clk,
    input  wire        rst_n,
    input  wire        WE,          // Write Enable 
    input  wire [7:0]  Sp,          // Stack pointer
    input  wire [7:0]  A,           // Address
    input  wire [7:0]  WD,          // Write data
    output reg  [7:0]  RD,          // Memory data 
    output reg  [7:0]  X            // Stack data
);

    // 256 x 8-bit memory
    reg [7:0] mem [0:255];
    integer i;

    assign RD = mem[A];
    assign X  = mem[Sp];

        // Synchronous memory operations
    always @(posedge Clk or negedge rst_n) begin

        if(!rst_n) begin 
            for (i=0;i<256;i=i+1) begin
                mem[i]=8'h00;
            end
        end
        if (WE)
            mem[A] <= WD;
   
    end
    
endmodule