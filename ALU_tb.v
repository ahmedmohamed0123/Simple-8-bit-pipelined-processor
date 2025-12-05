module alu_tb();
 reg clk, rst;                 //Clock and Reset for sequential logic in CCR 
 reg signed [7:0] A, B;
 reg  [3:0] ALU_opcode;
 wire signed [7:0] out;    //Combinational output
wire  Z,N,C,V ;

ALU dut(.clk(clk),.rst(rst),.A(A),.B(B),.ALU_opcode(ALU_opcode),.out(out),.Z(Z),.N(N),.C(C),.V(V)); // instance of Design
 
 parameter MAXPOS = 127 ;
 parameter MAXNEG=-128;

 initial begin 
    clk=0;
    forever begin
        #2 clk=~clk;
    end
 end

 initial begin 
    rst=1;
    @(negedge clk);
    rst=0;

    //check corner cases for (ADD,SUB,INC,DEC,LOOP)
    ALU_opcode=4'b0001; //--> ADD
    A=MAXPOS;  B=MAXPOS;
    @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==1 && dut.CCR[2]==0 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end

     A=MAXPOS;  B=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==1 && dut.CCR[2]==1 && dut.CCR[3]==0) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end

    A=MAXNEG;  B=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==1 && dut.CCR[1]==0 && dut.CCR[2]==1 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d, B=%d",A,B);
    end

     ALU_opcode=4'b0010; //--> SUB
    A=MAXPOS;  B=MAXPOS;
    @(negedge clk);
    if(dut.CCR[0]==1 && dut.CCR[1]==0 && dut.CCR[2]==0 && dut.CCR[3]==0) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end

     A=MAXPOS;  B=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==1 && dut.CCR[2]==0 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end

    A=MAXNEG;  B=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==1 && dut.CCR[1]==0 && dut.CCR[2]==0 && dut.CCR[3]==0) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d, B=%d",A,B);
    end

     ALU_opcode= 4'b1011; //--> INC
     B=MAXPOS;
     @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==1 && dut.CCR[2]==0 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end

      ALU_opcode= 4'b1100; //--> DEC
     B=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==0 && dut.CCR[2]==1 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end
     
      ALU_opcode= 4'b1101; //--> loop
     A=MAXNEG;
     @(negedge clk);
    if(dut.CCR[0]==0 && dut.CCR[1]==0 && dut.CCR[2]==1 && dut.CCR[3]==1) begin 
        $display("Correct output !");
    end
    else begin 
        $display ("error at A=%d , B=%d at time=%t",A,B,$time);
    end
    $stop;
 end
endmodule