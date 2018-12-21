
`timescale 1ns/1ps

module AD5243(
	input		wire			clk,			// 100MHz
	input 	wire			reset_n,		//复位信号，低有效
	input		wire			AD_sample_en,
	input		wire[15:0]	ARM_I2CData,		//data for I2C write  Channel 2 + Channel 1
   inout		wire			HV_SDA,			// data 
	output	wire			HV_SCL			// clk 400KHz Max
        );
   
//parameter ARM_I2CData = 16'h0808;
	
reg	I2C_startflag;
reg	startflag;
reg	startflag_r;
wire	Stopflag;
reg	DP_NUM;

	always@(posedge clk)
	begin
		if(~reset_n)
		begin
			startflag_r <= 1'b0;
			DP_NUM  <= 1'b0;
		end
		else if(I2C_startflag)
		begin
			startflag_r <= 1'b1;
			DP_NUM  <= 1'b0;
		end
		else if(Stopflag && (DP_NUM <= 1'b1))
		begin
			startflag_r <= 1'b1;
			DP_NUM <= DP_NUM + 1'b1;
		end
		else 
		begin
			startflag_r <= 1'b0;
		end
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

reg[15:0] ARM_I2CData_r = 0;

	always@(posedge clk)
	begin
		if(~reset_n)
		begin
//			ARM_I2CData_r <= ARM_I2CData;
			ARM_I2CData_r <= 16'hffff;
			I2C_startflag <= 1'b0;
		end
		else if(ARM_I2CData_r == ARM_I2CData)
		begin
			I2C_startflag <= 1'b0;
		end
		else
		begin
			ARM_I2CData_r <= ARM_I2CData;
			I2C_startflag <= 1'b1;
		end
	end


reg[7:0] I2CAddr;
reg[7:0]	I2CData;
reg[7:0]	INSData;
	
	always@(posedge clk)
	begin
		if(!reset_n)
		begin
			I2CData <= 8'b00000000;
			INSData <= 8'b00000000;
			I2CAddr <= 8'b00000000;
		end
		else
		begin
			I2CAddr  <= 8'b01011110;
			if(DP_NUM == 1'b1)
			begin
				I2CData <= ARM_I2CData[7:0];
				INSData <= 8'b00000000;
			end
			else
			begin
				I2CData <= ARM_I2CData[15:8];
				INSData <= 8'b10000000;
			end
		end
	end
	
AD5243_I2C AD5243_I2C(.clk(clk),			
							.reset_n(reset_n),		
							.startflag(startflag),
							.I2CAddr(I2CAddr),		
							.I2CData(I2CData),
							.INSData(INSData),
							.HV_SDA(HV_SDA),			
							.HV_SCL(HV_SCL_r),			
							.Stopflag(Stopflag)
);

assign HV_SCL = HV_SCL_r & (~AD_sample_en);

endmodule
