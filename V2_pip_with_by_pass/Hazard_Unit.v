module Hazard_Unit (
    // ---------- EX stage ----------
    input  wire [7:0] OPCODE_EX,
    input  wire [1:0] ra_addr_EX,
    input  wire [3:0] CCR,

    input  wire        W_E_R_EX,         // write enable for EX stage instruction to check write in register (No Write -> No Hazard)
    input  wire [2:0]  w_Data_S_R_EX,    // reg write data selection line for EX stage instruction (to check if data is from Mem) (0: Mem)
    input  wire [1:0]  ra_add_EX,         // write address for EX stage instruction (destination register)
    input  wire [1:0]  rb_add_EX,         // write address for EX stage instruction (destination register)
    input wire  W_add_S_R,
    // ---------- ID stage ----------
    input  wire [1:0]  R_ADD_A_ID,       // read address reg A for the ID stage instruction (Source register)
    input  wire [1:0]  R_ADD_B_ID,       // read address reg B for the ID stage instruction (Source register)

    // ---------- Outputs ----------
    output reg         FLUSH,
    output reg         STALL
);
reg  [1:0] distination_prev;
always @(*) begin
    // defaults
    FLUSH = 1'b0;
    STALL = 1'b0;
   
   distination_prev=(W_add_S_R)? ra_add_EX :rb_add_EX;
    // ==============================
    // CONTROL HAZARDS → FLUSH
    // ==============================
    if (OPCODE_EX[7:4]== 4'd9) begin
        if ((ra_addr_EX == 2'd0 && CCR[0]) ||  // JZ
            (ra_addr_EX == 2'd1 && CCR[1]) ||  // JN
            (ra_addr_EX == 2'd2 && CCR[2]) ||  // JC
            (ra_addr_EX == 2'd3 && CCR[3]))    // JV
            FLUSH = 1'b1;
    end

    else if (OPCODE_EX[7:4] == 4'd10 && !CCR[0]) // LOOP
        FLUSH = 1'b1;

    else if (OPCODE_EX[7:4]== 4'd11) // JMP, CALL, RET, RTI
        FLUSH = 1'b1;

    // ==============================
    // DATA HAZARD → STALL (Load-use) (RAW Memory Hazard)
    // ==============================
    if (W_E_R_EX &&((w_Data_S_R_EX == 3'd0) ) ) begin
        if (((distination_prev==R_ADD_A_ID)&& R_ADD_A_ID != 2'b11) ||((distination_prev==R_ADD_B_ID)&& R_ADD_A_ID != 2'b11) )
            STALL = 1'b1;
    end
end

endmodule