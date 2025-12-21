module Hazard_Unit (
    // ---------- EX stage ----------
    input  wire [3:0] OPCODE_EX,
    input  wire [1:0] ra_addr_EX,
    input  wire [1:0] rb_addr_EX,
    input  wire [3:0] CCR,

    input  wire        W_E_R_EX,         // write enable for EX stage instruction to check write in register (No Write -> No Hazard)
    input  wire        W_add_S_EX,       // write address select for the EX stage instruction to know which reg is being written  (0: A, 1: B)
    input  wire [2:0]  w_Data_S_R_EX,    // reg write data selection line for EX stage instruction (to check if data is from Mem) (0: Mem)
  
    
    // ---------- ID stage ----------
    input  wire [1:0]  R_ADD_A_ID,       // read address reg A for the ID stage instruction (Source register)
    input  wire [1:0]  R_ADD_B_ID,       // read address reg B for the ID stage instruction (Source register)

    // ---------- Outputs ----------
    output reg         FLUSH,
    output reg         STALL
);

// Select actual destination register
           wire [1:0]  W_add_previous;         // write address for EX stage instruction (destination register)
                assign W_add_previous = (W_add_S_EX) ? rb_addr_EX : ra_addr_EX;

always @(*) begin
    // defaults
    FLUSH = 1'b0;
    STALL = 1'b0;

    // ==============================
    // CONTROL HAZARDS → FLUSH
    // ==============================
    if (OPCODE_EX == 4'd9) begin
        if ((ra_addr_EX == 2'd0 && CCR[0]) ||  // JZ
            (ra_addr_EX == 2'd1 && CCR[1]) ||  // JN
            (ra_addr_EX == 2'd2 && CCR[2]) ||  // JC
            (ra_addr_EX == 2'd3 && CCR[3]))    // JV
            FLUSH = 1'b1;
    end

    else if (OPCODE_EX == 4'd10 && !CCR[0]) // LOOP
        FLUSH = 1'b1;

    else if (OPCODE_EX == 4'd11) // JMP, CALL, RET, RTI
        FLUSH = 1'b1;

    // ==============================
    // DATA HAZARD → STALL (Load-use) (RAW Memory Hazard)
    // ==============================
    if (W_E_R_EX && (w_Data_S_R_EX == 3'd0)) begin
        if ((W_add_previous == R_ADD_A_ID && R_ADD_A_ID != 2'b11) ||
            (W_add_previous == R_ADD_B_ID && R_ADD_B_ID != 2'b11))
            STALL = 1'b1;
    end
end
endmodule