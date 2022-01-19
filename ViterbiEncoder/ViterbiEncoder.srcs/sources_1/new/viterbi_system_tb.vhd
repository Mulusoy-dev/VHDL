----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2021 11:15:17
-- Design Name: 
-- Module Name: viterbi_system_tb - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
--To simulate,
--Make UUT (ViterbiSystem) Top Level entity
--Initially, Assignments > Settings > Add Test bench file
--Then to run simulation, flow > "RTL Simulation"

entity viterbi_system_tb is
end entity viterbi_system_tb;

architecture stimulus_driver of viterbi_system_tb is
	constant CLK_PERIOD : time := 40 ns;
	constant TIME_MARGIN : time := 10 ns;
	
	
	component ViterbiSystem is 
		Generic (
			IS_THERE_BIT_ERROR : std_logic := '0';
			BIT_ERROR_POSITION : integer := 0
		);
		
		Port (
			Enc_In : in std_logic;
			Decoder_Out : out std_logic_vector(6 downto 0);
			Decoder_Out_Valid : out std_logic;
			Clock : in std_logic;
			Reset : in std_logic
		);
	end component ViterbiSystem;
	
	signal s_encoder_input : std_logic := '0';
	signal s_decoder_out :  std_logic_vector(6 downto 0) := "0000000";
	signal s_decoder_out_valid : std_logic := '0';
	signal s_clock : std_logic := '0';
	signal s_reset : std_logic := '0';
	
	
begin
	UnitUnderTest5 : ViterbiSystem 
	generic map (
		IS_THERE_BIT_ERROR => '1',
		BIT_ERROR_POSITION => 4
	)
	port map (
		Enc_In => s_encoder_input,
		Decoder_Out => s_decoder_out,
		Decoder_Out_Valid => s_decoder_out_valid,
		Clock => s_clock,
		Reset => s_reset
	);
	
	s_clock <= not s_clock after CLK_PERIOD/2;
					  
	Stimulus: process is begin
		--Initialization
		s_encoder_input <= '1';
		s_reset <= '1';
		
		--Waiting
		wait for 10 ns; --Time margin to avoid inputs changing at clock cycle.
		
		--Write possible inputs
		s_reset <= '0';
		
		wait for 5 ns;
		
		s_encoder_input <= '0'; 
		wait for CLK_PERIOD;
		
		s_encoder_input <= '1';
		wait for CLK_PERIOD;
		
		s_encoder_input <= '1';
		wait for CLK_PERIOD;
		
		s_encoder_input <= '1';
		wait for CLK_PERIOD;
		
		s_encoder_input <= '1';
		wait for CLK_PERIOD;
		
		s_encoder_input <= '1';
		wait for CLK_PERIOD;
		
		s_encoder_input <= '0';
		wait for CLK_PERIOD;
		
		
		--Stop simulation
		wait for 10 ms; 
		wait ;
	end process;	
end stimulus_driver;