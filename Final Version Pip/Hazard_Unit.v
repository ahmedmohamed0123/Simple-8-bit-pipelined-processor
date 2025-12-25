module Hazard_Unit (
    // ---------- EX stage ----------
    input  wire [7:0] OPCODE_fetch,
     input  wire [7:0] OPCODE_memory,
     input wire [7:0]  OPCODE_EX,
     input  wire [7:0] OPCODE_ID,
     input  wire [1:0] ra_addr_fetch,
    input  wire [1:0] ra_addr_EX,
    input  wire [1:0] rb_addr_EX,
    input  wire        W_E_R_EX,         // write enable for EX stage instruction to check write in register (No Write -> No Hazard)
    input  wire        W_add_S_EX,       // write address select for the EX stage instruction to know which reg is being written  (0: A, 1: B)
    input  wire [2:0]  w_Data_S_R_EX,    // reg write data selection line for EX stage instruction (to check if data is from Mem) (0: Mem)
  
    
    // ---------- ID stage ----------
    input  wire [1:0]  R_ADD_A_ID,       // read address reg A for the ID stage instruction (Source register)
    input  wire [1:0]  R_ADD_B_ID,       // read address reg B for the ID stage instruction (Source register)

    // ---------- Outputs ----------
    output reg         STALL_pc,
    output reg         STALL
);


// Select actual destination register
           wire [1:0]  W_add_previous;         // write address for EX stage instruction (destination register)
                assign W_add_previous = (W_add_S_EX) ? rb_addr_EX : ra_addr_EX;
 
always @(*) begin
    // defaults
    STALL = 1'b0;
    STALL_pc=1'b0;
    // ==============================
    // DATA HAZARD → STALL (Load-use) (RAW Memory Hazard)
    // ==============================
    if (W_E_R_EX && (w_Data_S_R_EX == 3'd0)) begin
        if ((W_add_previous == R_ADD_A_ID && R_ADD_A_ID != 2'b11) ||(W_add_previous == R_ADD_B_ID && R_ADD_B_ID != 2'b11))
            STALL = 1'b1;
            STALL_pc=1'b1;
    end
        //RET & RTI 
    if (OPCODE_fetch[7:4] == 4'hB && (ra_addr_fetch == 2'b10 || ra_addr_fetch == 2'b11)  ) begin
        if(OPCODE_fetch!=OPCODE_memory)
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    //CALL
    if (OPCODE_fetch[7:4] == 4'hB &&  ra_addr_fetch == 2'b01 ) begin
        if(OPCODE_fetch!=OPCODE_memory)
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    // JZ 
    if(OPCODE_fetch[7:4]==4'h9 && ra_addr_fetch==2'b00 ) begin 
        if(OPCODE_fetch!=OPCODE_ID )
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    // JN 
       if(OPCODE_fetch[7:4]==4'h9 && ra_addr_fetch==2'b01 ) begin 
        if(OPCODE_fetch!=OPCODE_ID )
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    //JC 
      if(OPCODE_fetch[7:4]==4'h9 && ra_addr_fetch==2'b10 ) begin 
        if(OPCODE_fetch!=OPCODE_ID )
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    //JV 
      if(OPCODE_fetch[7:4]==4'h9 && ra_addr_fetch==2'b11 ) begin 
        if(OPCODE_fetch!=OPCODE_ID )
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    // JMp
    if(OPCODE_fetch[7:4]==4'hB && ra_addr_fetch==2'b00 ) begin 
         if(OPCODE_fetch!=OPCODE_ID )
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
    // LOOP 
     if(OPCODE_fetch[7:4]==4'hA  ) begin 
         if(OPCODE_fetch!=OPCODE_EX)
        STALL_pc = 1'b1;
        else 
        STALL_pc=1'b0;
    end
end
endmodule