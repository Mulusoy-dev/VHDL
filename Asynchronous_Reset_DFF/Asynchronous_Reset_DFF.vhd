library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Asynchronous_Reset_DFF is
Port(   in_clock:in std_logic;
        in_reset:in std_logic;
        input:in std_logic;
        output: out std_logic;
        not_output:out std_logic
);        
end Asynchronous_Reset_DFF;

architecture Behavioral of Asynchronous_Reset_DFF is
    signal r_out:std_logic:='0';
begin
    process(in_reset, in_clock, input)
    begin
        if in_reset = '1' then
            r_out <= '0';
        elsif in_clock'event and in_clock='1' then
            r_out <= input;    
        end if;
    end process;
    
    output <= r_out;
    not_output <= not r_out;    

end Behavioral;
