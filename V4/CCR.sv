module CCR(

	input wire                  clk,     
    input wire                  rst,                // Clock and Reset for sequential logic in CCR 
    input wire                  saveF,              // save flages in [7:4] if interupt came
    input wire                  returnF,           // returen flags 
    input wire                  Z,N,C,V,             //Combinational output flags

    output wire		[3:0]		CCR_wire

);

reg [7:0] CCR;                      //Condition Code Register [V C N Z]

//Sequential logic to update CCR
always @(posedge clk or negedge rst) begin

    if (!rst) begin
        CCR <= 0;
    end
        
    else if (saveF) begin
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