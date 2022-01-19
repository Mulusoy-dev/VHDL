----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03.01.2021 10:05:25
-- Design Name: 
-- Module Name: ViterbiEncoder - Behavioral
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
use IEEE.NUMERIC_STD.ALL;

entity ViterbiEncoder is
	Port (
		Input : in std_logic;
		Output: out std_logic_vector (1 downto 0);
		Reset : in std_logic;
		Clock : in std_logic
	);
end entity ViterbiEncoder;

architecture RTL of ViterbiEncoder is
	signal MEMORY : std_logic_vector (2 downto 0) := "000";
	signal V1 : std_logic;
	signal V2 : std_logic;
begin
	ShiftRegister: 
		process (Clock, Reset) is begin
			if (rising_edge(Clock)) then	 --Senkron Sýfýrlama
				if (Reset = '1') then
					MEMORY <= (others => '0');
				else
					MEMORY(0) <= MEMORY(1);
					MEMORY(1) <= MEMORY(2);
					MEMORY(2) <=  Input;
				end if;
			end if;
		end process;
		
		
		V1 <= (Input xor MEMORY(2) xor MEMORY(1) xor MEMORY(0));
		V2 <= (Input xor MEMORY(2) xor MEMORY(0));
		Output(0) <= V2;
		Output(1) <= V1;
end architecture;