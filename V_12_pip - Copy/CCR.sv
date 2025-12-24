module CCR(

	input wire                  clk,      
    input wire                  saveF,               // Save flages in [7:4] if interupt came
    input wire                  returnF,             // Return flags 
    input wire                  Z,N,C,V,             // Combinational output flags (from ALU)

    output wire		[3:0]		CCR_wire

);

reg [7:0] CCR;                      //Condition Code Register [V C N Z]

//Sequential logic to update CCR
always @(posedge clk ) begin

     
    if (saveF) begin
        CCR[7:4] <=  CCR [3:0];
    end

    else if (returnF) begin
       CCR [3:0] <= CCR [7:4];
    end

    else begin
        CCR [3:0] <= {V,C,N,Z};
    end
    
        
end

assign CCR_wire = CCR;

endmodule 