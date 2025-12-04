module tb_DataMEM();

    reg        clk;
    reg        WE;
    reg        RE;
    reg [7:0]  A;
    reg [7:0]  WD;
    wire [7:0] RD;

    DataMEM DUT (
        .Clk(clk),
        .WE(WE),
        .RE(RE),
        .A(A),
        .WD(WD),
        .RD(RD)
    );

    
     initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end

    initial begin

        // init
        WE  = 0;
        A   = 0;
        WD  = 0;
        RE  = 0;
        #10;

        $display("=== START TEST ===");

        A = 8'h00; 
        RE=1;
        #10;        
        $display("RD = %h ", RD);

        A = 8'h01;  
        #10;
        $display("RD = %h ", RD);

        A = 8'h02;  
        #10;
        $display("RD  = %h ", RD);

    
        // WRITE test
        $display("Writing 0xAA to address 50h...");
        A  = 8'h50;
        WD = 8'hAA;
        WE = 1;
        #10;        
        WE = 0;

        // read it back 
        A = 8'h50;
        #10;
        $display("RD @ 50 = %h (should be AA)", RD);

        
        // Test multiple reads
        A = 8'h05; #10;
        $display("RD @ 05 = %h", RD);

        A = 8'h06; #10;
        $display("RD @ 06 = %h", RD);

        #20;
        $display("=== END TEST ===");
        $stop;
    end

endmodule

