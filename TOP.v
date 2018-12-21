
module TOP (
//SYSTEM
	input 	wire 			FPGA_CLK_SYS, 					//Oscillator Clock 50M
	input 	wire			RESET_IN,						//Reset input
	
//ARM BUS   wire
	input 	wire			ARM_WEn,
	input 	wire			ARM_OEn,
	input 	wire			ARM_CE,
	input 	wire[7:0]	ARM_ADDR,
	inout		wire[15:0] 	ARM_DATA,
	
//DAC AD5322	
	output  wire			DA_LDAC,
	output  wire			DA_DIN,
	output  wire			DA_SYNC,
	output  wire			DA_SCLK,
	
//ADC AD9246
	output 	wire			AD_CLK,
	input		wire			AD_DCO,
	output	wire			AD_OE_N,
	output	wire			AD_PDWN,
	output 	wire			AD_DFS,
	
//FIFO
	input 	wire[13:0]	FIFO_D,				//FIFO Data
	input 	wire			AD_OR,				//Out of Range
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
	
//Coder
	input		wire			CODER_A,
	input		wire			CODER_B,
	input		wire			CODER_C,
	input		wire			CODER_D,
	
	input 	wire			ENCODER_A,
	input		wire			ENCODER_B,
	input		wire			ENCODER_SW_OUT,
	
	input 	wire			Temp_Protect1,
	input 	wire			Temp_Protect2,
	input		wire			Temp_ProtectMOS,
	
//EMAT T/R	
	input		wire			IOV_HIGH_P,
	input		wire			IOV_LOW_P,
	input		wire			IOV_HIGH_C_P,
	
	output	wire			CH0_H,				
	output	wire			CH0_L,
	output	wire			CH1_H,
	output	wire			CH1_L,
		
	inout		wire			SDA_ASW,					// data 
	output	wire			SCL_ASW,					// clk 400KHz Max
	output	wire			RESET_ASW,				//reset
	output 	wire			PROBE_MODE,				//probe mode change: 1 --> Double Mode; 0 --> Sigle Mode
	output 	wire 	      receive_amp_en,		//enable amplifier
	output   wire			receive_gain_ctrl,
	input		wire			ARM_gain_ctrl,

//High Power	
	output	wire			CHARGH_H,				//1 --> CHARGE
	output	wire			CHARGH_L,				//1 --> CHARGE
	inout		wire			HV_SDA,			
	output	wire			HV_SCL,
	input		wire			FAULT_L,					//0 --> FAULT
	input		wire			FAULT_H,					//0 --> FAULT
	input		wire			DONE_L,					//0 --> DONE
	input		wire			DONE_H,					//0 --> DONE
	output	wire			Discharge,				//1 --> Discharge
		
//Power
	input 	wire			KEY_DET,					//System Power Key Detect
	output 	wire			KEY_CTRL,				//System POWER ON/OFF Control 1 --> ON; 0 --> OFF
	output 	wire			PWDN_MOSFET,			//Mosfet Driver(20V) control 1 --> ON; 0 --> OFF
	output	wire			KEY_DET_ARM,			//System Power Key Detect to ARM
	
//Peripheral
	output 	wire[7:1] 	FPGA_GPIO,				//FPGA GPIO, connected with ARM
	output 	wire			FPGA_BUZZER,				//BUZZER Control Signal
	output	reg			LCDBL_EN
	);


//	assign LCDBL_EN = PWDN_MOSFET;
//	assign LCDBL_EN = 1'b1;
reg[31:0] LCD_cnt;

always@(posedge clk_sys or negedge RESET_N)
	begin
		if(~RESET_N)
		begin
			LCDBL_EN = 1'b0;
			LCD_cnt <= 0;
		end
		else if (LCD_cnt <= 200000000)
		begin
			LCD_cnt <= LCD_cnt +1'b1;
		end
		else
		begin
			LCDBL_EN = 1'b1;
		end
	end

	//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	//---------------clk sources from PLL----------------------
	wire	clk_100_delay;
	wire	clk_100;
	wire	clk_coder;
	wire	clk_sys;								
	wire	clk_sample_delay;	
	wire	RESET_N;	
		
	sys_pll sys_pll(
		.inclk0(FPGA_CLK_SYS),
		.c0    (clk_100),
		.c1    (clk_100_delay)
//		.c2    (clk_coder),
		);
		
//	sys_pll2 sys_pll2(
//		.inclk0(FPGA_CLK_SYS),
//		.c0    (clk_100_delay)
//		);
		
	assign clk_sys = clk_100;					
	assign clk_sample_delay = clk_100_delay;
