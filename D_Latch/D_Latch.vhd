library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity RisingEdgeD_FF is
port(
    d: in std_logic;
    clk: in std_logic;
    reset: in std_logic;
    q: out std_logic
);
end RisingEdgeD_FF;


architecture Behavioral of RisingEdgeD_FF is
            
begin
    process(clk, reset)
        begin
            if reset='1' then
                q<='0';
            elsif (clk'event and clk='1') then
                q<=d;
            end if;
    end process;


end Behavioral;
