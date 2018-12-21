///////////////////////////////////////////////////////////////////////////////////
//模块名称：	AD_clk_gen
//文件名称：	AD_clk_gen.v
//编写时间：	2012-4-24 23:22:42
//编码    ：	ld
//功能描述：	
//	AD时钟控制模块
`timescale 1ns/100ps
module AD_clk_gen(
	input		wire			clk,				// 100MHz
	input		wire			clk_sample_delay,
	input 	wire			reset_n,			//复位信号，低有效
	input		wire			burst_syn,
	input		wire[6:0]	AD_clk_div_num,//AD分频数
	input  	wire[31:0]	AD_sample_length,//AD采样深度
	output 	reg 			AD_sample_en,	//采样使能  1 --> enable 0 --> disable
	output	wire			AD_clk,			//AD时钟
	output	wire			FIFO_clk,
	output	wire			AD_PDWN,			//休眠模式
	output	wire			AD_OE_N,			//AD使能,
	output	wire			AD_DFS,			//输出模式选择
	input		wire			AD_DCO
);

//parameter AD_clk_div_num = 7'd2;
//			 AD_sample_length = 20'd70000;


//============================================================
//---产生AD采样控制信号，输出到AD芯片的时钟信号，只有在需要采集数据的时候输出，采集结束后置零---
parameter	STATE_IDLE		= 2'd0,
				STATE_SAMPLE	= 2'd1,
				STATE_QUIT		= 2'd2;
					
	reg[31:0] counter;
	reg[1:0] state; 
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			AD_sample_en <= 0;
			counter <= 0;
			state <= STATE_IDLE;
		end
		else
		begin
			case(state)
				STATE_IDLE:
				begin
					if(burst_syn)
					begin
						AD_sample_en <= 1;
						counter <= 0;
						state <= STATE_SAMPLE;
					end
					else
					begin
						AD_sample_en <= 0;
						counter <= 0;
						state <= STATE_IDLE;
					end
				end
				STATE_SAMPLE:
				begin
					if(counter < AD_sample_length )
					begin
						AD_sample_en <= 1;
						counter <= counter + 20'b1;
						state <= STATE_SAMPLE;
					end
					else
					begin
						AD_sample_en <= 0;
						counter <= 0;
						state <= STATE_QUIT;
					end
				end
				STATE_QUIT:
				begin
					if(~burst_syn)
					begin
						AD_sample_en <= 0;
						counter <= 0;
						state <= STATE_IDLE;
					end
					else
					begin
						AD_sample_en <= 0;
						counter <= 0;
						state <= STATE_QUIT;
					end
				end
				
				default:
				begin
					AD_sample_en <= 0;
					counter <= 0;
					state <= STATE_IDLE;
				end
			endcase
		end
	end
	
assign AD_OE_N = ~AD_sample_en;
	
//产生AD的采样时钟--------------------------------------
reg[19:0] clk_counter = 0;
reg[6:0] clk_div_counter = 0;
wire clk_div;
	
	always@(posedge clk_sample_delay)
	begin
		if(~reset_n)
		begin
			clk_counter <= 0;
			clk_div_counter <= 0;
		end
		else if(clk_div_counter >= (AD_clk_div_num - 1))
		begin
			clk_div_counter <= 0;
			clk_counter <= clk_counter + 1'b1;//时钟数计数
		end
		else
		begin
			clk_div_counter <= clk_div_counter + 1'b1; //分频产生时钟
		end
	end
assign clk_div = (AD_clk_div_num == 1) ? clk_sample_delay : (clk_div_counter < AD_clk_div_num[6:1]);
	
	
//产生fifo的读取时钟--------------------------------------
reg[19:0] fifo_clk_counter = 0;
reg[6:0] fifo_clk_div_counter = 0;
wire fifo_clk_div;
	
	always@(posedge clk)
	begin
		if(~reset_n)
		begin
			fifo_clk_counter <= 0;
			fifo_clk_div_counter <= 0;
		end
		else if(fifo_clk_div_counter >= (AD_clk_div_num - 1))
		begin
			fifo_clk_div_counter <= 0;
			fifo_clk_counter <= fifo_clk_counter + 1'b1;//时钟数计数
		end
		else
		begin
			fifo_clk_div_counter <= fifo_clk_div_counter + 1'b1; //分频产生时钟
		end
	end	

assign fifo_clk_div = (AD_clk_div_num == 1) ? clk : (fifo_clk_div_counter < AD_clk_div_num[6:1]);
	
assign AD_clk = clk_div;
assign FIFO_clk = fifo_clk_div;
//assign AD_PDWN = ~AD_sample_en;
assign AD_PDWN = 1'b0;
assign AD_DFS = 1'b0;
endmodule