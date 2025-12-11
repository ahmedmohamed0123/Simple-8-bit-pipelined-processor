module TB ();
	reg 			clk,rst_n;
	reg 			interrupt; 
	reg		[7:0]	In_port;

	wire	[7:0]	Out_port;
	

Top T1(
	.clk(clk),
	.rst_n(rst_n),
	.In_port(In_port),
	.Out_port(Out_port)
	);

always #5 clk=~clk;

initial begin
	clk=0;
	rst_n=1;
	#10;



	#400;

	$finish;
end 




endmodule
