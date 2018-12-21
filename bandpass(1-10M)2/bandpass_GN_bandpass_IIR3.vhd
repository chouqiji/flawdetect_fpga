-- bandpass_GN_bandpass_IIR3.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bandpass_GN_bandpass_IIR3 is
	port (
		In1   : in  std_logic_vector(11 downto 0) := (others => '0'); --   In1.wire
		Out1  : out std_logic_vector(9 downto 0);                     --  Out1.wire
		Clock : in  std_logic                     := '0';             -- Clock.clk
		aclr  : in  std_logic                     := '0'              --      .reset
	);
end entity bandpass_GN_bandpass_IIR3;

architecture rtl of bandpass_GN_bandpass_IIR3 is
	component alt_dspbuilder_clock_GNQFU4PUDH is
		port (
			aclr      : in  std_logic := 'X'; -- reset
			aclr_n    : in  std_logic := 'X'; -- reset_n
			aclr_out  : out std_logic;        -- reset
			clock     : in  std_logic := 'X'; -- clk
			clock_out : out std_logic         -- clk
		);
	end component alt_dspbuilder_clock_GNQFU4PUDH;

	component alt_dspbuilder_cast_GNEBGJHTWJ is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(28 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(28 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNEBGJHTWJ;

	component alt_dspbuilder_parallel_adder_GNZVU6W3GJ is
		generic (
			pipeline      : natural  := 0;
			MaskValue     : string   := "1";
			direction     : string   := "+";
			dataWidth     : positive := 8;
			number_inputs : positive := 2
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			result    : out std_logic_vector(58 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(56 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(56 downto 0) := (others => 'X'); -- wire
			data2     : in  std_logic_vector(56 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNZVU6W3GJ;

	component alt_dspbuilder_gnd_GN is
		port (
			output : out std_logic   -- wire
		);
	end component alt_dspbuilder_gnd_GN;

	component alt_dspbuilder_vcc_GN is
		port (
			output : out std_logic   -- wire
		);
	end component alt_dspbuilder_vcc_GN;

	component alt_dspbuilder_cast_GNDTOV7QCB is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(10 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                      -- wire
		);
	end component alt_dspbuilder_cast_GNDTOV7QCB;

	component alt_dspbuilder_parallel_adder_GNYLHLSTWT is
		generic (
			pipeline      : natural  := 0;
			MaskValue     : string   := "1";
			direction     : string   := "+";
			dataWidth     : positive := 8;
			number_inputs : positive := 2
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			result    : out std_logic_vector(32 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(30 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(30 downto 0) := (others => 'X'); -- wire
			data2     : in  std_logic_vector(30 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNYLHLSTWT;

	component alt_dspbuilder_parallel_adder_GNJ3ZMS76T is
		generic (
			pipeline      : natural  := 0;
			MaskValue     : string   := "1";
			direction     : string   := "+";
			dataWidth     : positive := 8;
			number_inputs : positive := 2
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			result    : out std_logic_vector(44 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(42 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(42 downto 0) := (others => 'X'); -- wire
			data2     : in  std_logic_vector(42 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNJ3ZMS76T;

	component alt_dspbuilder_cast_GNOFRRSKIV is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(24 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(24 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNOFRRSKIV;

	component alt_dspbuilder_parallel_adder_GNGJR2XP4L is
		generic (
			pipeline      : natural  := 0;
			MaskValue     : string   := "1";
			direction     : string   := "+";
			dataWidth     : positive := 8;
			number_inputs : positive := 2
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			result    : out std_logic_vector(44 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(42 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(42 downto 0) := (others => 'X'); -- wire
			data2     : in  std_logic_vector(42 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNGJR2XP4L;

	component alt_dspbuilder_port_GNSSYS4J5R is
		port (
			input  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                     -- wire
		);
	end component alt_dspbuilder_port_GNSSYS4J5R;

	component alt_dspbuilder_delay_GN6XVZIBTQ is
		generic (
			width      : positive := 8;
			delay      : positive := 1;
			ClockPhase : string   := "1";
			use_init   : natural  := 0;
			BitPattern : string   := "00000001"
		);
		port (
			aclr   : in  std_logic                          := 'X';             -- clk
			clock  : in  std_logic                          := 'X';             -- clk
			ena    : in  std_logic                          := 'X';             -- wire
			input  : in  std_logic_vector(width-1 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(width-1 downto 0);                    -- wire
			sclr   : in  std_logic                          := 'X'              -- wire
		);
	end component alt_dspbuilder_delay_GN6XVZIBTQ;

	component alt_dspbuilder_port_GN4K6H3QBP is
		port (
			input  : in  std_logic_vector(11 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(11 downto 0)                     -- wire
		);
	end component alt_dspbuilder_port_GN4K6H3QBP;

	component alt_dspbuilder_cast_GN7WBBLJKE is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(11 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                      -- wire
		);
	end component alt_dspbuilder_cast_GN7WBBLJKE;

	component alt_dspbuilder_gain_GNL5WQCGG3 is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(28 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(40 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNL5WQCGG3;

	component alt_dspbuilder_gain_GNBITIEGOL is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(24 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(42 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNBITIEGOL;

	component alt_dspbuilder_gain_GNP6CEWTPS is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(28 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(40 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNP6CEWTPS;

	component alt_dspbuilder_gain_GN22DM5D2X is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- wire
			Output    : out std_logic_vector(27 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GN22DM5D2X;

	component alt_dspbuilder_delay_GNQC3GUCBB is
		generic (
			width      : positive := 8;
			delay      : positive := 1;
			ClockPhase : string   := "1";
			use_init   : natural  := 0;
			BitPattern : string   := "00000001"
		);
		port (
			aclr   : in  std_logic                          := 'X';             -- clk
			clock  : in  std_logic                          := 'X';             -- clk
			ena    : in  std_logic                          := 'X';             -- wire
			input  : in  std_logic_vector(width-1 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(width-1 downto 0);                    -- wire
			sclr   : in  std_logic                          := 'X'              -- wire
		);
	end component alt_dspbuilder_delay_GNQC3GUCBB;

	component alt_dspbuilder_gain_GNZQY4OEB4 is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(44 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(56 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNZQY4OEB4;

	component alt_dspbuilder_gain_GNJPYLDCII is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(28 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(30 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNJPYLDCII;

	component alt_dspbuilder_gain_GNUBQGR5OU is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(24 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(42 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNUBQGR5OU;

	component alt_dspbuilder_gain_GNZ6W6HACB is
		generic (
			lpm        : natural := 0;
			MaskValue  : string  := "1";
			pipeline   : natural := 0;
			gain       : string  := "00000001";
			InputWidth : natural := 8
		);
		port (
			clock     : in  std_logic                     := 'X';             -- clk
			aclr      : in  std_logic                     := 'X';             -- reset
			Input     : in  std_logic_vector(24 downto 0) := (others => 'X'); -- wire
			Output    : out std_logic_vector(42 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X'              -- wire
		);
	end component alt_dspbuilder_gain_GNZ6W6HACB;

	component alt_dspbuilder_cast_GNYUH6P3MU is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNYUH6P3MU;

	component alt_dspbuilder_cast_GNOHFS3CO5 is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(44 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(24 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNOHFS3CO5;

	component alt_dspbuilder_cast_GNUPPLBZZU is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(24 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(42 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNUPPLBZZU;

	component alt_dspbuilder_cast_GNXL4CPEZ2 is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(58 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(28 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNXL4CPEZ2;

	component alt_dspbuilder_cast_GNRUKYXBW3 is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(28 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(30 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNRUKYXBW3;

	component alt_dspbuilder_cast_GN55ECKRET is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(32 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(10 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GN55ECKRET;

	component alt_dspbuilder_cast_GNRMFM2JWT is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(40 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(56 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNRMFM2JWT;

	component alt_dspbuilder_cast_GN5NV6C7GX is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(27 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(42 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GN5NV6C7GX;

	signal adder1user_aclrgnd_output_wire : std_logic;                     -- Adder1user_aclrGND:output -> Adder1:user_aclr
	signal adder1enavcc_output_wire       : std_logic;                     -- Adder1enaVCC:output -> Adder1:ena
	signal adder4user_aclrgnd_output_wire : std_logic;                     -- Adder4user_aclrGND:output -> Adder4:user_aclr
	signal adder4enavcc_output_wire       : std_logic;                     -- Adder4enaVCC:output -> Adder4:ena
	signal adder3user_aclrgnd_output_wire : std_logic;                     -- Adder3user_aclrGND:output -> Adder3:user_aclr
	signal adder3enavcc_output_wire       : std_logic;                     -- Adder3enaVCC:output -> Adder3:ena
	signal adder2user_aclrgnd_output_wire : std_logic;                     -- Adder2user_aclrGND:output -> Adder2:user_aclr
	signal adder2enavcc_output_wire       : std_logic;                     -- Adder2enaVCC:output -> Adder2:ena
	signal delaysclrgnd_output_wire       : std_logic;                     -- DelaysclrGND:output -> Delay:sclr
	signal delayenavcc_output_wire        : std_logic;                     -- DelayenaVCC:output -> Delay:ena
	signal gain9user_aclrgnd_output_wire  : std_logic;                     -- Gain9user_aclrGND:output -> Gain9:user_aclr
	signal gain9enavcc_output_wire        : std_logic;                     -- Gain9enaVCC:output -> Gain9:ena
	signal gain4user_aclrgnd_output_wire  : std_logic;                     -- Gain4user_aclrGND:output -> Gain4:user_aclr
	signal gain4enavcc_output_wire        : std_logic;                     -- Gain4enaVCC:output -> Gain4:ena
	signal gain11user_aclrgnd_output_wire : std_logic;                     -- Gain11user_aclrGND:output -> Gain11:user_aclr
	signal gain11enavcc_output_wire       : std_logic;                     -- Gain11enaVCC:output -> Gain11:ena
	signal gain6user_aclrgnd_output_wire  : std_logic;                     -- Gain6user_aclrGND:output -> Gain6:user_aclr
	signal gain6enavcc_output_wire        : std_logic;                     -- Gain6enaVCC:output -> Gain6:ena
	signal delay3sclrgnd_output_wire      : std_logic;                     -- Delay3sclrGND:output -> Delay3:sclr
	signal delay3enavcc_output_wire       : std_logic;                     -- Delay3enaVCC:output -> Delay3:ena
	signal gain13user_aclrgnd_output_wire : std_logic;                     -- Gain13user_aclrGND:output -> Gain13:user_aclr
	signal gain13enavcc_output_wire       : std_logic;                     -- Gain13enaVCC:output -> Gain13:ena
	signal gain12user_aclrgnd_output_wire : std_logic;                     -- Gain12user_aclrGND:output -> Gain12:user_aclr
	signal gain12enavcc_output_wire       : std_logic;                     -- Gain12enaVCC:output -> Gain12:ena
	signal gain2user_aclrgnd_output_wire  : std_logic;                     -- Gain2user_aclrGND:output -> Gain2:user_aclr
	signal gain2enavcc_output_wire        : std_logic;                     -- Gain2enaVCC:output -> Gain2:ena
	signal gain1user_aclrgnd_output_wire  : std_logic;                     -- Gain1user_aclrGND:output -> Gain1:user_aclr
	signal gain1enavcc_output_wire        : std_logic;                     -- Gain1enaVCC:output -> Gain1:ena
	signal delay1sclrgnd_output_wire      : std_logic;                     -- Delay1sclrGND:output -> Delay1:sclr
	signal delay1enavcc_output_wire       : std_logic;                     -- Delay1enaVCC:output -> Delay1:ena
	signal delay2sclrgnd_output_wire      : std_logic;                     -- Delay2sclrGND:output -> Delay2:sclr
	signal delay2enavcc_output_wire       : std_logic;                     -- Delay2enaVCC:output -> Delay2:ena
	signal in1_0_output_wire              : std_logic_vector(11 downto 0); -- In1_0:output -> AltBus:input
	signal bus_conversion2_output_wire    : std_logic_vector(9 downto 0);  -- Bus_Conversion2:output -> AltBus1:input
	signal bus_conversion_output_wire     : std_logic_vector(24 downto 0); -- Bus_Conversion:output -> [Delay:input, cast1:input]
	signal delay_output_wire              : std_logic_vector(24 downto 0); -- Delay:output -> [Delay1:input, Gain1:Input, Gain2:Input]
	signal bus_conversion1_output_wire    : std_logic_vector(28 downto 0); -- Bus_Conversion1:output -> [Delay2:input, cast3:input]
	signal delay2_output_wire             : std_logic_vector(28 downto 0); -- Delay2:output -> [Delay3:input, Gain12:Input, Gain9:Input]
	signal gain1_output_wire              : std_logic_vector(42 downto 0); -- Gain1:Output -> Adder3:data1
	signal delay3_output_wire             : std_logic_vector(28 downto 0); -- Delay3:output -> [Gain11:Input, cast6:input]
	signal gain12_output_wire             : std_logic_vector(30 downto 0); -- Gain12:Output -> Adder4:data1
	signal adder3_result_wire             : std_logic_vector(44 downto 0); -- Adder3:result -> Gain13:Input
	signal gain13_output_wire             : std_logic_vector(56 downto 0); -- Gain13:Output -> Adder1:data0
	signal gain2_output_wire              : std_logic_vector(42 downto 0); -- Gain2:Output -> Adder2:data1
	signal delay1_output_wire             : std_logic_vector(24 downto 0); -- Delay1:output -> [Gain4:Input, cast5:input]
	signal gain4_output_wire              : std_logic_vector(42 downto 0); -- Gain4:Output -> Adder2:data2
	signal altbus1_output_wire            : std_logic_vector(9 downto 0);  -- AltBus1:output -> Out1_0:input
	signal adder2_result_wire             : std_logic_vector(44 downto 0); -- Adder2:result -> cast0:input
	signal cast0_output_wire              : std_logic_vector(24 downto 0); -- cast0:output -> Bus_Conversion:input
	signal cast1_output_wire              : std_logic_vector(42 downto 0); -- cast1:output -> Adder3:data0
	signal adder1_result_wire             : std_logic_vector(58 downto 0); -- Adder1:result -> cast2:input
	signal cast2_output_wire              : std_logic_vector(28 downto 0); -- cast2:output -> Bus_Conversion1:input
	signal cast3_output_wire              : std_logic_vector(30 downto 0); -- cast3:output -> Adder4:data0
	signal adder4_result_wire             : std_logic_vector(32 downto 0); -- Adder4:result -> cast4:input
	signal cast4_output_wire              : std_logic_vector(10 downto 0); -- cast4:output -> Bus_Conversion2:input
	signal cast5_output_wire              : std_logic_vector(42 downto 0); -- cast5:output -> Adder3:data2
	signal cast6_output_wire              : std_logic_vector(30 downto 0); -- cast6:output -> Adder4:data2
	signal gain11_output_wire             : std_logic_vector(40 downto 0); -- Gain11:Output -> cast7:input
	signal cast7_output_wire              : std_logic_vector(56 downto 0); -- cast7:output -> Adder1:data2
	signal altbus_output_wire             : std_logic_vector(9 downto 0);  -- AltBus:output -> cast8:input
	signal cast8_output_wire              : std_logic_vector(9 downto 0);  -- cast8:output -> Gain6:Input
	signal gain6_output_wire              : std_logic_vector(27 downto 0); -- Gain6:Output -> cast9:input
	signal cast9_output_wire              : std_logic_vector(42 downto 0); -- cast9:output -> Adder2:data0
	signal gain9_output_wire              : std_logic_vector(40 downto 0); -- Gain9:Output -> cast10:input
	signal cast10_output_wire             : std_logic_vector(56 downto 0); -- cast10:output -> Adder1:data1
	signal clock_0_clock_output_reset     : std_logic;                     -- Clock_0:aclr_out -> [Adder1:aclr, Adder2:aclr, Adder3:aclr, Adder4:aclr, Delay1:aclr, Delay2:aclr, Delay3:aclr, Delay:aclr, Gain11:aclr, Gain12:aclr, Gain13:aclr, Gain1:aclr, Gain2:aclr, Gain4:aclr, Gain6:aclr, Gain9:aclr]
	signal clock_0_clock_output_clk       : std_logic;                     -- Clock_0:clock_out -> [Adder1:clock, Adder2:clock, Adder3:clock, Adder4:clock, Delay1:clock, Delay2:clock, Delay3:clock, Delay:clock, Gain11:clock, Gain12:clock, Gain13:clock, Gain1:clock, Gain2:clock, Gain4:clock, Gain6:clock, Gain9:clock]

begin

	clock_0 : component alt_dspbuilder_clock_GNQFU4PUDH
		port map (
			clock_out => clock_0_clock_output_clk,   -- clock_output.clk
			aclr_out  => clock_0_clock_output_reset, --             .reset
			clock     => Clock,                      --        clock.clk
			aclr      => aclr                        --             .reset
		);

	bus_conversion1 : component alt_dspbuilder_cast_GNEBGJHTWJ
		generic map (
			saturate => 1,
			round    => 0
		)
		port map (
			input  => cast2_output_wire,           --  input.wire
			output => bus_conversion1_output_wire  -- output.wire
		);

	adder1 : component alt_dspbuilder_parallel_adder_GNZVU6W3GJ
		generic map (
			pipeline      => 0,
			MaskValue     => "1",
			direction     => "+--",
			dataWidth     => 57,
			number_inputs => 3
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			result    => adder1_result_wire,             --     result.wire
			user_aclr => adder1user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => adder1enavcc_output_wire,       --        ena.wire
			data0     => gain13_output_wire,             --      data0.wire
			data1     => cast10_output_wire,             --      data1.wire
			data2     => cast7_output_wire               --      data2.wire
		);

	adder1user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => adder1user_aclrgnd_output_wire  -- output.wire
		);

	adder1enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => adder1enavcc_output_wire  -- output.wire
		);

	bus_conversion2 : component alt_dspbuilder_cast_GNDTOV7QCB
		generic map (
			saturate => 1,
			round    => 0
		)
		port map (
			input  => cast4_output_wire,           --  input.wire
			output => bus_conversion2_output_wire  -- output.wire
		);

	adder4 : component alt_dspbuilder_parallel_adder_GNYLHLSTWT
		generic map (
			pipeline      => 1,
			MaskValue     => "1",
			direction     => "+",
			dataWidth     => 31,
			number_inputs => 3
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			result    => adder4_result_wire,             --     result.wire
			user_aclr => adder4user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => adder4enavcc_output_wire,       --        ena.wire
			data0     => cast3_output_wire,              --      data0.wire
			data1     => gain12_output_wire,             --      data1.wire
			data2     => cast6_output_wire               --      data2.wire
		);

	adder4user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => adder4user_aclrgnd_output_wire  -- output.wire
		);

	adder4enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => adder4enavcc_output_wire  -- output.wire
		);

	adder3 : component alt_dspbuilder_parallel_adder_GNJ3ZMS76T
		generic map (
			pipeline      => 1,
			MaskValue     => "1",
			direction     => "+",
			dataWidth     => 43,
			number_inputs => 3
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			result    => adder3_result_wire,             --     result.wire
			user_aclr => adder3user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => adder3enavcc_output_wire,       --        ena.wire
			data0     => cast1_output_wire,              --      data0.wire
			data1     => gain1_output_wire,              --      data1.wire
			data2     => cast5_output_wire               --      data2.wire
		);

	adder3user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => adder3user_aclrgnd_output_wire  -- output.wire
		);

	adder3enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => adder3enavcc_output_wire  -- output.wire
		);

	bus_conversion : component alt_dspbuilder_cast_GNOFRRSKIV
		generic map (
			saturate => 1,
			round    => 0
		)
		port map (
			input  => cast0_output_wire,          --  input.wire
			output => bus_conversion_output_wire  -- output.wire
		);

	adder2 : component alt_dspbuilder_parallel_adder_GNGJR2XP4L
		generic map (
			pipeline      => 0,
			MaskValue     => "1",
			direction     => "+--",
			dataWidth     => 43,
			number_inputs => 3
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			result    => adder2_result_wire,             --     result.wire
			user_aclr => adder2user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => adder2enavcc_output_wire,       --        ena.wire
			data0     => cast9_output_wire,              --      data0.wire
			data1     => gain2_output_wire,              --      data1.wire
			data2     => gain4_output_wire               --      data2.wire
		);

	adder2user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => adder2user_aclrgnd_output_wire  -- output.wire
		);

	adder2enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => adder2enavcc_output_wire  -- output.wire
		);

	out1_0 : component alt_dspbuilder_port_GNSSYS4J5R
		port map (
			input  => altbus1_output_wire, --  input.wire
			output => Out1                 -- output.wire
		);

	delay : component alt_dspbuilder_delay_GN6XVZIBTQ
		generic map (
			width      => 25,
			delay      => 1,
			ClockPhase => "1",
			use_init   => 0,
			BitPattern => "0000000000000000000100000"
		)
		port map (
			input  => bus_conversion_output_wire, --      input.wire
			clock  => clock_0_clock_output_clk,   -- clock_aclr.clk
			aclr   => clock_0_clock_output_reset, --           .reset
			output => delay_output_wire,          --     output.wire
			sclr   => delaysclrgnd_output_wire,   --       sclr.wire
			ena    => delayenavcc_output_wire     --        ena.wire
		);

	delaysclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => delaysclrgnd_output_wire  -- output.wire
		);

	delayenavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => delayenavcc_output_wire  -- output.wire
		);

	in1_0 : component alt_dspbuilder_port_GN4K6H3QBP
		port map (
			input  => In1,               --  input.wire
			output => in1_0_output_wire  -- output.wire
		);

	altbus : component alt_dspbuilder_cast_GN7WBBLJKE
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => in1_0_output_wire,  --  input.wire
			output => altbus_output_wire  -- output.wire
		);

	gain9 : component alt_dspbuilder_gain_GNL5WQCGG3
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "101011100100",
			InputWidth => 29
		)
		port map (
			clock     => clock_0_clock_output_clk,      -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,    --           .reset
			Input     => delay2_output_wire,            --      Input.wire
			Output    => gain9_output_wire,             --     Output.wire
			user_aclr => gain9user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain9enavcc_output_wire        --        ena.wire
		);

	gain9user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain9user_aclrgnd_output_wire  -- output.wire
		);

	gain9enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain9enavcc_output_wire  -- output.wire
		);

	gain4 : component alt_dspbuilder_gain_GNBITIEGOL
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "001111000111101110",
			InputWidth => 25
		)
		port map (
			clock     => clock_0_clock_output_clk,      -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,    --           .reset
			Input     => delay1_output_wire,            --      Input.wire
			Output    => gain4_output_wire,             --     Output.wire
			user_aclr => gain4user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain4enavcc_output_wire        --        ena.wire
		);

	gain4user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain4user_aclrgnd_output_wire  -- output.wire
		);

	gain4enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain4enavcc_output_wire  -- output.wire
		);

	gain11 : component alt_dspbuilder_gain_GNP6CEWTPS
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "001001010010",
			InputWidth => 29
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			Input     => delay3_output_wire,             --      Input.wire
			Output    => gain11_output_wire,             --     Output.wire
			user_aclr => gain11user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain11enavcc_output_wire        --        ena.wire
		);

	gain11user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain11user_aclrgnd_output_wire  -- output.wire
		);

	gain11enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain11enavcc_output_wire  -- output.wire
		);

	gain6 : component alt_dspbuilder_gain_GN22DM5D2X
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "000011111000010101",
			InputWidth => 10
		)
		port map (
			clock     => clock_0_clock_output_clk,      -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,    --           .reset
			Input     => cast8_output_wire,             --      Input.wire
			Output    => gain6_output_wire,             --     Output.wire
			user_aclr => gain6user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain6enavcc_output_wire        --        ena.wire
		);

	gain6user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain6user_aclrgnd_output_wire  -- output.wire
		);

	gain6enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain6enavcc_output_wire  -- output.wire
		);

	delay3 : component alt_dspbuilder_delay_GNQC3GUCBB
		generic map (
			width      => 29,
			delay      => 1,
			ClockPhase => "1",
			use_init   => 0,
			BitPattern => "00000000000000000000000100000"
		)
		port map (
			input  => delay2_output_wire,         --      input.wire
			clock  => clock_0_clock_output_clk,   -- clock_aclr.clk
			aclr   => clock_0_clock_output_reset, --           .reset
			output => delay3_output_wire,         --     output.wire
			sclr   => delay3sclrgnd_output_wire,  --       sclr.wire
			ena    => delay3enavcc_output_wire    --        ena.wire
		);

	delay3sclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => delay3sclrgnd_output_wire  -- output.wire
		);

	delay3enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => delay3enavcc_output_wire  -- output.wire
		);

	gain13 : component alt_dspbuilder_gain_GNZQY4OEB4
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "000011111000",
			InputWidth => 45
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			Input     => adder3_result_wire,             --      Input.wire
			Output    => gain13_output_wire,             --     Output.wire
			user_aclr => gain13user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain13enavcc_output_wire        --        ena.wire
		);

	gain13user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain13user_aclrgnd_output_wire  -- output.wire
		);

	gain13enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain13enavcc_output_wire  -- output.wire
		);

	gain12 : component alt_dspbuilder_gain_GNJPYLDCII
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "10",
			InputWidth => 29
		)
		port map (
			clock     => clock_0_clock_output_clk,       -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,     --           .reset
			Input     => delay2_output_wire,             --      Input.wire
			Output    => gain12_output_wire,             --     Output.wire
			user_aclr => gain12user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain12enavcc_output_wire        --        ena.wire
		);

	gain12user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain12user_aclrgnd_output_wire  -- output.wire
		);

	gain12enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain12enavcc_output_wire  -- output.wire
		);

	gain2 : component alt_dspbuilder_gain_GNUBQGR5OU
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "100000111100001011",
			InputWidth => 25
		)
		port map (
			clock     => clock_0_clock_output_clk,      -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,    --           .reset
			Input     => delay_output_wire,             --      Input.wire
			Output    => gain2_output_wire,             --     Output.wire
			user_aclr => gain2user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain2enavcc_output_wire        --        ena.wire
		);

	gain2user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain2user_aclrgnd_output_wire  -- output.wire
		);

	gain2enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain2enavcc_output_wire  -- output.wire
		);

	gain1 : component alt_dspbuilder_gain_GNZ6W6HACB
		generic map (
			lpm        => 0,
			MaskValue  => "1",
			pipeline   => 0,
			gain       => "011111111011001010",
			InputWidth => 25
		)
		port map (
			clock     => clock_0_clock_output_clk,      -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,    --           .reset
			Input     => delay_output_wire,             --      Input.wire
			Output    => gain1_output_wire,             --     Output.wire
			user_aclr => gain1user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => gain1enavcc_output_wire        --        ena.wire
		);

	gain1user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => gain1user_aclrgnd_output_wire  -- output.wire
		);

	gain1enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => gain1enavcc_output_wire  -- output.wire
		);

	delay1 : component alt_dspbuilder_delay_GN6XVZIBTQ
		generic map (
			width      => 25,
			delay      => 1,
			ClockPhase => "1",
			use_init   => 0,
			BitPattern => "0000000000000000000100000"
		)
		port map (
			input  => delay_output_wire,          --      input.wire
			clock  => clock_0_clock_output_clk,   -- clock_aclr.clk
			aclr   => clock_0_clock_output_reset, --           .reset
			output => delay1_output_wire,         --     output.wire
			sclr   => delay1sclrgnd_output_wire,  --       sclr.wire
			ena    => delay1enavcc_output_wire    --        ena.wire
		);

	delay1sclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => delay1sclrgnd_output_wire  -- output.wire
		);

	delay1enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => delay1enavcc_output_wire  -- output.wire
		);

	delay2 : component alt_dspbuilder_delay_GNQC3GUCBB
		generic map (
			width      => 29,
			delay      => 1,
			ClockPhase => "1",
			use_init   => 0,
			BitPattern => "00000000000000000000000100000"
		)
		port map (
			input  => bus_conversion1_output_wire, --      input.wire
			clock  => clock_0_clock_output_clk,    -- clock_aclr.clk
			aclr   => clock_0_clock_output_reset,  --           .reset
			output => delay2_output_wire,          --     output.wire
			sclr   => delay2sclrgnd_output_wire,   --       sclr.wire
			ena    => delay2enavcc_output_wire     --        ena.wire
		);

	delay2sclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => delay2sclrgnd_output_wire  -- output.wire
		);

	delay2enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => delay2enavcc_output_wire  -- output.wire
		);

	altbus1 : component alt_dspbuilder_cast_GNYUH6P3MU
		generic map (
			saturate => 1,
			round    => 0
		)
		port map (
			input  => bus_conversion2_output_wire, --  input.wire
			output => altbus1_output_wire          -- output.wire
		);

	cast0 : component alt_dspbuilder_cast_GNOHFS3CO5
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => adder2_result_wire, --  input.wire
			output => cast0_output_wire   -- output.wire
		);

	cast1 : component alt_dspbuilder_cast_GNUPPLBZZU
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => bus_conversion_output_wire, --  input.wire
			output => cast1_output_wire           -- output.wire
		);

	cast2 : component alt_dspbuilder_cast_GNXL4CPEZ2
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => adder1_result_wire, --  input.wire
			output => cast2_output_wire   -- output.wire
		);

	cast3 : component alt_dspbuilder_cast_GNRUKYXBW3
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => bus_conversion1_output_wire, --  input.wire
			output => cast3_output_wire            -- output.wire
		);

	cast4 : component alt_dspbuilder_cast_GN55ECKRET
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => adder4_result_wire, --  input.wire
			output => cast4_output_wire   -- output.wire
		);

	cast5 : component alt_dspbuilder_cast_GNUPPLBZZU
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => delay1_output_wire, --  input.wire
			output => cast5_output_wire   -- output.wire
		);

	cast6 : component alt_dspbuilder_cast_GNRUKYXBW3
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => delay3_output_wire, --  input.wire
			output => cast6_output_wire   -- output.wire
		);

	cast7 : component alt_dspbuilder_cast_GNRMFM2JWT
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => gain11_output_wire, --  input.wire
			output => cast7_output_wire   -- output.wire
		);

	cast8 : component alt_dspbuilder_cast_GNYUH6P3MU
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => altbus_output_wire, --  input.wire
			output => cast8_output_wire   -- output.wire
		);

	cast9 : component alt_dspbuilder_cast_GN5NV6C7GX
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => gain6_output_wire, --  input.wire
			output => cast9_output_wire  -- output.wire
		);

	cast10 : component alt_dspbuilder_cast_GNRMFM2JWT
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => gain9_output_wire,  --  input.wire
			output => cast10_output_wire  -- output.wire
		);

end architecture rtl; -- of bandpass_GN_bandpass_IIR3
