----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2021 11:13:27
-- Design Name: 
-- Module Name: ViterbiSystem - Behavioral
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

entity ViterbiSystem is 
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
end entity ViterbiSystem;

architecture comb of ViterbiSystem is
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

	
	component ViterbiDecoder is
		Generic (
			CONSTRAINT_LENGTH: integer := 4;
			TIME_WINDOW : integer := 7;
			TOTAL_PARITY_BITS : integer := 2;
			TOTAL_PATHS : integer := 128;
			IS_THERE_BIT_ERROR : std_logic := '0';
			BIT_ERROR_POSITION : integer := 0
		 );
		Port (
			ParityIn : in std_logic_vector ( TOTAL_PARITY_BITS-1 downto 0);
			Output: out std_logic_vector(0 to TIME_WINDOW-1);
			Output_Valid : out std_logic;
			Reset : in std_logic;
			Clock : in std_logic
		);
	end component ViterbiDecoder;
	

	signal s_output : std_logic_vector(1 downto 0) ;

	
begin
	ve : ViterbiEncoder 	port map (
		Input => Enc_In,
		Output => s_output,
		Reset => Reset,
		Clock => Clock
	);
	
	vd : ViterbiDecoder 
	generic map (
		IS_THERE_BIT_ERROR => IS_THERE_BIT_ERROR,
		BIT_ERROR_POSITION => BIT_ERROR_POSITION
	)
	port map (
		ParityIn => s_output,
		Output => Decoder_Out,
		Output_Valid => Decoder_Out_Valid,
		Reset => Reset,
		Clock => Clock
	);
	
end comb;
