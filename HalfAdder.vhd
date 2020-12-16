library IEEE;
use IEEE.STD_LOGIC_1164.ALL;



entity HalfAdder is
Port( input:in std_logic;   
      input2:in std_logic;
      out_sum:out std_logic;
      out_carry:out std_logic
);        
end HalfAdder;

architecture Behavioral of HalfAdder is
begin
    out_sum <= input xor input2;
    out_carry <= input and input2;

end Behavioral;