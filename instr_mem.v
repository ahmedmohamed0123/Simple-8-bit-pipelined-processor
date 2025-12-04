
module instr_mem (
    input  wire        clk,       // clock
    input  wire [7:0]  PC,      // PC input
    output reg  [7:0]  instr,     // instruction  output
    output reg  [7:0]  next_byte  //immediate value or ea
         
);

    // 256x8 ROM
    reg [7:0] mem [0:255];

    
    initial begin
        $readmemh("program.txt", mem);
    end

    // Synchronous read
    always @(posedge clk) begin
        instr <= mem[PC];
        next_byte <= mem[PC + 8'd1];
    end

endmodule
