module MEM_WB_Register (
    input  wire        clk,
    input  wire        rst_n,
    input  wire        stall,      // Stall signal to freeze pipeline stage
    input  wire        flush,      // Flush signal to clear pipeline stage
    
    // Inputs from MEM stage
    input  wire [7:0]  alu_out_MEM,
    input  wire [7:0]  mem_data_MEM,
    input  wire [7:0]  sp_MEM,
    input  wire [7:0]  imm_MEM,
    input  wire [7:0]  input_port_MEM,

    input  wire  [7:0]	R_ra_MEM,
    input  wire  [7:0]	R_rb_MEM,
    
    // Control signals from MEM stage
    input  wire        w_E_R_MEM,
    input  wire        w_Add_S_R_MEM,
    input  wire [2:0]  w_Data_S_R_MEM,
    input  wire        Out_E_MEM,        // Output port enable
    
    // Outputs to WB stage
    output reg  [7:0]  alu_out_WB,
    output reg  [7:0]  mem_data_WB,
    output reg  [7:0]  sp_WB,
    output reg  [7:0]  imm_WB,
    output reg  [7:0]  input_port_WB,

    output reg 	[7:0]	R_ra_WB,
    output reg 	[7:0]	R_rb_WB,

    // Control signals to WB stage
    output reg         w_E_R_WB,
    output reg         w_Add_S_R_WB,
    output reg  [2:0]  w_Data_S_R_WB,
    output reg         Out_E_WB          // Output port enable
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin

            alu_out_WB     <= 8'h00;
            mem_data_WB    <= 8'h00;
            sp_WB          <= 8'h00;
            imm_WB         <= 8'h00;
             
            R_ra_WB        <= 8'h00;
            R_rb_WB        <= 8'h00;
              
            w_E_R_WB       <= 1'b0;
            w_Add_S_R_WB   <= 1'b0;
            w_Data_S_R_WB  <= 3'h0;
            Out_E_WB       <= 1'b0;
        end
        
        else if (flush) begin
        
            alu_out_WB     <= 8'h00;
            mem_data_WB    <= 8'h00;
            sp_WB          <= 8'h00;
            imm_WB         <= 8'h00;

            R_ra_WB        <= 8'h00;
            R_rb_WB        <= 8'h00;

            w_E_R_WB       <= 1'b0;
            w_Add_S_R_WB   <= 1'b0;
            w_Data_S_R_WB  <= 3'h0;
            Out_E_WB       <= 1'b0;
        end
        
        else if (!stall) begin
            
            alu_out_WB     <= alu_out_MEM;
            mem_data_WB    <= mem_data_MEM;
            sp_WB          <= sp_MEM;
            input_port_WB  <= input_port_MEM;
            imm_WB         <= imm_MEM;

            R_ra_WB        <= R_ra_MEM ;
            R_rb_WB        <= R_rb_MEM ;
                    
            w_E_R_WB       <= w_E_R_MEM;
            w_Add_S_R_WB   <= w_Add_S_R_MEM;
            w_Data_S_R_WB  <= w_Data_S_R_MEM;
            Out_E_WB       <= Out_E_MEM;
        end
       
    end

endmodule