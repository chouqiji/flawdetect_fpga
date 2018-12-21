
`timescale 1ns/1ps

module AD5243_I2C(
	input		wire			clk,			// 100MHz
	input 	wire			reset_n,		//复位信号，低有效
   input 	wire			startflag,
	input 	wire[7:0]	I2CAddr,		//device address for I2C write
	input		wire[7:0]	I2CData,		//data for I2C write
	input		wire[7:0]	INSData,		//data for INS
   inout		wire			HV_SDA,			// data 
	output	wire			HV_SCL,			// clk 400KHz Max
	output	reg			Stopflag
        );
    
 
//---------------------------------------------
//分频部分
reg[2:0] cnt;   		// cnt=0:SCL上升沿，cnt=1:SCL高电平中间，cnt=2:SCL下降沿，cnt=3:SCL低电平中间
reg[8:0] cnt_delay;	//500循环计数，产生iic所需要的时钟

 
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		cnt_delay <= 9'd0;
   else if(cnt_delay == 9'd499)
		cnt_delay <= 9'd0;  //计数到5us为SCL的周期，即200KHz
   else
		cnt_delay <= cnt_delay+1'b1;    //时钟计数
end 
 
 
always @ (posedge clk or negedge reset_n)
begin
	if(!reset_n)
		cnt <= 3'd5;
	else
	begin 
		case(cnt_delay)
			9'd124: cnt <= 3'd1; //cnt=1:SCL高电平中间,用于数据采样
			9'd255: cnt <= 3'd2; //cnt=2:SCL下降沿后面点
			9'd374: cnt <= 3'd3; //cnt=3:SCL低电平中间,用于数据变化
			9'd495: cnt <= 3'd0; //cnt=0:SCL上升沿前面点
			default: cnt <= 3'd5;
		endcase
	end
end
 
`define SCL_POS     (cnt==3'd0)     //cnt=0:SCL上升沿前面点
`define SCL_HIG     (cnt==3'd1)     //cnt=1:SCL高电平中间,用于数据采样
`define SCL_NEG     (cnt==3'd2)     //cnt=2:SCL下降沿后面点
`define SCL_LOW     (cnt==3'd3)     //cnt=3:SCL低电平中间,用于数据变化
 
reg SCL_r;
always@(posedge clk or negedge reset_n)
begin
	if(!reset_n)
		SCL_r <= 1'b0;
   else if(cnt_delay==9'd499)
		SCL_r <= 1'b1;    //SCL信号上升沿
   else if(cnt_delay==9'd249)
		SCL_r <= 1'b0;    //SCL信号下降沿
end
				//时钟脉冲寄存器   
assign HV_SCL = SCL_r; //产生iic所需要的时钟

  
 
reg[7:0] db_r;      //在IIC上传送的数据寄存器


//---------------------------------------------
        //读、写时序
parameter   IDLE    = 12'b0000_0000_0001;//初始态
parameter   START1  = 12'b0000_0000_0010;//起始信号
parameter   ADD1    = 12'b0000_0000_0100;//写入器件地址
parameter   ACK1    = 12'b0000_0000_1000;//应答
parameter	INS	  = 12'b0000_0001_0000;//命令
parameter	ACK2	  = 12'b0000_0010_0000;//应答
parameter   DATA    = 12'b0000_0100_0000;//写入字节地址
parameter   ACK3    = 12'b0000_1000_0000;//应答
parameter   ACKR    = 12'b0001_0000_0000;//fpga给应答
parameter   STOP    = 12'b0010_0000_0000;//停止位
 
 
reg[15:0] state;   //状态寄存器
reg SDA_r;      //输出数据寄存器
reg SDA_link;   //输出数据SDA信号inout方向控制位       
reg[3:0] num;   //读写的字节计数

//---------------------------------------状态机---------------------------------------------//
always@(posedge clk or negedge reset_n) 
begin
	if(!reset_n) 
	begin
		state <= IDLE;
		SDA_link <= 1'b0;
		SDA_r <= 1'b1;
		num <= 4'd0;

	end
	else 
	begin
		case(state)
			IDLE:
			begin
				SDA_link <= 1'b1;            //数据线SDA为output
				SDA_r <= 1'b1;
				Stopflag <= 1'b0;
				if(startflag) 
				begin              
					db_r <= I2CAddr;                       //送器件地址（写操作）
					state <= START1;        
				end
				else 
				begin
					state <= IDLE; 
				end
			end
			START1: 
			begin
         if(`SCL_HIG)
				begin      //SCL为高电平期间
					SDA_link <= 1'b1;    //数据线SDA为output
					SDA_r <= 1'b0;       //拉低数据线SDA，产生起始位信号
					state <= ADD1;
					num <= 4'd0;     //num计数清零
				end
				else
					state <= START1; //等待SCL高电平中间位置到来
			end
         ADD1:   
			begin
				if(`SCL_LOW) 
				begin
					if(num == 4'd8) 
					begin   
						num <= 4'd0;        		//num计数清零
						SDA_r <= 1'b1;
						SDA_link <= 1'b0;			//SDA置为高阻态(input)
						state <= ACK1;
					end
					else 
					begin
						state <= ADD1;
						num <= num+1'b1;
						case (num)
							4'd0: SDA_r <= db_r[7];
							4'd1: SDA_r <= db_r[6];
							4'd2: SDA_r <= db_r[5];
							4'd3: SDA_r <= db_r[4];
							4'd4: SDA_r <= db_r[3];
							4'd5: SDA_r <= db_r[2];
							4'd6: SDA_r <= db_r[1];
							4'd7: SDA_r <= db_r[0];
							default: ;
						endcase
					end
				end
				else 
				begin
					state <= ADD1;
				end
         end
			ACK1:	
			begin
				if(`SCL_NEG) 
				begin      //从机响应信号
					state <= INS;  //写操作
					db_r <= INSData;    //写入的数据1                            
				end 
				else
				begin
					state <= ACK1; //等待从机响应
				end
			end
			INS:
			begin   //写操作
				if(`SCL_LOW) 
				begin
					if(num == 4'd8) 
					begin   
						num <= 4'd0;        		//num计数清零
						SDA_r <= 1'b1;
						SDA_link <= 1'b0;			//SDA置为高阻态(input)
						state <= ACK2;
					end
					else 
					begin
						SDA_link <= 1'b1;			//SDA置为output
						state <= INS;
						num <= num+1'b1;
						case (num)
							4'd0: SDA_r <= db_r[7];
							4'd1: SDA_r <= db_r[6];
							4'd2: SDA_r <= db_r[5];
							4'd3: SDA_r <= db_r[4];
							4'd4: SDA_r <= db_r[3];
							4'd5: SDA_r <= db_r[2];
							4'd6: SDA_r <= db_r[1];
							4'd7: SDA_r <= db_r[0];
							default: ;
						endcase
					end
				end
				else
				begin
					state <= DATA;
				end
			end
			
			ACK2:	
			begin
				if(`SCL_NEG) 
				begin      //从机响应信号
					state <= DATA;  //写操作
					db_r <= I2CData;    //写入的数据1                            
				end 
				else
				begin
					state <= ACK2; //等待从机响应
				end
			end
			DATA:
			begin   //写操作
				if(`SCL_LOW) 
				begin
					if(num == 4'd8) 
					begin   
						num <= 4'd0;        		//num计数清零
						SDA_r <= 1'b1;
						SDA_link <= 1'b0;			//SDA置为高阻态(input)
						state <= ACK3;
					end
					else 
					begin
						SDA_link <= 1'b1;			//SDA置为output
						state <= DATA;
						num <= num+1'b1;
						case (num)
							4'd0: SDA_r <= db_r[7];
							4'd1: SDA_r <= db_r[6];
							4'd2: SDA_r <= db_r[5];
							4'd3: SDA_r <= db_r[4];
							4'd4: SDA_r <= db_r[3];
							4'd5: SDA_r <= db_r[2];
							4'd6: SDA_r <= db_r[1];
							4'd7: SDA_r <= db_r[0];
							default: ;
						endcase
					end
				end
				else
				begin
					state <= INS;
				end
			end
			
			ACK3:
			begin                                     //写操作最后个应答
				if(`SCL_NEG)
				begin
					state <= STOP;                     
				end
				else
				begin
					state <= ACK3;
				end
			end
			STOP:
			begin
				if(`SCL_LOW)
				begin
					SDA_link <= 1'b1;
					SDA_r <= 1'b0;
					state <= STOP;
				end
				else if(`SCL_HIG)
				begin
					SDA_r <= 1'b1;   //SCL为高时，SDA产生上升沿（结束信号）
					state <= IDLE;
					Stopflag <= 1'b1;
				end
				else
					state <= STOP;		
			end
         default: state <= IDLE;
      endcase
	end
end
 
assign HV_SDA = SDA_link ? SDA_r:1'bz;

 
endmodule
