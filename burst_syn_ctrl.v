///////////////////////////////////////////////////////////////////////////////////
//ģ�����ƣ�	burst_syn_ctrl
//�ļ����ƣ�	burst_syn_ctrl.v
//��дʱ�䣺	2012-4-25 9:32:55
//����    ��	ld
//����������	
//	���崮ͬ������ģ��
	
`timescale 1ns/100ps	
module burst_syn_ctrl(
	input	wire			clk_sys,		//100M	
	input	wire			reset_n	,
	input	wire[2:0]	burst_period,	//重复周期 0=>0hz 1=>1hz 2=>5hz 3=>10hz 4=>50hz 5=>100hz 6=>200hz 7=>400hz
	output	wire		burst_syn		//同步信号
	);

//		parameter	burst_period 	= 3'd1;
	
	reg[31:0] clk_div_num;//分频数  重复周期=100MHz/clk_div_num;
	always@(posedge clk_sys or negedge reset_n)
	begin
		if(~reset_n)
		begin
			clk_div_num <= 0;
		end
		else
		begin
			case(burst_period)
				0:clk_div_num <= 0;	//0hz
				1:clk_div_num <= 32'd100000000;//1Hz
				2:clk_div_num <= 32'd20000000;//5Hz
				3:clk_div_num <= 32'd10000000;//10Hz
				4:clk_div_num <= 32'd2000000;//50Hz
				5:clk_div_num <= 32'd1000000;//100Hz
				6:clk_div_num <= 32'd500000;//200Hz
				7:clk_div_num <= 32'd250000;//400Hz
			endcase
		end
	end
	
	reg[31:0] clk_div_couunter;	
	reg	burst_syn_tmp;//���崮ͬ��
	always@(posedge clk_sys or negedge reset_n)
	begin
		if(~reset_n)
		begin
			clk_div_couunter <= 0;
			burst_syn_tmp <= 0;
		end
		else if(clk_div_num == 0)
		begin
			burst_syn_tmp = 1'b0;
		end
		else
		begin
			if(clk_div_couunter >= (clk_div_num-1))
			begin
				clk_div_couunter <= 0;
			end
			else
			begin
				clk_div_couunter <= clk_div_couunter + 1'b1;
			end
			burst_syn_tmp <= (clk_div_couunter > (clk_div_num-50));
		end
	end
	assign burst_syn = burst_syn_tmp;
	
//	//������ͬ���ź�
//	reg	burst_syn_test = 0	;//���崮ͬ��
//	reg[13:0] burst_syn_test_counter = 0;
//	always@(posedge clk_sys)
//	begin
//		if(~reset_n)
//		begin
//			burst_syn_test_counter <= 0;
//			burst_syn_test <= 0;//��ʱ�������ź�
//		end
//		else
//		begin
//			burst_syn_test_counter <= burst_syn_test_counter + 1'b1;
//			burst_syn_test <= (burst_syn_test_counter < 50);//��ʱ�������ź�
//		end
//	end
	
	//assign burst_syn = (burst_period == 7) ? burst_syn_test : burst_syn_tmp;

endmodule