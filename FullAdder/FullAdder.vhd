library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity FullAdder is
Port(   in_carry:in std_logic;
        input1:in std_logic;
        input2:in std_logic;
        sum_output:out std_logic;
        out_carry:out std_logic
);          
    
end FullAdder;

architecture Behavioral of FullAdder is
begin
    
    sum_output <= in_carry xor input1 xor input2;
    out_carry <= ((input1 xor input2) and in_carry) or (input1 and input2);
     

end Behavioral;