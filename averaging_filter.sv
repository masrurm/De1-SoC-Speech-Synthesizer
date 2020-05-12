module averaging_filter (clk, audio_data, LED, start);

input clk;
input [7:0] audio_data;
input start;
output [7:0] LED;

reg [8:0] counter = 9'b0;		//counter to keep track of number of audio_data
reg [7:0] val;						//temporary register to store audio_data value
reg [15:0] sum = 16'b0; 		//sum

reg [2:0] state;

parameter idle 				= 3'b000;
parameter absolute_value	= 3'b001;
parameter check_counter		= 3'b100;
parameter output_led			= 3'b101;
parameter reset_register	= 3'b110;

always @(posedge clk) begin
	case(state)
	
	//idle until new audio data is received
	idle:
		if (start) 
			state <= absolute_value;
	
	//check if audio is a negative value and perform absolute_value
	absolute_value: begin
		val <= audio_data[7]? -audio_data : audio_data;
		state <= check_counter;
	end
	
	//checks counter to see if 256 values have been read
	check_counter: begin
		// if counter < 256, then add to sum and loop
		if (counter < 9'd256) begin
			counter <= counter + 8'd1;
			sum <= sum + val;
			state <= idle;
		end
		else begin
			sum <= sum >> 8;				// divide by 256 (right shift 8 bits)
			state <= output_led;
		end
	end
	
	// outputs LEDs based on sum value
	output_led: begin
		// priority encoder to light up LEDs
		if (sum[7] == 1) 
			LED <= 8'b1111_1111;
		else if (sum[6] == 1) 
			LED <= 8'b1111_1110;
		else if (sum[5] == 1)
			LED <= 8'b1111_1100;
		else if (sum[4] == 1)
			LED <= 8'b1111_1000;		
		else if (sum[3] == 1)
			LED <= 8'b1111_0000;
		else if (sum[2] == 1)
			LED <= 8'b1110_0000;
		else if (sum[1] == 1)
			LED <= 8'b1100_0000;
		else if (sum[0] == 1)
			LED <= 8'b1000_0000;
		else
			LED <= 8'b0000_0000;
		
		state <= reset_register;
	end
	
	// resets counter and sum registers
	reset_register: begin
		counter <= 9'b0;
		sum <= 16'b0;
		state <= idle;
	end
	
	endcase
end

endmodule

