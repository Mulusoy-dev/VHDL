library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Component_With_FullAdder is
Port(   in_carry:in std_logic;
        input1:in std_logic_vector(3 downto 0);
        input2:in std_logic_vector(3 downto 0);
        sum_output:out std_logic_vector(3 downto 0);
        out_carry:out std_logic
);            
end Component_With_FullAdder;

architecture Behavioral of Component_With_FullAdder is

  component FullAdder
  Port( in_carry:in std_logic;
        input1:in std_logic;
        input2:in std_logic;
        sum_output:out std_logic;
        out_carry:out std_logic
  );
  end component;
  
  signal r_carry:std_logic_vector(1 to 3);      
begin

    step0: FullAdder port map(in_carry, input1(0), input2(0), sum_output(0), r_carry(1));
    step1: FullAdder port map(r_carry(1), input1(1), input2(1), sum_output(1), r_carry(2));
    step3: FullAdder port map(r_carry(2), input1(2), input2(2), sum_output(2), r_carry(3));
    step4: FullAdder port map(in_carry => r_carry(3), input1 =>input1(3), input2 => input2(3), sum_output => sum_output(3), out_carry => out_carry);
    
end Behavioral;
