module regExecuteMemory(
    input wire            clk,
    input wire     [7:0] opcode_ex,

    input wire [7:0]   Imm_EX,
    input wire [7:0]   Pc_plus1_EX,
    input wire [7:0]   ALU_out_EX,
    input wire [7:0]   Sp_EX,
    input wire [7:0]   reg_rb_EX,
    input  wire [7:0]  input_port_EX,

    input wire w_E_M_EX,
    input wire w_Add_S_M_EX,
    input wire w_Data_S_M_EX,
    input wire w_data_S_M_rb_EX,
    input wire w_Sp_EX,
    input wire Out_E_EX,

    input wire w_E_R_EX,
    input wire w_Add_S_R_EX,
    input wire [2:0] w_Data_S_R_EX,
    input wire 		[1:0]	ra_EX,
	input wire 		[1:0]	rb_EX,

    output reg [7:0] Imm_MEM,
    output reg [7:0] Pc_plus1_MEM,
    output reg [7:0] ALU_out_MEM,
    output reg [7:0] Sp_MEM,
    output reg [7:0] reg_rb_MEM,
    output reg [7:0]  input_port_MEM,

    output reg w_E_M_MEM,
    output reg w_Add_S_M_MEM,
    output reg w_Data_S_M_MEM,
    output reg w_data_S_M_rb_MEM,
    output reg w_Sp_MEM,
    output reg Out_E_MEM,

    output reg              w_E_R_MEM,
    output reg             w_Add_S_R_MEM,
    output reg      [2:0]  w_Data_S_R_MEM,
    output reg 		[1:0]	ra_MEM,
	output reg		[1:0]   rb_MEM,
     output reg      [7:0] opcode_mem
    
);

always @(posedge clk ) begin


        Imm_MEM           <= Imm_EX;
        Pc_plus1_MEM      <= Pc_plus1_EX;
        ALU_out_MEM       <= ALU_out_EX;
        Sp_MEM            <= Sp_EX;
        reg_rb_MEM        <= reg_rb_EX;
        w_E_M_MEM         <= w_E_M_EX;
        w_Add_S_M_MEM     <= w_Add_S_M_EX;
        w_Data_S_M_MEM    <= w_Data_S_M_EX;
        w_data_S_M_rb_MEM <= w_data_S_M_rb_EX;
        w_Sp_MEM          <= w_Sp_EX;
        Out_E_MEM         <= Out_E_EX;
        w_E_R_MEM         <= w_E_R_EX;
        w_Add_S_R_MEM     <= w_Add_S_R_EX;
        w_Data_S_R_MEM    <= w_Data_S_R_EX;
        ra_MEM            <= ra_EX;
        rb_MEM            <= rb_EX;
        input_port_MEM    <= input_port_EX;
         opcode_mem<=opcode_ex;

   
end

endmodule