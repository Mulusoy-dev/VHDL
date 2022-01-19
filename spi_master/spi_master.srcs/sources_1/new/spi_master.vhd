----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 27.12.2020 13:43:20
-- Design Name: 
-- Module Name: spi_master - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity spi_master is
Generic(
    data_length:integer:=16);
Port(
    clk:in std_logic;
    reset_n:in std_logic;
    enable:in std_logic;
    cpol:in std_logic;
    cpha:in std_logic;
    miso:in std_logic;
    sclk:out std_logic;
    ss_n:out std_logic;
    mosi:out std_logic;
    busy:out std_logic;
    tx:in std_logic_vector(data_length-1 downto 0);             --Mikroiþlemciden veya mikrodenetleyiciden alýnan paralel veri (Gönderilecek Veri)
    rx:out std_logic_vector(data_length-1 downto 0)             --Bu paralel veriyi slave serileþtirerek seri olarak gönderilecek veri (Alýnacak Veri)
);        
end spi_master;

architecture Behavioral of spi_master is

    type FSM is (init, execute);                                 --Sonlu Durum Makinesi
    signal state: FSM;
    signal receive_transmit: std_logic;                          -- '1' tx, '0' rx için
    signal clk_toggles:integer range 0 to data_length*2 +1;      --Saat tersleme sayýsý
    signal last_bit:integer range 0 to data_length*2;            --Son bit göstergesi
    signal rxBuffer:std_logic_vector(data_length-1 downto 0):=(others =>'0');              --Alýnacak Veri Sürücüsü
    signal txBuffer:std_logic_vector(data_length-1 downto 0):=(others =>'0');              --Gönderilecek Veri Sürücüsü
    signal INT_ss_n:std_logic;                             --ss_n için hafýza
    signal INT_sclk:std_logic;                             --sclk için hafýza
    
begin

    ss_n <=INT_ss_n;
    sclk <=INT_sclk;
    
    process(clk, reset_n)
    begin
        if (reset_n = '0') then
            busy<='1';                                --busy, Master meþgul sinyalidir. 
            INT_ss_n <= '1';                          --Slave seçim sinyalidir '1' olmasý demek cihaz seçimi olmadý, haberleþmeye baþlamasý için '0' olmasý lazým
            mosi <= 'Z';                              --yüksek empedans (High Impedance)
            rx <= (others => '0');
            state <=init;

        elsif (falling_edge(clk)) then
            case state is
                when init =>
                    busy <='0';                       --Haberleþmeye henüz uygun deðil sinyalini verir
                    INT_ss_n <= '1';                  --Cihaz suanda da seçili deðil
                    mosi <= 'Z';                      
                    
                    if (enable = '1') then             --Haberleþmeyi baþlat
                    
                    busy <='1';
                    INT_sclk <= cpol;                  --SPI saat polaritesini oluþturma
                    receive_transmit <= not cpha;       --cpol '1' ise yükselen kenarda veri gönderme demek, 
                                                       --bu ifadede ise cpha '0' olacaðýndan tx mosunda yükselen kenarda veriyi gönderir
                                                           
                    txBuffer<=tx;                     --Mikrodenetleyiciden alýnan arabellek veriyi txBuffer sinyaline atýyor
                    clk_toggles<=0;                   --saat tersleme sayýcýsýný baþlat
                    last_bit <= data_length*2 + conv_integer(cpha)-1;          --Son rx biti oluþumu
                                                                              --cpha '0' olacaðýndan, bu deðer son bit 31 olan son yükselen kenarýdýr
                    state <= execute;
                    
                    else
                        state <= init;
                    end if;                                                               
                                                                                
                when execute =>
                    busy <= '1';
                    INT_ss_n <= '0';                                  --Slave seçim sinyalini düþük yapmamýz cihazý seçtik sinyalini gönderir
                    receive_transmit <= not receive_transmit;         --Alýcý verici modu deðiþimi
                    
                    --Sayýcý 
                    if (clk_toggles =data_length*2 +1) then
                        clk_toggles <= 0;                             --Sayýcý Sýfýrlama(Reset)
                    else
                        clk_toggles <= clk_toggles + 1;               --Sayýcý artýrýmý     
                    end if;
                    
                    --Saat Terslemesi
                    if (clk_toggles <= clk_toggles*2 and INT_ss_n= '0') then                   --Saatin çift kenarlarýnda hep bir bit gönderiliyor bu yüzden çarpý 2 ve tabiki cihazýn seçili olmasý gerekir
                        INT_sclk <= not INT_sclk;                                              --Spi saat Terslemesi
                    end if;    
                    
                    --Alýnan miso Bit
                    if (receive_transmit = '0' and clk_toggles < last_bit +1 and INT_ss_n = '0') then       --receive_transmit '0' demek rx den veriyi gönderiyor
                        rxBuffer <= rxBuffer(data_length-2 downto 0) & miso;                                --Sola kaydýrma yapýlýyor
                    end if;
                    
                    --Gönderilen mosi Bit
                    if (receive_transmit = '1' and clk_toggles < last_bit) then
                        mosi <= txBuffer(data_length-1);
                        txBuffer <= txBuffer(data_length-2 downto 0) & '0';                                  --Sola kaydýrma
                    end if;        
                    
                    --Bitirme/Bekletme haberleþme iþlemleri
                    if (clk_toggles = data_length*2 +1) then
                        busy <= '0';
                        INT_ss_n <= '1';
                        mosi <='Z';
                        rx <= rxBuffer;
                        state <= init;
                    else
                        state <= execute;
                    end if;
                end case;
            end if;
        end process;
    end Behavioral;                        
                    
                    
                    





