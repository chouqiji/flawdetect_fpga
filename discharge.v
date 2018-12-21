module discharge(
	input		wire			clk,				// 100MHz
	input 	wire			reset_n,			//复位信号，低有效
	input		wire[15:0]	HVVoltage,
	output	reg 			discharge_ctrl		
);

reg[15:0]	HVVoltage_r;
reg			start;

always@(posedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
		HVVoltage_r <= 16'b0;
		start <=0;
	end
	else if (HVVoltage_r < HVVoltage)
	begin
		HVVoltage_r <= HVVoltage;
		start <= 1;
	end
	else
	begin
		HVVoltage_r <= HVVoltage;
		start <=0;
	end
end



parameter	WAIT			= 1'b0,
				DISCHARGE	= 1'b1;
				
reg state;
reg[31:0] discharge_counter;
always@(posedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
		discharge_ctrl <= 1'b0;
		discharge_counter <= 32'b0;
		state <= WAIT;
	end
	else
	begin
		case(state)
			WAIT:
			begin
				if(start)
				begin
					discharge_ctrl <= 1'b1;
					state <= DISCHARGE;
				end
				else
				begin
					discharge_ctrl <= 1'b0;
					state <= WAIT;
				end
			end
			DISCHARGE:
			begin
				if(discharge_counter >= 32'd300000000)
				begin
					discharge_ctrl <= 1'b0;
					discharge_counter <= 32'b0;
					state <= WAIT;
				end
				else
				begin
					discharge_ctrl <= 1'b1;
					discharge_counter <= discharge_counter + 32'b1;
					state <= DISCHARGE;
				end
			end
			default:
			begin
				discharge_ctrl <= 1'b0;
				state <= WAIT;
			end
		endcase
	end
end

endmodule