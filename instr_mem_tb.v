module instr_mem_tb;

    reg        clk;
    reg  [7:0] PC;
    wire [7:0] instr;
    wire [7:0] next_byte;

    
    instr_mem dut (
        .clk(clk),
        .PC(PC),
        .instr(instr),
        .next_byte(next_byte)
    );

    
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin
      
        PC = 8'd0;
        #10;
        $display("%h\t%h\t\t%h",  PC, instr, next_byte);
        
      
        PC = 8'd1;
        #10;
        $display("%h\t%h\t\t%h",  PC, instr, next_byte);
        
    
        PC = 8'd2;
        #10;
        $display("%h\t%h\t\t%h", PC, instr, next_byte);
        
      
        PC = 8'd10;
        #10;
        $display("%h\t%h\t\t%h",  PC, instr, next_byte);
       
        
        PC = 8'd50;
        #10;
        $display("%h\t%h\t\t%h",  PC, instr, next_byte);
        
        
        PC = 8'd1;
        #10;
        $display("%h\t%h\t\t%h",  PC, instr, next_byte);
        
       
        PC = 8'd0;
        #10;
        $display("%0t\t%h\t%h\t\t%h", $time, PC, instr, next_byte);
       
        #50;
        $stop;
    end
    
endmodule
