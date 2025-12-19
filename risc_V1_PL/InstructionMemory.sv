module instr_mem (
    input  wire  [7:0]  PC,        // PC input (Memory Address)
    output wire  [7:0]  instr,     // instruction  output
    output wire  [7:0]  next_byte  // immediate value or ea
);

    // 256x8 ROM
    reg [7:0] mem [0:255];

    
    initial begin
        $readmemh("tst_forward_1.txt", mem);
    end

    // Synchronous read
        assign instr = mem[PC];
        assign next_byte = mem[PC + 8'd1];

endmodule