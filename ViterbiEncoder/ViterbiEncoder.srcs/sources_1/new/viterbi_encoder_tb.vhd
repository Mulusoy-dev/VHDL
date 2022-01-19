----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2021 10:06:56
-- Design Name: 
-- Module Name: viterbi_encoder_tb - Behavioral
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
--Make UUT (ViterbiEncoder) Top Level entity
--Initially, Assignments > Settings > Add Test bench file
--Then to run simulation, flow > "RTL Simulation"

entity viterbi_encoder_tb is
end entity viterbi_encoder_tb;

architecture stimulus_driver of viterbi_encoder_tb is
	constant CLK_PERIOD : time := 40 ns;
	constant TIME_MARGIN : time := 10 ns;
	component ViterbiEncoder is
		Port (
			Input : in std_logic;
			Output: out std_logic_vector (1 downto 0);
			Reset : in std_logic;
			Clock : in std_logic
		);
	end component ViterbiEncoder;
	signal s_input : std_logic;
	signal s_output : std_logic_vector(1 downto 0) := "00";
	signal s_reset : std_logic := '0';
	signal s_clock : std_logic :='0';
begin
	UnitUnderTest3 : ViterbiEncoder port map (
		Input => s_input,
		Output => s_output,
		Reset => s_reset,
		Clock => s_clock
	);
	
	s_clock <= not s_clock after CLK_PERIOD/2;
					  
	Stimulus: process is begin
		--Initialization
		s_input <= '0';
		s_reset <= '1';
		
		--Waiting
	 --Time margin to avoid inputs changing at clock cycle.
		
		--Write possible inputs
		s_reset <= '0';
		
		
		
		s_input <= '1'; -- 1011000
		wait for CLK_PERIOD;
		
		s_input <= '0';
		wait for CLK_PERIOD;
		
		s_input <= '1';
		wait for CLK_PERIOD;
		
		s_input <= '1';
		wait for CLK_PERIOD;
		
		s_input <= '0';
		wait for CLK_PERIOD;
		
		s_input <= '0';
		wait for CLK_PERIOD;
		
		s_input <= '0';
		wait for CLK_PERIOD;
		
		--Stop simulation
		wait; 
	end process;	
end stimulus_driver;