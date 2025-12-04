module DataMEM (
    input  wire        Clk,       
    input  wire        WE,        // Write Enable 
    input  wire        RE,        // Read Enable
    input  wire [7:0]  A,         // Address
    input  wire [7:0]  WD,        // Write data
    output reg  [7:0]  RD         // Read data 
);

    // 256 x 8-bit memory
    reg [7:0] mem [0:255];

    initial begin
        $readmemh("memory_init.txt", mem);  
       
    end

    // Synchronous memory operations
    always @(posedge Clk) begin
        if (WE)
            mem[A] <= WD;
        if (RE)
        RD <= mem[A];
    end
    
endmodule


