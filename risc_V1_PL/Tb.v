module TB ();
	reg 			clk,rst_n;
	reg 			interrupt; 
	reg		[7:0]	In_port;
	wire	[7:0]	Out_port;
	
Top T1(
	.clk(clk),
	.rst_n(rst_n), 
	.interrupt(interrupt),
	.input_port(In_port),
	.Out_port(Out_port)
	);

always #10 clk=~clk;
 
 always @(*) begin 
	if(T1.Opcode==8'hff)  
		interrupt=1;
		else 
		interrupt=0;
end 

initial begin
	clk=0;
	rst_n=1;
	 repeat(100) begin
     @(posedge clk) 
	if(T1.Opcode==8'hff)  
		interrupt=1;
		else 
		interrupt=0;
	 end

	#400;
	$stop;
end 

endmodule