`timescale 1ns/1ps	
	
module Filter(
	input		wire			clk,			// 100MHz
	input 	wire			reset_n,		//复位信号，低有效
	input		wire[9:0]	pulse_period, //脉冲周期
	input    wire			AD_sample_en     ,//死区时间
	inout		wire			SDA_ASW,			// data 
	output	wire			SCL_ASW,			// clk 400KHz Max
	output	wire			RESET_ASW
		  );


//parameter pulse_period = 10'd25;

		  
reg[2:0]	ASW_Channel_r1;
reg[2:0]	ASW_Channel_r2;
		  
	always@(posedge clk)
	begin
		if(~reset_n)
		begin
			ASW_Channel_r1 <= 3'd0;
			ASW_Channel_r2 <= 3'd0;
		end
		else if ((pulse_period >=10'd146) && (pulse_period <=10'd437) )	//100-300kHz 
		begin
			ASW_Channel_r1 <= 3'd0;
			ASW_Channel_r2 <= 3'd7;
		end
		else if ((pulse_period >=10'd87) && (pulse_period <10'd146) )	//300-500kHz
		begin
			ASW_Channel_r1 <= 3'd1;
			ASW_Channel_r2 <= 3'd6;
		end
		else if ((pulse_period >=10'd58) && (pulse_period <10'd87) )	//500-750k	
		begin
			ASW_Channel_r1 <= 3'd2;
			ASW_Channel_r2 <= 3'd5;
		end
		else if ((pulse_period >=10'd43) && (pulse_period <10'd58) )	//750k-1MHz 
		begin
			ASW_Channel_r1 <= 3'd3;
			ASW_Channel_r2 <= 3'd4;
		end
		else if ((pulse_period >=10'd21) && (pulse_period <10'd43) )	//1-2MHz		
		begin
			ASW_Channel_r1 <= 3'd4;
			ASW_Channel_r2 <= 3'd3;
		end
		else if ((pulse_period >=10'd14) && (pulse_period <10'd21) )	//2-3MHz		
		begin
			ASW_Channel_r1 <= 3'd5;
			ASW_Channel_r2 <= 3'd2;
		end
		else if ((pulse_period >=10'd11) && (pulse_period <10'd14) )	//3-4MHz		
		begin
			ASW_Channel_r1 <= 3'd6;
			ASW_Channel_r2 <= 3'd1;
		end
		else if ((pulse_period >=10'd8) && (pulse_period <10'd11) )	//4-5MHz		
		begin
			ASW_Channel_r1 <= 3'd7;
			ASW_Channel_r2 <= 3'd0;
		end
		else
		begin
			ASW_Channel_r1 <= 3'd0;
			ASW_Channel_r2 <= 3'd0;
		end
	end

//assign ASW_Channel_r1 = 3'd7;				//TEST
//assign 			ASW_Channel_r2 = 3'd0;	//TEST
	
reg[1:0]	ASW_Addr;
reg 		startflag;
reg		startflag_r;
reg		I2C_startflag;
wire 		Stopflag;
	
	always@(negedge clk)
	begin
		if(~reset_n)
		begin
			startflag_r <= 1'b0;
			ASW_Addr  <= 2'd0;
		end
		else if(I2C_startflag)
		begin
			startflag_r <= 1'b1;
			ASW_Addr  <= 2'd0;
		end
		else if(Stopflag && (ASW_Addr <= 2'd3))
		begin
			startflag_r <= 1'b1;
			ASW_Addr <= ASW_Addr + 2'd1;
		end
//		else if(Stopflag && (ASW_Addr == 2'd3))
//		else if(ASW_Addr == 2'd3)
//		begin
//			startflag_r <= 1'b0;
//			ASW_Addr  <= 2'd0;
//		end
		else 
		begin
			startflag_r <= 1'b0;
		end
	end
	
	
reg[2:0]	ASW_Channel;

	always@(posedge clk)
	begin
		if(~reset_n)
		begin
			ASW_Channel <= 3'b0;
		end
		else if(ASW_Addr[1] ^~ ASW_Addr[0])
			ASW_Channel <= ASW_Channel_r2;
		else
			ASW_Channel <= ASW_Channel_r1;
	end
	
	
	always@(posedge clk)
	begin
		if(~reset_n)
		begin
			startflag <= 1'b0;
		end
		else 
		begin
			startflag <= startflag_r;
		end
	end

reg[9:0]	pulse_period_r = 0;
	
	always@(posedge clk)
	begin
		if(~reset_n)
		begin
//			pulse_period_r <= pulse_period;
			pulse_period_r <= 1'b0;
			I2C_startflag <= 1'b0;
		end
		else if(pulse_period_r == pulse_period)
		begin
			I2C_startflag <= 1'b0;
		end
		else
		begin
			pulse_period_r <= pulse_period;
			I2C_startflag <= 1'b1;
		end
	end
	
	
ADG715 	ADG715(.clk(clk),			// 100MHz
					.reset_n(reset_n),		//复位信号，低有效
					.startflag(startflag),
					.ASW_Addr(ASW_Addr),
					.ASW_Channel(ASW_Channel),
					.SDA_ASW(SDA_ASW_r),			// data 
					.SCL_ASW(SCL_ASW_r),			// clk 400KHz Max
					.RESET_ASW(RESET_ASW),
					.Stopflag(Stopflag)
					);

 assign SCL_ASW = SCL_ASW_r & (~AD_sample_en);
 assign SDA_ASW = SDA_ASW_r & (~AD_sample_en);
					
endmodule
					
