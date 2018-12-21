
`timescale 1ns/100ps
module Electromagnetic_Acoustic(
//------------Global Signals------------------
	input		wire			clk_sys,
//	input		wire			clk_coder,
	input		wire			clk_sample_delay,	
	input		wire			RESET_N,
//-------------ARM interface------------------
	input		wire[7:0]	ARM_A,
	inout		wire[15:0]	ARM_D,
	input		wire			iARM_CE_N, 
	input		wire			iARM_OE_N,				//nOE (Output Enable) indicates that the current bus cycle is a read cycle.
	input		wire			iARM_WE_N,				//nWE (Write Enable) indicates that the current bus cycle is a write cycle.		
//------------DA0 interface-------------------	
	output	wire			oDA_SCLK,	
	output	wire			oDA_DOUT,	
	output	wire			oDA_SYNC_n,  
	output	wire			oDA_LDAC_n,  
//------------AD9246 interface----------------
	output	wire			oAD_CLK,		//max = 40Mhz
	input		wire			iAD_DCO,
	output	wire			oAD_OE_N,
	output	wire			oAD_PDWN,
	output 	wire			oAD_DFS,
//------------FIFO interface------------------
	input		wire[13:0]	FIFO_DATA,		//
	input		wire			AD_or,		//out of range 
	input		wire			FIFO_EF,			
	input		wire			FIFO_FF,			
	input		wire			FIFO_HF, 
	input		wire			FIFO_PAE,		
	input		wire			FIFO_PAF,		
	output	wire			FIFO_WCLK,	
	output	wire			FIFO_RCLK,		
	output	wire			FIFO_WEN,	
	output	wire			FIFO_REN,		
	output	wire			MRS,	
	output	wire			LD,
	output	wire			OE,
//-----------Coder interface------------------
	input		wire			CoderInputA,
	input		wire			CoderInputB,		
//-----------T/R interface-----------------
	input		wire[5:0]	protect_in,		//protect
	output	wire			CH0_H,
	output	wire			CH0_L,
	output	wire			CH1_H,
	output	wire			CH1_L,
	output   wire        receive_amp_en,
	inout		wire			SDA_ASW,			
	output	wire			SCL_ASW,	
	output	wire			RESET_ASW,	
	output	wire 			Probe_mode,
	output 	wire			buzzer_en,
//------------High Power---------------------
	output	wire			CHARGH_H,				//1 --> CHARGE
	output	wire			CHARGH_L,				//1 --> CHARGE
	inout		wire			HV_SDA,			
	output	wire			HV_SCL,
	input		wire			FAULT_L,					//0 --> FAULT
	input		wire			FAULT_H,					//0 --> FAULT
	input		wire			DONE_L,					//0 --> DONE
	input		wire			DONE_H,					//0 --> DONE
	output	wire			discharge_ctrl,				//1 --> Discharge
//-----------POWER interface-----------------
	input		wire 			pow_key_det,		//System Power Key Detect
	output	wire 			powen_sys,			//System POWER ON/OFF Control 1 --> ON; 0 --> OFF
	output	wire 			powen_mosfet,		//Mosfet Driver(20V) control 1 --> ON; 0 --> OFF
	output	reg			pow_key_det_arm	//System Power Key Detect to ARM
);

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX										
//---------------ARM ---------------------			
	
	//ARM  读信号--------------------------------
	wire			ARM_read;
	wire			ARM_read_fifo_clk;
	wire[9:0]	ARM_read_fifo_data;
	reg [15:0]	ARM_read_data;

	assign	ARM_read	= ~iARM_CE_N & ~iARM_OE_N;
	assign	ARM_D		=	ARM_read	 ?  ARM_read_data : 16'hzzzz;	
	
	//assign ARM_read_fifo_clk = ARM_read&&(ARM_A[7:2] == 6'h20);//posedge ARM_read
	
	reg ARM_read_buf = 0;
	reg ARM_read_buf2 = 0;
	wire  ARM_read_fifo_rdreq;
	
	always@(posedge clk_sys)
	begin
		if(!RESET_N)
		begin
			ARM_read_buf <= 0;
			ARM_read_buf2 <= 0;
		end
		else
		begin
			ARM_read_buf <= ARM_read;
			ARM_read_buf2 <= ARM_read_buf;
		end
	end
	//assign ARM_read_fifo_rdreq =(!ARM_read_buf2&ARM_read_buf)&&(ARM_A[7:2] == 6'h20);//posedge ARM_read
	
	assign ARM_read_fifo_rdreq =(!ARM_read_buf2)&ARM_read_buf&ARM_A[7]&(!ARM_A[6])&(!ARM_A[5])&(!ARM_A[4])&(!ARM_A[3])&(!ARM_A[2])&(!ARM_A[1])&(!ARM_A[0]);//posedge ARM_readassign test2 = ARM_read_fifo_rdreq;
	
	
	//ARM 读数据
	//ARM_read_fifo_data						
	wire ARM_data_ready;
	wire protect_state;	
	//wire [9:0]ARM_MAX_data;				
//wire signed[31:0]	CoderPosition;		
	always @ ( * )
	begin
		case ( ARM_A[7:0] )
			8'h80:ARM_read_data = {2'd0,FIFO_DATA};
			8'h84:ARM_read_data = {15'h0,ARM_data_ready};
//			6'h22:ARM_read_data = CoderPosition[15:0];
//			6'h23:ARM_read_data = CoderPosition[31:16];
			8'h88:ARM_read_data = {10'h0,protect_state};
//			6'h23:ARM_read_data = 0;
			default: ARM_read_data = 0;
		endcase
	end

	//ARM 写数据-----------------------------------------------------

	reg[2:0]		burst_period;			
	reg[31:0]	AD_sample_length;	
	reg[9:0]		pulse_period;			
	reg[5:0]		pulse_num;				
	reg[11:0]	gain_ctrl;			//D = 4096 * V /3.3 
	reg[11:0]	protect_current;	//D = 4096 * 0.01 * I /3.3  			
	reg[6:0]		AD_clk_div_num;	
	reg 	   	PositionClear_n;
	reg[5:0]		dead_num;	
	reg[15:0]	HVVoltage = 16'hffff;		
//	reg[15:0]	alarm_AM;				
	reg			ARM_read_over; 		
	reg 			ARM_powdn_cmd;		
	reg			alarm_en;				
	reg 			probe_mode_r;	
	reg[15:0]	ARM_I2CData;		//data for I2C write  Channel 2 + Channel 1	

	always@(negedge iARM_WE_N)
	begin
		if(!iARM_CE_N)//片选
		begin
			case(ARM_A[7:0])//地址选择
				8'h2c:burst_period[2:0]        	<= ARM_D[ 2:0];	//重复周期 0=>0hz 1=>1hz 2=>5hz 3=>10hz 4=>50hz 5=>100hz 6=>200hz 7=>400hz
				8'h04:AD_sample_length[31:16]  	<= ARM_D[15:0];	//采样深度 0-64000
				8'h08:AD_sample_length[15:0 ]  	<= ARM_D[15:0];	//采样深度 0-64000	
				8'h0c:pulse_period[9:0]        	<= ARM_D[ 9:0];	//脉冲周期
				8'h10:pulse_num[5:0]           	<= ARM_D[ 5:0];	//脉冲个数
				8'h14:gain_ctrl[11:0]         	<= ARM_D[11:0];	//增益 D = 4096 * V /3.3 
				8'h18:protect_current[11:0]      <= ARM_D[11:0];	//保护电流值  D = 4096 * 0.01 * I /3.3
				8'h1c:AD_clk_div_num[6:0]      	<= ARM_D[ 6:0];	//AD分频数
				8'h20:PositionClear_n           	<= ARM_D[   0];	//
				8'h24:dead_num[5:0]   				<= ARM_D[ 5:0];	//死区时间
				8'h28:HVVoltage[15:0]     			<= ARM_D[15:0];	//高压值
//				8'h2c:alarm_AM[15:0]           	<= ARM_D[15:0];	// 
				8'h30:ARM_read_over            	<= ARM_D[	0];	//ARM读FIFO数据结束  1-->读数完毕
				8'h34:ARM_powdn_cmd            	<= ARM_D[	0];	//ARM关机信号  1-->关机
				8'h38:alarm_en            	   	<= ARM_D[	0];	//
				8'h3c:probe_mode_r            	<= ARM_D[	0];	//探头模式选择  1-->双探头   0-->单探头
				default:;
			endcase
		end
	end
	
//	assign FAULT_H = ARM_data_ready;
//	assign FAULT_L = ARM_read_over;
//	assign FAULT_L = protect_in[0];
//	assign FAULT_H = protect_in[1];
	assign Probe_mode = probe_mode_r;
//	assign Probe_mode = 1'b0;	//test
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX		
//---------------关机控制程序-----------------
	
	reg [31:0] 	pow_key_det_cnt = 0;
	reg [31:0] 	powdn_delay_cnt = 0;
	reg 			FPGA_powdn_cmd = 0;
	reg 			Sys_powdn_r = 0;
	reg [16:0]  div_cnt = 0;
	reg 			powdn_cnt_puls = 0;
	
	always @(posedge clk_sys)
	begin
		if(!RESET_N)
		begin
			div_cnt <= 0;
			powdn_cnt_puls <= 0;
		end
		else if(div_cnt<100_000)
		begin
			div_cnt <=  div_cnt +1'b1;
			powdn_cnt_puls <= 0;
		end
		else 
		begin
			div_cnt <= 0;
			powdn_cnt_puls <= 1;
		end		
	end
	
	
	reg pow_key_det_buf1 = 0;
	reg pow_key_det_buf2 = 0;		
	always @(posedge clk_sys)
	begin
		if(!RESET_N)
		begin
			pow_key_det_cnt <= 0;
			FPGA_powdn_cmd <= 0;
			Sys_powdn_r <= 1;
		end
		else if(powdn_cnt_puls)
		begin
			pow_key_det_buf1 <= pow_key_det;
			pow_key_det_buf2 <= pow_key_det_buf1;
			if({pow_key_det_buf2,pow_key_det_buf1} == 2'b00)
			begin 
				pow_key_det_cnt <=  pow_key_det_cnt + 32'b1;
				if ( pow_key_det_cnt > 10_000 ) //timeout shutdown (ms)
					FPGA_powdn_cmd <= 1;
			end
			else 
				pow_key_det_cnt <= 0;
				
			if(ARM_powdn_cmd || FPGA_powdn_cmd)//ARM和FPGA的任意一个关机命令都可导致关机
				powdn_delay_cnt <= powdn_delay_cnt + 1'b1;
			else 
				powdn_delay_cnt <= powdn_delay_cnt;
			if(powdn_delay_cnt > 4_000 )	//delay 1s shutdown (ms)
				Sys_powdn_r <= 0;
			else
				Sys_powdn_r <= 1;
		end
	end
	
	assign powen_sys = Sys_powdn_r; 
//	assign powen_sys = 1'b1; 	//test

reg[31:0] 	key_det_cnt;

	always @(posedge clk_sys)
	begin
		if(!RESET_N)
		begin
			pow_key_det_arm <= 1;
			key_det_cnt <= 0;
		end
		else if((~pow_key_det) && (key_det_cnt < 32'd200_000_000))
		begin
			key_det_cnt <=  key_det_cnt +1'b1;
			pow_key_det_arm <= 1;
		end
		else if((~pow_key_det) && (key_det_cnt == 32'd200_000_000))
		begin
			pow_key_det_arm <= 0;
		end
		else 
		begin
			key_det_cnt <= 0;
			pow_key_det_arm <= 1;
		end		
	end
	
//	assign pow_key_det_arm = pow_key_det;

	
	
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//--------------------------编码器控制-------------------------	
//wire [31:0]	CoderPosition;
//Coder Coder_u(
//	.clk				(clk_coder			),
//	.reset_n			(RESET_N				),
//	.CountClear_n	(PositionClear_n	),
//	.SignalA			(CoderInputA		),
//	.SignalB			(CoderInputB		),
//	.dout				(CoderPosition		)
//);


//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX		
//---------------同步信号-------------------------

	wire burst_syn;	//同步脉冲
	
	burst_syn_ctrl burst_syn_ctrl(
		.clk_sys	 	(clk_sys			),
		.reset_n		 	(RESET_N				),
		.burst_period	(burst_period		),
		.burst_syn		(burst_syn			)
		);
	
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//-------------------------脉冲发射模块-----------------------
//pulse_num：脉冲数量
//pulse_period：脉冲周期    
//dead_num：死区时间   
//f=100M/(pulse_period+dead_num)/2;

	wire protect_en;
	pulse_gen	pulse_gen(	
		.clk				(clk_sys		),
		.reset_n			(RESET_N			),
		.pulse_period	(pulse_period	),
		.pulse_num		(pulse_num		),
		.dead_num		(dead_num		),
		.burst_syn		(burst_syn		),
		.protect_en		(protect_en		),
		.CH0_H			(CH0_H			),
		.CH0_L			(CH0_L			),
		.CH1_H			(CH1_H			),
		.CH1_L			(CH1_L			),
		);
		
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//-------------------------放电-----------------------

discharge discharge(	.clk(clk_sys),				// 100MHz
							.reset_n(RESET_N),			//复位信号，低有效
							.HVVoltage(HVVoltage),
							.discharge_ctrl(discharge_ctrl)
						);

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//--------------------高压输出电压控制-----------------------

AD5243 AD5243(.clk(clk_sys),			// 100MHz
				.reset_n(RESET_N),		//复位信号，低有效
				.AD_sample_en(AD_sample_en	),
				.ARM_I2CData(HVVoltage),		//data for I2C write  Channel 2 + Channel 1
				.HV_SDA(HV_SDA),			// data 
				.HV_SCL(HV_SCL)			// clk 400KHz Max
        );
		
	assign CHARGH_H = (~AD_sample_en)& (~discharge_ctrl);
	assign CHARGH_L = (~AD_sample_en)& (~discharge_ctrl);
	
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//-------------------------过流保护-----------------------
//protect_en：1-protect,2-unpeotect;
 wire	 FreqFlag;
 
 assign FreqFlag = (pulse_period >=10'd40) ? 1'b1 : 1'b0;// >1MHz  FreqFlag = 0
 
	protect	protect(	
		.clk			(clk_sys		),
		.reset_n		(RESET_N		),
		.triggerP	(CH0_H		),
		.triggerN	(CH1_H		),
		.FreqFlag	(FreqFlag	),
		.Probe_mode	(Probe_mode	),
		.protect_in	(protect_in	),
		.protect_en	(protect_en	),
		.protect_state(protect_state)
		);

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//-------------------------蜂鸣器-----------------------	
	
	 buzzer 	buzzer(
		.clk(clk_sys),
		.reset_n(RESET_N),
		.alarm_en(alarm_en),
		.buzzer_en(buzzer_en)
		);
		
//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX	
//-------------------------滤波器网络通道选择-----------------------	
		
Filter Filter(.clk(clk_sys),			
				.reset_n(RESET_N),		
				.pulse_period(pulse_period),
				.AD_sample_en(AD_sample_en	),
				.SDA_ASW(SDA_ASW),			 
				.SCL_ASW(SCL_ASW),
				.RESET_ASW(RESET_ASW)			
				);
	

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX			
//-------------------------DA控制-----------------------------	
//AD5322

	wire AD5322_en;
	AD5322 AD5322(
		.clk				(clk_sys   		),//less than 150MHz
		.rst_n			(RESET_N			),
		.en				(AD5322_en		),
		.ChannelA_data	(gain_ctrl		),
		.ChannelB_data	(protect_current),
		.sclk				(oDA_SCLK		),
		.dout				(oDA_DOUT		),
		.sync_n			(oDA_SYNC_n		),
		.ldac_n			(oDA_LDAC_n		)	
		);	
		
	assign AD5322_en = ~AD_sample_en; //DA使能				

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//--------------------------AD控制器------------------------
//AD9246

//wire Avg_Sram_full;
wire AD_clk;			//AD采样时钟
wire FIFO_clk;
wire AD_sample_en;	//1 --> enable 0 --> disable
//assign oAD_CLK= AD_clk & AD_sample_en;
//assign oAD0_CLK= clk_sample & AD_sample_en;
assign oAD_CLK= AD_clk;

AD_clk_gen AD_clk_gen(
		.reset_n				(RESET_N),
		.clk					(clk_sys		),
		.clk_sample_delay	(clk_sample_delay),
		.burst_syn			(burst_syn		),
		.AD_clk_div_num	(AD_clk_div_num),
		.AD_sample_length	(AD_sample_length),
		.AD_sample_en		(AD_sample_en	),
		.AD_clk				(AD_clk),
		.FIFO_clk			(FIFO_clk),
		.AD_PDWN				(oAD_PDWN),			
		.AD_OE_N				(oAD_OE_N),
		.AD_DFS				(oAD_DFS),		
		.AD_DCO				(iAD_DCO)
		);					

	
FIFO_ctrl FIFO_ctrl(
		.clk						(clk_sys),
		.reset_n					(RESET_N),
		.burst_syn				(burst_syn		),
		.FIFO_clk				(FIFO_clk),
		.AD_sample_en			(AD_sample_en),
		.ARM_data_ready		(ARM_data_ready),
		.ARM_read_over			(ARM_read_over),
		.ARM_read_fifo_rdreq (ARM_read_fifo_rdreq),
		.FIFO_EF					(FIFO_EF),
		.FIFO_FF					(FIFO_FF),
		.FIFO_HF					(FIFO_HF),
		.FIFO_PAE				(FIFO_PAE),
		.FIFO_PAF				(FIFO_PAF),
		.FIFO_WCLK				(FIFO_WCLK),
		.FIFO_RCLK				(FIFO_RCLK),
		.FIFO_WEN				(FIFO_WEN),
		.FIFO_REN				(FIFO_REN),
		.MRS						(MRS),
		.LD						(LD),
		.OE						(OE)
		);

//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
//电源控制

	assign powen_mosfet   =  Sys_powdn_r ? 1'b1 : 1'b0;    
//	assign powen_mosfet   =  1'b1;
//	assign receive_amp_en = AD_sample_en;	//1 --> enable 0 --> disable
	assign receive_amp_en = 1'b1;




//assign receive_gain_ctrl = 1'b1;

endmodule