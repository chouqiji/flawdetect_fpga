library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_arith.all;
use IEEE.std_logic_unsigned.all;

library altera;
use altera.alt_dspbuilder_package.all;

library lpm;
use lpm.lpm_components.all;
entity alt_dspbuilder_cast_GNXL4CPEZ2 is
	generic		( 			round : natural := 0;
			saturate : natural := 0);

	port(
		input : in std_logic_vector(58 downto 0);
		output : out std_logic_vector(28 downto 0));		
end entity;



architecture rtl of alt_dspbuilder_cast_GNXL4CPEZ2 is 
Begin

-- Output - I/O assignment from Simulink Block  "Output"
Outputi : alt_dspbuilder_SBF generic map(
				width_inl=> 28 ,
				width_inr=> 31,
				width_outl=> 24,
				width_outr=> 5,
				lpm_signed=>  BusIsSigned ,
				round=> round,
				satur=> saturate)
		port map (
								xin(58 downto 0)  => input,
																yout => output				
				);
				
end architecture;