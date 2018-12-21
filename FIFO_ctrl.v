
`timescale 1ns/1ps	

module FIFO_ctrl(
	input		wire			clk,				// 100MHz
	input 	wire			reset_n,			//复位信号，低有效
	input		wire			burst_syn,		//写FIFO同步信号
	input		wire			FIFO_clk,		//FIFO采样时钟输入
	input		wire			AD_sample_en,	//AD采样使能
	output	reg			ARM_data_ready,//数据准备完毕，ARM可以读取数据
	input		wire			ARM_read_over,//ARM读取数据结束
	input		wire			ARM_read_fifo_rdreq,//FIFO读请求
	input		wire			FIFO_EF,			//FIFO空标志,empty --> 0
	input		wire			FIFO_FF,			//FIFO满标志
	input		wire			FIFO_HF,			//FIFO半满标志 
	input		wire			FIFO_PAE,		//FIFO几乎空标志
	input		wire			FIFO_PAF,		//FIFO几乎满标志
	output	wire			FIFO_WCLK,		//FIFO写时钟
	output	wire			FIFO_RCLK,		//FIFO读时钟
	output	reg			FIFO_WEN,		//FIFO写使能,enable --> 0
	output	wire			FIFO_REN,		//FIFO读使能,enable --> 0
	output  	reg			MRS,				//FIFO复位,reset --> 0
	output	reg			LD,				//
	output	reg			OE,					//FIFO输出时能,enable --> 0
	 output reg[3:0] sss,
	 output reg flag,
	 output reg[2:0] state
	);
	
	
reg[2:0] reset_cnt;
	
	always@(posedge clk or negedge reset_n or negedge FIFO_reset_n)
	begin
		if((~reset_n) | (~FIFO_reset_n))
		begin
			MRS <= 1'b0;
			LD <= 1'b0;
//			RCLK <= 1'b0;
			OE <= 1'b1;
			reset_cnt <= 0;
		end
		else if (reset_cnt <= 2)
		begin
			reset_cnt <= reset_cnt +1'b1;
		end
		else if (reset_cnt <= 4)
		begin
			reset_cnt <= reset_cnt +1'b1;
			LD <= 1'b0;
			MRS <= 1'b1;
		end
		else
		begin
			LD <= 1'b1;
			MRS <= 1'b1;
			OE <= 1'b0;
		end
	end
//
//	parameter N = 2;
//	reg [N:0] ARM_read_over_tmp;
//	always@(posedge clk or negedge reset_n)
//	begin
//		if(~reset_n)
//		begin
//			ARM_read_over_tmp <= 0;
//		end
//		else
//		begin
//			ARM_read_over_tmp <= {ARM_read_over_tmp[N-1:0],ARM_read_over};
//		end
//	end
////	
	reg FIFO_reset_n;
////	
//	assign FIFO_reset_n = ARM_read_over_tmp[N-1] | (!ARM_read_over);
	
//测试程序：FIFO读比写延时一段时间
//reg FIFO_READ_EN;
//reg[9:0] cnt;
//	always@(posedge clk)
//	begin
//		if(~reset_n)
//		begin
//			FIFO_READ_EN <= 1'b0;
//			cnt <= 0;
//		end
//		else if(AD_sample_en)
	//		begin
//			if(cnt <= 10'd1000)
//			begin
//				cnt <= cnt + 10'd1;
//				FIFO_READ_EN <= 1'b0;
//			end
//			else
//			begin
//				FIFO_READ_EN <= 1'b1;
//			end
//		end
//		else
//		begin
//			cnt <= 0;
//			FIFO_READ_EN <= 1'b0;
//		end		
//	end
	
//reg FIFO_WEN_r;
//		
//	always@(posedge burst_syn)
//	begin
//		if (ARM_read_over && LD)
//		begin
//			FIFO_WEN_r <= 1'b1;
//		end
//		else
//		begin
//			FIFO_WEN_r <= 1'b0;
//		end 
//	end
assign FIFO_WCLK = FIFO_clk;
assign FIFO_RCLK = clk;
//assign FIFO_RCLK = ~ARM_read_fifo_rdreq;
//assign FIFO_WEN = ~(AD_sample_en & ARM_read_over & FIFO_WEN_r);
//assign FIFO_REN = ~AD_sample_en;
assign FIFO_REN = ~ARM_read_fifo_rdreq;
//assign FIFO_REN = 1'b0;
//assign ARM_data_ready = ~FIFO_FF;	
//assign ARM_data_ready = ~FIFO_PAF;
//assign FIFO_REN = ~FIFO_READ_EN;
//assign FIFO_REN = 1'b1;

parameter	WAIT					= 3'b001,
				FIFO_WRITE			= 3'b011,
				READ_WAIT			= 3'b010,
				READ_FIFO    	 	= 3'b110,
				FIFO_RESET			= 3'b111,
				FIFO_RESET_OVER	= 3'b101,
				WRITE_TMP			= 3'b100;
				
reg[12:0] cnt;

reg ARM_data_ready_tmp;
always@(negedge clk or negedge reset_n)
begin
	if(~reset_n)
	begin
//		ARM_data_ready_tmp <= 1'b0;
		ARM_data_ready <= 1'b0;
		FIFO_WEN <= 1'b1;
		FIFO_reset_n <= 1'b1;
		state <= WAIT;
		flag <= 1'b0;
		cnt <= 0;
		sss <= 4'd1;
	end
	else
	begin
		case(state)
			WAIT:
			begin
				if(AD_sample_en & ARM_read_over)
//				if(AD_sample_en)
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					flag <= 1'b0;
					state <= FIFO_WRITE;
					sss <= 4'd2;
				end
				else
				begin
//					ARM_data_ready_tmp <= ARM_data_ready_tmp;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					flag <= 1'b0;
					state <= WAIT;
					sss <= 4'd3;
				end
			end
			FIFO_WRITE:
			begin
				if(AD_sample_en )
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b0;
					FIFO_reset_n <= 1'b1;
					state <= FIFO_WRITE;
					flag <= 1'b0;
					sss <= 4'd4;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b1;
					ARM_data_ready <= 1'b1;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= READ_WAIT;
					flag <= 1'b0;
					sss <= 4'd5;
				end
			end
			READ_WAIT:
			begin
//				if(ARM_read_over & FIFO_PAE)
				if(~ARM_read_fifo_rdreq)
				begin
//					ARM_data_ready_tmp <= 1'b1;
					ARM_data_ready <= 1'b1;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					flag <= 1'b0;
					state <= READ_WAIT;
					sss <= 4'd6;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b1;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					flag <= 1'b1;
					state <= READ_FIFO;
					sss <= 4'd7;
				end
			end	
			READ_FIFO:
			begin
//				if(ARM_read_over & (~FIFO_PAE))
				if(ARM_read_over)
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= FIFO_RESET;
//					cnt <= 0;
					sss <= 4'd8;
					flag <= 1'b0;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
//					cnt <= cnt + 13'd1;
					state <= READ_FIFO;
					flag <= 1'b1;
					sss <= 4'd9;
				end
			end
			FIFO_RESET:
			begin
				if(LD)
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					state <= FIFO_RESET;
					FIFO_reset_n <= 1'b0; 
					flag <= 1'b0;
					sss <= 4'd10;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= FIFO_RESET_OVER;
					flag <= 1'b0;
					sss <= 4'd11;
				end
			end
			FIFO_RESET_OVER:
			begin
				if(LD)
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= WRITE_TMP;
					flag <= 1'b0;
					sss <= 4'd12;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= FIFO_RESET_OVER;
					flag <= 1'b0;
					sss <= 4'd13;
				end
			end
			WRITE_TMP:
			begin
				if(AD_sample_en)
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= WRITE_TMP;
					flag <= 1'b0;
					sss <= 4'd14;
				end
				else
				begin
//					ARM_data_ready_tmp <= 1'b0;
					ARM_data_ready <= 1'b0;
					FIFO_WEN <= 1'b1;
					FIFO_reset_n <= 1'b1;
					state <= WAIT;
					flag <= 1'b0;
					sss <= 4'd15;
				end
			end
			default:
			begin
//				ARM_data_ready_tmp <= 1'b0;
				ARM_data_ready <= 1'b0;
				FIFO_WEN <= 1'b1;
				FIFO_reset_n <= 1'b1;
				sss <= 4'd0;
				flag <= 1'b0;
				state <= FIFO_RESET;
			end
		endcase
	end
end

//assign ARM_data_ready = (ARM_read_over_tmp[2] | ARM_read_over) & ARM_data_ready_tmp;	
	
//parameter	WAIT	= 2'b00,
//				READY	= 2'b01,
//				READ	= 2'b10,
//				SDF =2'b11;
//				
////reg[2:0] state;
//wire start;
//
//assign start = AD_sample_en & ARM_read_over;
//
//always@(negedge clk or negedge reset_n)
//begin
//	if(~reset_n)
//	begin
//		ARM_data_ready <= 1'b0;
//		state <= WAIT;
//		sss <= 4'd9;
//	end
//	else
//	begin
//		case(state)
//			WAIT:
//			begin
//				if(start)
//				begin
//					ARM_data_ready <= 1'b0;
//					state <= READY;
//					sss <= 4'd1;
//				end
//				else
//				begin
//					ARM_data_ready <= 1'b0;
//					state <= WAIT;
//					sss <= 4'd3;
//				end
//			end
//			READY:
//			begin
//				if(AD_sample_en)
//				begin
//					ARM_data_ready <= 1'b0;
//					state <= READY;
//					sss <= 4'd5;
//				end
//				else
//				begin
//					ARM_data_ready <= 1'b1;
//					state <= READ;
//					sss <= 4'd4;
//				end
//			end
//			READ:
//			begin
//				if(~ARM_read_over)
//				begin				
//					ARM_data_ready <= 1'b0;
//					state <= WAIT;
//					sss <= 4'd10;
//				end
//				else
//				begin
//					ARM_data_ready <= 1'b1;
//					state <= READ;
//					sss <= 4'd7;
//				end
//			end
////			SDF:
////			begin
////				if(~FIFO_PAE)
////				begin				
////					ARM_data_ready <= 1'b0;
////					state <= WAIT;
////					sss <= 4'd10;
////				end
////				else
////				begin
////					ARM_data_ready <= 1'b1;
////					state <= SDF;
////					sss <= 4'd7;
////				end
////			end
//			default:
//			begin
//				ARM_data_ready <= 1'b0;
//				state <= WAIT;
//				sss <= 4'd8;
//			end
//		endcase
//	end
//end


endmodule