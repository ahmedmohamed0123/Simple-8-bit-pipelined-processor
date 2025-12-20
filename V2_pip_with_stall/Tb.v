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
 

initial begin
	clk=1;
	rst_n=0;
	@(negedge clk);
	rst_n=1;
	#1000;
	$stop;
end 

endmodule