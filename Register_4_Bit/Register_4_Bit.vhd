library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Register_4_Bit is
Port(   in_clock:in std_logic;
        in_reset:in std_logic;
        input:in std_logic_vector(3 downto 0);
        output:out std_logic_vector(3 downto 0)
);
end Register_4_Bit;

architecture Behavioral of Register_4_Bit is
    
    signal r_out:std_logic_vector(3 downto 0):=(others => '0');

begin
    process(in_clock, in_reset, input)
    begin
        if in_reset = '1' then
            r_out <= (others => '0');
        elsif in_clock'event and in_clock = '1' then
            r_out <= input;    
        end if;
    end process;
    
    output <= r_out;
    
    

end Behavioral;
