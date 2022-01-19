----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2020 15:01:24
-- Design Name: 
-- Module Name: spi_slave - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity spi_slave is
Generic(
    data_length:integer:=16);
Port(
    reset_n:in std_logic;                                                        --Asenkron reset(low reset)
    cpol:in std_logic;                                                           --Polarite Mod
    cpha:in std_logic;                                                           --Faz Mod
    sclk:in std_logic;                                                           --SPI Saat
    ss_n:in std_logic;                                                           --Slave seçim
    mosi:in std_logic;                                                           --Master Out Slave In
    miso:out std_logic;                                                          --Master In Slave Out
    rx_enable:in std_logic;                                                      --rxBuffer verisinin dýþarýya aktarýlmasý için izin sinyali
    tx:in std_logic_vector(data_length-1 downto 0);                              --Slave cihazýn mikrodenetleyicisi tarafýnda paralel olarak gönderilen veri
    rx:out std_logic_vector(data_length-1 downto 0):=(others =>'0');             --Slave'in baþlangýçta göndereceði veri '000000000000000' 
    busy:out std_logic:='0'                                                      --Slave meþgul sinyali
);        
end spi_slave;

architecture Behavioral of spi_slave is

    signal mode:std_logic;                                           --CPOL ve CPHA'ye göre düzenleme
    signal clk:std_logic;
    signal bit_counter:std_logic_vector(data_length downto 0);       --Aktif bit iþareti
    signal rxBuffer:std_logic_vector(data_length-1 downto 0):=(others=>'0');       --Slave in göndereceði veri
    signal txBuffer:std_logic_vector(data_length-1 downto 0):=(others=>'0');       --Mikrodenetleyiciden Slave e aktarýlan veri
begin

    busy <= not ss_n;
    mode <= cpol xor cpha;
    
    process(mode, ss_n, sclk)
    begin
        if(ss_n='1') then
            clk <= '0';
        else
            if mode = '1' then             --mode = '1' olmasý için cpol=0 ve cpha=0 olmasý durumu
                clk <= sclk;               --ana saat ile spi saati burada eþitleniyor(domain eþitleme)
            else
                clk <= not sclk;
            end if;
        end if;
    end process;                        
    
    --Aktif Bit Nerede
    process(ss_n, clk)
    begin
        if(ss_n='1' or reset_n='0') then
            bit_counter <= (conv_integer(not cpha) => '1', others => '0');       --reset aktif bit iþaretçisi
        else
            if (rising_edge(clk)) then
                bit_counter <= bit_counter(data_length-1 downto 0) & '0';        --sola kaydýrma biti iþaretçisi   
            end if;       
        end if;
    end process;
    process (ss_n, clk, rx_enable, reset_n)
    begin
        --Alýnan mosi Bit
        if(cpha='0') then
            if( reset_n='0') then
                rxBuffer <= (others => '0');
            elsif (bit_counter /= "0000000000000010" and falling_edge(clk)) then
                rxBuffer(data_length-1 downto 0) <= rxBuffer(data_length-2 downto 0) & mosi;      --Alýnan biti kaydýrma
            end if;
        else
            if (reset_n='0') then
                rxBuffer <= (others => '0');
            elsif (bit_counter /= "0000000000000001" and falling_edge(clk)) then
                rxBuffer(data_length-1 downto 0) <= rxBuffer(data_length-2 downto 0) & mosi;
            end if;
        end if;        
                
                
        
        --Kullanýcý alýnan verinin çýktýsýný istiyorsa
        if (reset_n='0') then
            rx <= (others => '0');
        elsif (ss_n='1' and rx_enable='1') then
            rx <= rxBuffer;
        end if;
        
        --Gönderici Bellek
        if (reset_n='0') then
            txBuffer <= (others => '0');
        elsif (ss_n = '1') then
            txBuffer <= tx;
        elsif (bit_counter(data_length)='0' and rising_edge(clk)) then
            txBuffer(data_length-1 downto 0) <= txBuffer(data_length-2 downto 0) & txBuffer(data_length-1);   --tx içerisinde kaydýrma
        end if;
        
        
        
        --miso bitini gönderme
        if (ss_n ='1' or reset_n='0') then
            miso <= 'Z';
        elsif (rising_edge(clk)) then
            miso <= txBuffer(data_length -1);
        end if;
    end process;
end Behavioral;            
        
        
                         
        
        
        
        
        
        
        
        
                
                
                
                    
        
        
                                       








