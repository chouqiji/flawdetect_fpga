
`timescale 1ns/100ps

module protect(
	input 	wire			clk,
	input 	wire			reset_n,
	input		wire			triggerP,
	input		wire			triggerN,
	input		wire			FreqFlag,	//1--->(Freq <= 1MHz);		0-->(Freq > 1MHz);
	input		wire			Probe_mode,	//探头模式选择  1-->双探头   0-->单探头
	input 	wire[5:0]	protect_in,
	output 	wire 			protect_en,	//1-->protect;		0-->unprotect;
	output	wire[5:0]	protect_state
	);

//**************************** Introduction *******************************
// protect_in[0]: MOSFET_protect(MOSFET_UP); 		0-->unprotect;		1-->protect;
// protect_in[1]: MOSFET_protect(MOSFET_DOWN);		0-->unprotect;		1-->protect;
// protect_in[2]: HVCap_protect(IOV_HIGH);			0-->protect;		1-->unprotect;
// protect_in[3]: Temp_Protect1;							1-->protect;		0-->unprotect;
// protect_in[4]: Temp_Protect2;							1-->protect;		0-->unprotect;
// protect_in[5]: Temp_ProtectMOS;						0-->protect;		1-->unprotect;
//*************************************************************************
	parameter T_30ns = 16'd10;
	
	parameter N = 24;
	reg [N:0] triggerP_d_tmp;
	reg [N:0] triggerN_d_tmp;
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			triggerP_d_tmp <= 0;
			triggerN_d_tmp <= 0;
		end
		else
		begin
			triggerP_d_tmp <= {triggerP_d_tmp[N-1:0],triggerP};
			triggerN_d_tmp <= {triggerN_d_tmp[N-1:0],triggerN};
		end
	end

	wire triggerP_p_en;
	wire tirggerN_p_en;
	wire MosProtect_en;
	wire EMATprotect_in;
	reg MosProtect_en_tmp;
		
	assign triggerP_p_en = triggerP_d_tmp[N] & triggerP;
	assign tirggerN_p_en = triggerN_d_tmp[N] & triggerN;
	assign MosProtect_en = (triggerP_p_en | tirggerN_p_en) & MosProtect_en_tmp;
	assign EMATprotect_in = Probe_mode ? (~protect_in[4]) : ((~protect_in[3]) & (~protect_in[4]));
	assign protect_state = protect_in;


//	MOSFET Protect Freq <= 1MHz;
	parameter STATE_IDLE	= 2'd0;
	parameter STATE_P_TEST 	= 2'd1;
	parameter STATE_P_WAIT	= 2'd2;
	
	reg[15:0] MosP_cnt;
	reg[1:0]	MosP_state;
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			MosP_cnt <= 16'd0;
			MosProtect_en_tmp <= 1'b0; 
			MosP_state <= STATE_IDLE;
		end
		else
		begin
			case(MosP_state)
				STATE_IDLE:
				begin
					if(protect_in[0] | (protect_in[1]) | EMATprotect_in | (protect_in[5]))
					begin
						MosP_cnt <=MosP_cnt + 16'd1;
						MosProtect_en_tmp <= 1'b0; 
						MosP_state <= STATE_P_TEST;
					end
					else
					begin
						MosP_cnt <= 16'd0;
						MosProtect_en_tmp <= 1'b0; 
						MosP_state <= STATE_IDLE;
					end
				end
				STATE_P_TEST:
				begin
					if(MosP_cnt >= T_30ns)
					begin
						MosProtect_en_tmp <= 1'b1; 
					end
					else
					begin
						MosProtect_en_tmp <= 1'b0; 
					end
					if(protect_in[0] | (protect_in[1]) | EMATprotect_in | (protect_in[5]))
					begin
						MosP_cnt <=MosP_cnt + 16'd1;
						MosP_state <= STATE_P_TEST;
					end
					else
					begin
						MosP_cnt <= MosP_cnt;
						MosP_state <= STATE_P_WAIT;
					end
				end
				STATE_P_WAIT:
				begin
					if(MosP_cnt >= T_30ns)
					begin
						MosProtect_en_tmp <= 1'b1; 
					end
					else
					begin
						MosProtect_en_tmp <= 1'b0; 
					end
					if(protect_in[0] | (protect_in[1]) | EMATprotect_in | (protect_in[5]))
					begin
						MosP_cnt <=MosP_cnt + 16'd1;
						MosP_state <= STATE_P_TEST;
					end
					else
					begin
						MosP_cnt <= 0;
						MosP_state <= STATE_IDLE;
					end
				end
				
				default:
				begin
					MosP_cnt <= 16'd0;
					MosProtect_en_tmp <= 1'b1; 
					MosP_state <= STATE_IDLE;
				end
			endcase
		end
	end
	
//	HV Protect Freq > 1MHz;
	
	reg[15:0] HVP_cnt;
	reg HVProtect_en;
	reg[1:0]	HVP_state;
	always@(posedge clk or negedge reset_n)
	begin
		if(~reset_n)
		begin
			HVP_cnt <= 16'd0;
			HVProtect_en <= 1'b0; 
			HVP_state <= STATE_IDLE;
		end
		else
		begin
			case(HVP_state)
				STATE_IDLE:
				begin
					if(EMATprotect_in | (protect_in[5]))
					begin
						HVP_cnt <=HVP_cnt + 16'd1;
						HVProtect_en <= 1'b0; 
						HVP_state <= STATE_P_TEST;
					end
					else
					begin
						HVP_cnt <= 16'd0;
						HVProtect_en <= 1'b0; 
						HVP_state <= STATE_IDLE;
					end
				end
				STATE_P_TEST:
				begin
					if(HVP_cnt >= T_30ns)
					begin
						HVProtect_en <= 1'b1; 
					end
					else
					begin
						HVProtect_en <= 1'b0; 
					end
					if(EMATprotect_in | (protect_in[5]))
					begin
						HVP_cnt <= HVP_cnt + 16'd1;
						HVP_state <= STATE_P_TEST;
					end
					else
					begin
						HVP_cnt <= HVP_cnt;
						HVP_state <= STATE_P_WAIT;
					end
				end
				STATE_P_WAIT:
				begin
					if(HVP_cnt >= T_30ns)
					begin
						HVProtect_en <= 1'b1; 
					end
					else
					begin
						HVProtect_en <= 1'b0; 
					end
					if(EMATprotect_in | (protect_in[5]))
					begin
						HVP_cnt <= HVP_cnt + 16'd1;
						HVP_state <= STATE_P_TEST;
					end
					else
					begin
						HVP_cnt <= 0;
						HVP_state <= STATE_IDLE;
					end
				end
				
				default:
				begin
					HVP_cnt <= 16'd0;
					HVProtect_en <= 1'b1; 
					HVP_state <= STATE_IDLE;
				end
			endcase
		end
	end
//	assign protect_en = FreqFlag ? MosProtect_en : HVProtect_en;
assign protect_en = 0;
	
endmodule

	