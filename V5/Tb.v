module TB ();
	reg 			clk,rst_n;
	reg 			interrupt; 
	reg		[7:0]	In_port;

	wire	[7:0]	Out_port;
	

Top T1(
	.clk(clk),
	.rst_n(rst_n), 
	.interrupt(interrupt),
	.In_port(In_port),
	.Out_port(Out_port)
	);
initial begin 
	clk=0;
	forever 
	#2 clk=~clk;
end

initial begin
	
	rst_n=1;
	In_port=8'hE;
	/*
	 repeat(100) begin
     @(posedge clk ) 
	if(T1.Opcode==8'hff)  
		interrupt=1;
		else 
		interrupt=0;
	 end
	 */


	#400;

	$finish;
end 




endmodule
