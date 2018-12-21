-- bandpass_GN.vhd


library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.numeric_std.all;

entity bandpass_GN is
	port (
		Input1 : in  std_logic_vector(9 downto 0) := (others => '0'); -- Input1.wire
		Clock  : in  std_logic                    := '0';             --  Clock.clk
		aclr   : in  std_logic                    := '0';             --       .reset_n
		Output : out std_logic_vector(9 downto 0)                     -- Output.wire
	);
end entity bandpass_GN;

architecture rtl of bandpass_GN is
	component alt_dspbuilder_clock_GNF343OQUJ is
		port (
			aclr      : in  std_logic := 'X'; -- reset
			aclr_n    : in  std_logic := 'X'; -- reset_n
			aclr_out  : out std_logic;        -- reset
			clock     : in  std_logic := 'X'; -- clk
			clock_out : out std_logic         -- clk
		);
	end component alt_dspbuilder_clock_GNF343OQUJ;

	component bandpass_GN_bandpass_IIR3 is
		port (
			In1   : in  std_logic_vector(11 downto 0) := (others => 'X'); -- wire
			Out1  : out std_logic_vector(9 downto 0);                     -- wire
			Clock : in  std_logic                     := 'X';             -- clk
			aclr  : in  std_logic                     := 'X'              -- reset
		);
	end component bandpass_GN_bandpass_IIR3;

	component alt_dspbuilder_parallel_adder_GNP4SQ3NQE is
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
			result    : out std_logic_vector(11 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(10 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(10 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNP4SQ3NQE;

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

	component alt_dspbuilder_port_GNSSYS4J5R is
		port (
			input  : in  std_logic_vector(9 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                     -- wire
		);
	end component alt_dspbuilder_port_GNSSYS4J5R;

	component alt_dspbuilder_constant_GNNWA6ZQVU is
		generic (
			HDLTYPE    : string  := "STD_LOGIC_VECTOR";
			width      : natural := 4;
			BitPattern : string  := "0000"
		);
		port (
			output : out std_logic_vector(9 downto 0)   -- wire
		);
	end component alt_dspbuilder_constant_GNNWA6ZQVU;

	component alt_dspbuilder_parallel_adder_GNPUE44HJS is
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
			result    : out std_logic_vector(11 downto 0);                    -- wire
			user_aclr : in  std_logic                     := 'X';             -- wire
			ena       : in  std_logic                     := 'X';             -- wire
			data0     : in  std_logic_vector(10 downto 0) := (others => 'X'); -- wire
			data1     : in  std_logic_vector(10 downto 0) := (others => 'X')  -- wire
		);
	end component alt_dspbuilder_parallel_adder_GNPUE44HJS;

	component alt_dspbuilder_cast_GNAMS3PPNH is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- wire
			output : out std_logic_vector(10 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GNAMS3PPNH;

	component alt_dspbuilder_cast_GN5D52DF5S is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(9 downto 0)  := (others => 'X'); -- wire
			output : out std_logic_vector(10 downto 0)                     -- wire
		);
	end component alt_dspbuilder_cast_GN5D52DF5S;

	component alt_dspbuilder_cast_GN3TEBP4UY is
		generic (
			saturate : natural := 0;
			round    : natural := 0
		);
		port (
			input  : in  std_logic_vector(11 downto 0) := (others => 'X'); -- wire
			output : out std_logic_vector(9 downto 0)                      -- wire
		);
	end component alt_dspbuilder_cast_GN3TEBP4UY;

	signal parallel_adder_subtractor1user_aclrgnd_output_wire : std_logic;                     -- Parallel_Adder_Subtractor1user_aclrGND:output -> Parallel_Adder_Subtractor1:user_aclr
	signal parallel_adder_subtractor1enavcc_output_wire       : std_logic;                     -- Parallel_Adder_Subtractor1enaVCC:output -> Parallel_Adder_Subtractor1:ena
	signal parallel_adder_subtractoruser_aclrgnd_output_wire  : std_logic;                     -- Parallel_Adder_Subtractoruser_aclrGND:output -> Parallel_Adder_Subtractor:user_aclr
	signal parallel_adder_subtractorenavcc_output_wire        : std_logic;                     -- Parallel_Adder_SubtractorenaVCC:output -> Parallel_Adder_Subtractor:ena
	signal parallel_adder_subtractor1_result_wire             : std_logic_vector(11 downto 0); -- Parallel_Adder_Subtractor1:result -> bandpass_IIR3_0:In1
	signal bandpass_iir3_0_out1_wire                          : std_logic_vector(9 downto 0);  -- bandpass_IIR3_0:Out1 -> cast11:input
	signal cast11_output_wire                                 : std_logic_vector(10 downto 0); -- cast11:output -> Parallel_Adder_Subtractor:data0
	signal constant_1_output_wire                             : std_logic_vector(9 downto 0);  -- Constant_1:output -> cast12:input
	signal cast12_output_wire                                 : std_logic_vector(10 downto 0); -- cast12:output -> Parallel_Adder_Subtractor:data1
	signal parallel_adder_subtractor_result_wire              : std_logic_vector(11 downto 0); -- Parallel_Adder_Subtractor:result -> cast13:input
	signal cast13_output_wire                                 : std_logic_vector(9 downto 0);  -- cast13:output -> Output_0:input
	signal input1_0_output_wire                               : std_logic_vector(9 downto 0);  -- Input1_0:output -> cast14:input
	signal cast14_output_wire                                 : std_logic_vector(10 downto 0); -- cast14:output -> Parallel_Adder_Subtractor1:data0
	signal constant1_output_wire                              : std_logic_vector(9 downto 0);  -- Constant1:output -> cast15:input
	signal cast15_output_wire                                 : std_logic_vector(10 downto 0); -- cast15:output -> Parallel_Adder_Subtractor1:data1
	signal clock_0_clock_output_reset                         : std_logic;                     -- Clock_0:aclr_out -> [Parallel_Adder_Subtractor1:aclr, Parallel_Adder_Subtractor:aclr, bandpass_IIR3_0:aclr]
	signal clock_0_clock_output_clk                           : std_logic;                     -- Clock_0:clock_out -> [Parallel_Adder_Subtractor1:clock, Parallel_Adder_Subtractor:clock, bandpass_IIR3_0:Clock]

begin

	clock_0 : component alt_dspbuilder_clock_GNF343OQUJ
		port map (
			clock_out => clock_0_clock_output_clk,   -- clock_output.clk
			aclr_out  => clock_0_clock_output_reset, --             .reset
			clock     => Clock,                      --        clock.clk
			aclr_n    => aclr                        --             .reset_n
		);

	bandpass_iir3_0 : component bandpass_GN_bandpass_IIR3
		port map (
			In1   => parallel_adder_subtractor1_result_wire, --   In1.wire
			Out1  => bandpass_iir3_0_out1_wire,              --  Out1.wire
			Clock => clock_0_clock_output_clk,               -- Clock.clk
			aclr  => clock_0_clock_output_reset              --      .reset
		);

	parallel_adder_subtractor1 : component alt_dspbuilder_parallel_adder_GNP4SQ3NQE
		generic map (
			pipeline      => 1,
			MaskValue     => "1",
			direction     => "+-",
			dataWidth     => 11,
			number_inputs => 2
		)
		port map (
			clock     => clock_0_clock_output_clk,                           -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,                         --           .reset
			result    => parallel_adder_subtractor1_result_wire,             --     result.wire
			user_aclr => parallel_adder_subtractor1user_aclrgnd_output_wire, --  user_aclr.wire
			ena       => parallel_adder_subtractor1enavcc_output_wire,       --        ena.wire
			data0     => cast14_output_wire,                                 --      data0.wire
			data1     => cast15_output_wire                                  --      data1.wire
		);

	parallel_adder_subtractor1user_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => parallel_adder_subtractor1user_aclrgnd_output_wire  -- output.wire
		);

	parallel_adder_subtractor1enavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => parallel_adder_subtractor1enavcc_output_wire  -- output.wire
		);

	output_0 : component alt_dspbuilder_port_GNSSYS4J5R
		port map (
			input  => cast13_output_wire, --  input.wire
			output => Output              -- output.wire
		);

	constant_1 : component alt_dspbuilder_constant_GNNWA6ZQVU
		generic map (
			HDLTYPE    => "STD_LOGIC_VECTOR",
			width      => 10,
			BitPattern => "1000000000"
		)
		port map (
			output => constant_1_output_wire  -- output.wire
		);

	constant1 : component alt_dspbuilder_constant_GNNWA6ZQVU
		generic map (
			HDLTYPE    => "STD_LOGIC_VECTOR",
			width      => 10,
			BitPattern => "1000000000"
		)
		port map (
			output => constant1_output_wire  -- output.wire
		);

	input1_0 : component alt_dspbuilder_port_GNSSYS4J5R
		port map (
			input  => Input1,               --  input.wire
			output => input1_0_output_wire  -- output.wire
		);

	parallel_adder_subtractor : component alt_dspbuilder_parallel_adder_GNPUE44HJS
		generic map (
			pipeline      => 1,
			MaskValue     => "1",
			direction     => "+",
			dataWidth     => 11,
			number_inputs => 2
		)
		port map (
			clock     => clock_0_clock_output_clk,                          -- clock_aclr.clk
			aclr      => clock_0_clock_output_reset,                        --           .reset
			result    => parallel_adder_subtractor_result_wire,             --     result.wire
			user_aclr => parallel_adder_subtractoruser_aclrgnd_output_wire, --  user_aclr.wire
			ena       => parallel_adder_subtractorenavcc_output_wire,       --        ena.wire
			data0     => cast11_output_wire,                                --      data0.wire
			data1     => cast12_output_wire                                 --      data1.wire
		);

	parallel_adder_subtractoruser_aclrgnd : component alt_dspbuilder_gnd_GN
		port map (
			output => parallel_adder_subtractoruser_aclrgnd_output_wire  -- output.wire
		);

	parallel_adder_subtractorenavcc : component alt_dspbuilder_vcc_GN
		port map (
			output => parallel_adder_subtractorenavcc_output_wire  -- output.wire
		);

	cast11 : component alt_dspbuilder_cast_GNAMS3PPNH
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => bandpass_iir3_0_out1_wire, --  input.wire
			output => cast11_output_wire         -- output.wire
		);

	cast12 : component alt_dspbuilder_cast_GN5D52DF5S
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => constant_1_output_wire, --  input.wire
			output => cast12_output_wire      -- output.wire
		);

	cast13 : component alt_dspbuilder_cast_GN3TEBP4UY
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => parallel_adder_subtractor_result_wire, --  input.wire
			output => cast13_output_wire                     -- output.wire
		);

	cast14 : component alt_dspbuilder_cast_GN5D52DF5S
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => input1_0_output_wire, --  input.wire
			output => cast14_output_wire    -- output.wire
		);

	cast15 : component alt_dspbuilder_cast_GN5D52DF5S
		generic map (
			saturate => 0,
			round    => 0
		)
		port map (
			input  => constant1_output_wire, --  input.wire
			output => cast15_output_wire     -- output.wire
		);

end architecture rtl; -- of bandpass_GN
