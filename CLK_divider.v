// clock divider module           
module CLK_divider(clk_in, clk_out, clk_div);

	input clk_in;
	input [31:0] clk_div;
	output reg clk_out = 0;				// set ouput clock to 0 initially 
	
	reg [31:0] counter = 32'h0;		// hex counter to keep track of clock cycles
	
	always@(posedge clk_in) begin 
		if (counter < clk_div) begin 
			counter = counter + 1; 		// increment counter until divider value is reached
		end 
			else begin 
				counter = 0;				// reset counter
				clk_out = ~clk_out;		// change value of output clock
			end 
	end 

endmodule

	