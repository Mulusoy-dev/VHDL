library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Synchronous_DFF is
Port(   in_clock:in std_logic;
        in_reset:in std_logic;
        input:in std_logic;
        output:out std_logic;
        not_output: out std_logic
);              
end Synchronous_DFF;

architecture Behavioral of Synchronous_DFF is
    signal r_out :std_logic:= '0';
begin
    process(in_clock, in_reset, input)
    begin
        if in_clock'event and in_clock='1' then
            if in_reset='1' then
                r_out <= '0';
            else
                r_out <= input;
            end if;
        end if;
    end process;
    
    output <= r_out;
    not_output <= not r_out;                

end Behavioral;