///////////////////////////////////////////////////////////////////////////////////
//模块名称：	pulse_gen
//文件名称：	pulse_gen.v
//编写时间：	2012-4-25 9:13:11
//编码    ：	ld
//功能描述：	
//	脉冲控制模块
// 参考Trigger.v

`timescale 1ns/100ps

module pulse_gen(
	input		wire			clk          ,
	input		wire			reset_n	     ,
	input		wire[9:0]	pulse_period ,//脉冲周期
	input		wire[5:0]	pulse_num    ,//脉冲个数
	input    wire[5:0]	dead_num     ,//死区时间
	input		wire			burst_syn    ,//同步信号
	input		wire			protect_en,
	output	reg			CH0_H,
	output	reg 			CH0_L,
	output	reg			CH1_H,
	output	reg			CH1_L
//	output	reg[3:0]			state_wr
	);//脉冲输出

//	parameter	pulse_period 	= 10'd9,
//					pulse_num	   = 6'd4,
//					dead_num			= 10'd3;
//					protect_en		=	1'b0; //TEST
	
	reg	[31:0]	p_counter;
	reg	[9:0]		freq_div_counter = 0;
	reg	[5:0]		pulse_counter = 0;
	reg	[3:0]		state_wr = 0;									
	
	parameter T_1s = 32'd100_000_000;
	
	parameter	STATE_IDLE  = 3'h0,
				   STATE_H	    = 3'h1,
				   STATE_DEAD1 = 3'h2,
				   STATE_L	    = 3'h3,
					STATE_DEAD2 = 3'h4,
				   STATE_QUIT  = 3'h5,
				   STATE_P     = 3'h6;
					
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			freq_div_counter <= 0;
			pulse_counter <= 0;
			p_counter <= 32'd0;
			state_wr <= STATE_IDLE;
		end
		else
		begin
			case(state_wr)
				STATE_IDLE:
				begin
					freq_div_counter <= 6'h0;
					pulse_counter <= 4'h0;
					p_counter <= 32'd0;
					if(burst_syn)
					begin
						state_wr <= STATE_H;
					end
					else
					begin
						state_wr <= STATE_IDLE;
					end
				end
				STATE_H:
				begin
					if(protect_en)
					begin
						freq_div_counter <= 6'h0;
						pulse_counter <= 4'h0;
						p_counter <= 32'd0;
						state_wr <= STATE_P;
					end
					else if(freq_div_counter >= pulse_period-1)
					begin
						state_wr <= STATE_DEAD1;
						freq_div_counter <= 6'h0;
						p_counter <= 32'd0;
					end
					else
					begin
						freq_div_counter <= freq_div_counter + 6'h1;
						p_counter <= 32'd0;
						state_wr <= STATE_H;
					end
				end
				STATE_DEAD1:
				begin
					if(protect_en)
					begin
						freq_div_counter <= 6'h0;
						pulse_counter <= 4'h0;
						p_counter <= 32'd0;
						state_wr <= STATE_P;
					end
					else if(freq_div_counter >= dead_num-6'h1)  
					begin
							state_wr <= STATE_L;
							p_counter <= 32'd0;
							freq_div_counter <= 0;
					end
					else 
					begin
						freq_div_counter <= freq_div_counter + 6'h1;
						p_counter <= 32'd0;
						state_wr <= STATE_DEAD1;
					end
				end
				STATE_L:
				begin
					if(protect_en)
					begin
						freq_div_counter <= 6'h0;
						pulse_counter <= 4'h0;
						p_counter <= 32'd0;
						state_wr <= STATE_P;
					end
					else
					begin
						if(freq_div_counter >= pulse_period-1)
						begin
							state_wr <= STATE_DEAD2;
							p_counter <= 32'd0;
							freq_div_counter <= 6'h0;
						end
						else
						begin
							state_wr <= STATE_L;
							p_counter <= 32'd0;
							freq_div_counter <= freq_div_counter +6'h1;
						end
					end
				end
				STATE_DEAD2:
				begin
					if(protect_en)
					begin
						freq_div_counter <= 6'h0;
						pulse_counter <= 4'h0;
						p_counter <= 32'd0;
						state_wr <= STATE_P;
					end
					else if(freq_div_counter >= dead_num-8'd1)  
					begin
						if(pulse_counter >= pulse_num-8'd1) 
						begin
							state_wr <= STATE_QUIT;
							p_counter <= 32'd0;
							pulse_counter <= 0;
						end
						else 
						begin
							state_wr <= STATE_H;
							p_counter <= 32'd0;
							freq_div_counter <= 0;
							pulse_counter <= pulse_counter + 6'd1;
						end
					end
					else  
					begin
						state_wr <= STATE_DEAD2;
						p_counter <= 32'd0;
						freq_div_counter <= freq_div_counter +6'h1;
					end
				end
				STATE_P:
				begin
					freq_div_counter <= 6'h0;
					pulse_counter <= 4'h0;
					if(p_counter >= T_1s)
					begin
						p_counter <= 32'd0;
						state_wr <= STATE_IDLE;
					end
					else
					begin
						p_counter <= p_counter + 32'd1;
						state_wr <= STATE_P;
					end
					
				end
				STATE_QUIT:
				begin
					if(~burst_syn)
					begin
						state_wr <= STATE_IDLE;
					end
					else
					begin
						state_wr <= STATE_QUIT;	
					end			
				end
				default:
				begin
					freq_div_counter <= 0;
					pulse_counter <= 0;
					p_counter <= 32'd0;
					state_wr <= STATE_IDLE;
				end
				endcase
		end
	end
	
	
/**********************************************************************/
//状态输出

always@(posedge clk or negedge reset_n)
begin
	if(~reset_n) 
	begin
		{CH0_H,CH0_L}   <= 2'b01;
		{CH1_H,CH1_L}   <= 2'b01;
	end
	else
		case(state_wr) //synopsys parallel_case
			STATE_IDLE,STATE_QUIT:
				begin
					{CH0_H,CH0_L}   <= 2'b01;
					{CH1_H,CH1_L}   <= 2'b01;
				end
			STATE_H:
				begin
					{CH0_H,CH0_L}   <= 2'b10;
					{CH1_H,CH1_L}   <= 2'b01;
				end
			STATE_L:
				begin
					{CH0_H,CH0_L}   <= 2'b01;
					{CH1_H,CH1_L}   <= 2'b10;
				end
			STATE_DEAD1:
				begin
					{CH0_H,CH0_L}   <= 2'b00;
					{CH1_H,CH1_L}   <= 2'b00;			
				end
			STATE_DEAD2:
				begin
					if(pulse_counter == pulse_num-8'd1) 
					begin
						{CH0_H,CH0_L}   <= 2'b01;
						{CH1_H,CH1_L}   <= 2'b00;			
					end
					else 
					begin
						{CH0_H,CH0_L}   <= 2'b00;
						{CH1_H,CH1_L}   <= 2'b00;	
					end
				end		
			STATE_P:
				begin
					{CH0_H,CH0_L}   <= 2'b01;
					{CH1_H,CH1_L}   <= 2'b01;
				end
			default:
				begin
					{CH0_H,CH0_L}   <= 2'b01;
					{CH1_H,CH1_L}   <= 2'b01;
				end
		endcase
end	

endmodule