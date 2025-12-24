module MEM_WB_Register (
    input  wire        clk,
    input wire  [7:0] opcode_mem,
    // Inputs from MEM stage
    input  wire [7:0]  alu_out_MEM,
    input  wire [7:0]  mem_data_MEM,
    input  wire [7:0]  Sp_MEM,
    input  wire [7:0]  imm_MEM,
    input  wire [7:0]  input_port_MEM,

    input  wire  [7:0]	R_ra_MEM,
    input  wire  [7:0]	R_rb_MEM,
    
    // Control signals from MEM stage
    input  wire        w_E_R_MEM,
    input  wire        w_Add_S_R_MEM,
    input  wire [2:0]  w_Data_S_R_MEM,
    input  wire        Out_E_MEM,        // Output port enable
    
    input wire 		[1:0]	rb_MEM,
    input wire 		[1:0]	ra_MEM,
    
    // Outputs to WB stage
    output reg  [7:0]  alu_out_WB,
    output reg  [7:0]  mem_data_WB,
    output reg  [7:0]  Sp_WB,
    output reg  [7:0]  imm_WB,
    output reg  [7:0]  input_port_WB,

    output reg 	[7:0]	R_ra_WB,
    output reg 	[7:0]	R_rb_WB,

    // Control signals to WB stage
    output reg         w_E_R_WB,
    output reg         w_Add_S_R_WB,
    output reg  [2:0]  w_Data_S_R_WB,
    output reg         Out_E_WB,         // Output port enable

    output reg 		[1:0]	rb_WB,
    output reg      [1:0]	ra_WB,
    output reg    [7:0] opcode_wb
);

    always @(posedge clk ) begin
       
            alu_out_WB     <= alu_out_MEM;
            mem_data_WB    <= mem_data_MEM;
            Sp_WB         <= Sp_MEM;
            input_port_WB  <= input_port_MEM;
            imm_WB         <= imm_MEM;

            R_ra_WB        <= R_ra_MEM ;
            R_rb_WB        <= R_rb_MEM ;
                    
            w_E_R_WB       <= w_E_R_MEM;
            w_Add_S_R_WB   <= w_Add_S_R_MEM;
            w_Data_S_R_WB  <= w_Data_S_R_MEM;
            Out_E_WB       <= Out_E_MEM;
            rb_WB      <=rb_MEM;
            ra_WB        <=ra_MEM;
             opcode_wb<=opcode_mem;
       
    end

endmodule