//	assign clk_sample_delay = clk_100;
	
//	assign FPGA_BUZZER = 1'b0;
	
	assign RESET_N = ~RESET_IN; 
	
	assign FPGA_GPIO[2] = ENCODER_A;
	assign FPGA_GPIO[3] = ENCODER_B;
	assign FPGA_GPIO[1] = ENCODER_SW_OUT;
	
	assign FPGA_GPIO[4] = CODER_A;
	assign FPGA_GPIO[5] = CODER_B;
	assign FPGA_GPIO[6] = CODER_C;
	assign FPGA_GPIO[7] = CODER_D;
	
	assign receive_gain_ctrl = ARM_gain_ctrl;
	
	
	
	//XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
	Electromagnetic_Acoustic Electromagnetic_Acoustic(
		//------------Global Signals------------------
		.clk_sys				(clk_sys			),
//		.clk_coder			(clk_coder		),
		.clk_sample_delay	(clk_sample_delay),
//		.clk_sample_delay	(clk_sys),
		.RESET_N				(RESET_N			),
		//-------------ARM interface------------------			
		.ARM_A				(ARM_ADDR		),
		.ARM_D				(ARM_DATA		),
		.iARM_CE_N			(ARM_CE			), 
		.iARM_OE_N			(ARM_OEn			),//nOE (Output Enable) indicates that the current bus cycle is a read cycle.
		.iARM_WE_N			(ARM_WEn			),//nWE (Write Enable) indicates that the current bus cycle is a write cycle.
		//------------DA0 interface-------------------	
		.oDA_SCLK			(DA_SCLK			),	
		.oDA_DOUT			(DA_DIN			),	
		.oDA_SYNC_n			(DA_SYNC			),  
		.oDA_LDAC_n			(DA_LDAC			),  
		//------------AD9246 interface----------------
		.oAD_CLK				(AD_CLK			),//max = 40Mhz
		.iAD_DCO				(AD_DCO			),
		.oAD_OE_N			(AD_OE_N			),
		.oAD_PDWN			(AD_PDWN			),
		.oAD_DFS				(AD_DFS			),
		//-----------FIFO interface-------------------
		.FIFO_DATA			(FIFO_D			),
		.AD_or				(AD_OR			),//out of range
		.FIFO_EF				(FIFO_EF			),
		.FIFO_FF				(FIFO_FF			),
		.FIFO_HF				(FIFO_HF			),
		.FIFO_PAE			(FIFO_PAE		),
		.FIFO_PAF			(FIFO_PAF		),
		.FIFO_WCLK			(FIFO_WCLK		),
		.FIFO_RCLK			(FIFO_RCLK		),
		.FIFO_WEN			(FIFO_WEN		),
		.FIFO_REN			(FIFO_REN		),
		.MRS					(MRS				),
		.LD					(LD				),
		.OE					(OE				),
		//-----------Coder interface-----------------
		.CoderInputA		(CODER_A			),
		.CoderInputB		(CODER_B			),
		//-----------T/R interface-----------------
		.protect_in			({Temp_ProtectMOS,Temp_Protect2,Temp_Protect1,1'b1,IOV_HIGH_P,IOV_LOW_P}),
		.CH0_H				(CH0_H			),
		.CH0_L				(CH0_L			),
		.CH1_H				(CH1_H			),
		.CH1_L				(CH1_L			),
		.receive_amp_en 	(receive_amp_en),
		.SDA_ASW				(SDA_ASW			),			 
		.SCL_ASW				(SCL_ASW			),
		.RESET_ASW			(RESET_ASW		),
		.Probe_mode			(PROBE_MODE		),
		.buzzer_en			(FPGA_BUZZER	),
		//High Power
		.HV_SDA				(HV_SDA			),			
		.HV_SCL				(HV_SCL			),
		.CHARGH_H			(CHARGH_H		),
		.CHARGH_L			(CHARGH_L		),
		.DONE_H				(DONE_H			),
		.DONE_L				(DONE_L			),
		.FAULT_H				(FAULT_H			),
		.FAULT_L				(FAULT_L			),
		.discharge_ctrl	(Discharge		),
		//-------------POWER interface------------------
		.pow_key_det		(KEY_DET			),
		.powen_sys			(KEY_CTRL		),
		.powen_mosfet		(PWDN_MOSFET	),
		.pow_key_det_arm	(KEY_DET_ARM	)		
		);
	
	 
	
endmodule 