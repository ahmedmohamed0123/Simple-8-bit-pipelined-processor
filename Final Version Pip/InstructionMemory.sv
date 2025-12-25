module instr_mem (
    input  wire          rst,
    input  wire          interrupt,
    input  wire   [7:0]  PC,        // PC input (Memory Address)
    output wire   [7:0]  instr,     // instruction  output
    output wire   [7:0]  next_byte,  // immediate value or ea
    output reg    [7:0]  M_0
    
);

    // 256x8 ROM
    reg [7:0] mem [0:255];
    

    
    initial begin
        $readmemh("program.txt", mem);
    end

    always @(*) begin
        if (!rst) begin
            M_0=mem[0];
        end
        else begin
            M_0=mem[1];
        end
            
    end

    // Synchronous read

        assign instr = mem[PC];
        assign next_byte = mem[PC + 8'd1];

endmodule