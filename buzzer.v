module buzzer(
	input 	wire			clk,
	input 	wire			reset_n,
	input		wire			alarm_en,
	output	reg 			buzzer_en
	);

	parameter T_1s = 32'd100_000_000;
	
	parameter WAIT = 1'b0,	
				 STATE_P =1'b1;
	
	reg[31:0] p_counter;
	reg state;
	
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			buzzer_en <= 1'b0;
			p_counter <= 1'b0;	
		end
		else
		begin
			case(state)
				WAIT:
				begin
					if(alarm_en)
					begin
						p_counter <= 1'b0;
						buzzer_en <= 1'b0;
						state <= STATE_P;
					end
					else
					begin
						p_counter <= 1'b0;
						buzzer_en <= 1'b0;
						state <= WAIT;
					end
				end
				STATE_P:
				begin
					if(p_counter >= T_1s)
					begin
						p_counter <= 32'd0;
						buzzer_en <= 1'b0;
						state <= WAIT;
					end
					else
					begin
						p_counter <= p_counter + 32'd1;
						buzzer_en <= 1'b1;
						state <= STATE_P;
					end				
				end
			endcase
		end
	end
	
endmodule