----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 26.12.2020 16:14:07
-- Design Name: 
-- Module Name: UART_TX - Behavioral
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


-- Verici 8 bitlik veriyi göndermek için uygun, baþlangýç ve durdurma bitleri var, eþlik biti yoktur.
-- Ýletim tamamlandýðýnda o_TX_Done biti '1' olacak

-- Generic ile g_CLKS_PER_BIT hesabý:
-- g_CLKS_PER_BIT = (i_Clk'nýn frekansý)/(UART'ýn frekansý)
-- Example: 10 MHz saat, 115200 baud UART
-- (10000000)/(115200) = 87
--
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
 
entity UART_TX is
  generic (
    g_CLKS_PER_BIT : integer := 115     -- Doðru ayarlanmasý gerek
    );
  port (
    i_Clk       : in  std_logic;
    i_TX_DV     : in  std_logic;
    i_TX_Byte   : in  std_logic_vector(7 downto 0);
    o_TX_Active : out std_logic;
    o_TX_Serial : out std_logic;
    o_TX_Done   : out std_logic
    );
end UART_TX;
 
 
architecture RTL of UART_TX is
 
  type t_SM_Main is (s_Idle, s_TX_Start_Bit, s_TX_Data_Bits,
                     s_TX_Stop_Bit, s_Cleanup);
  signal r_SM_Main : t_SM_Main := s_Idle;
 
  signal r_Clk_Count : integer range 0 to g_CLKS_PER_BIT-1 := 0;
  signal r_Bit_Index : integer range 0 to 7 := 0;                             -- Toplam 8 bit için
  signal r_TX_Data   : std_logic_vector(7 downto 0) := (others => '0');
  signal r_TX_Done   : std_logic := '0';
   
begin
 
   
  p_UART_TX : process (i_Clk)
  begin
    if rising_edge(i_Clk) then
         
      case r_SM_Main is
 
        when s_Idle =>
          o_TX_Active <= '0';
          o_TX_Serial <= '1';         -- Sürme(Drive) hattý 'High' (IDLE Durumu için)
          r_TX_Done   <= '0';
          r_Clk_Count <= 0;
          r_Bit_Index <= 0;
 
          if i_TX_DV = '1' then
            r_TX_Data <= i_TX_Byte;
            r_SM_Main <= s_TX_Start_Bit;
          else
            r_SM_Main <= s_Idle;
          end if;
 
           
        -- Baþlangýç bitini gönder. Baþlangýç biti = 0
        when s_TX_Start_Bit =>
          o_TX_Active <= '1';
          o_TX_Serial <= '0';
 
          -- Bekle g_CLKS_PER_BIT-1 saat döngüleri (Baþlatma bitinden durma bitine kadar)
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Start_Bit;
          else
            r_Clk_Count <= 0;
            r_SM_Main   <= s_TX_Data_Bits;
          end if;
 
           
                  
        when s_TX_Data_Bits =>
          o_TX_Serial <= r_TX_Data(r_Bit_Index);
           
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Data_Bits;
          else
            r_Clk_Count <= 0;
             
            -- Kontrol (tüm bitlerin gönderildiðini kontrol etmek için)
            if r_Bit_Index < 7 then
              r_Bit_Index <= r_Bit_Index + 1;
              r_SM_Main   <= s_TX_Data_Bits;
            else
              r_Bit_Index <= 0;
              r_SM_Main   <= s_TX_Stop_Bit;
            end if;
          end if;
 
 
        -- Durdurma biti gönder  Durdurma bit = 1
        when s_TX_Stop_Bit =>
          o_TX_Serial <= '1';
 
          
          if r_Clk_Count < g_CLKS_PER_BIT-1 then
            r_Clk_Count <= r_Clk_Count + 1;
            r_SM_Main   <= s_TX_Stop_Bit;
          else
            r_TX_Done   <= '1';
            r_Clk_Count <= 0;
            r_SM_Main   <= s_Cleanup;
          end if;
 
                   
        -- 1 saat döngüsü bekle
        when s_Cleanup =>
          o_TX_Active <= '0';
          r_TX_Done   <= '1';
          r_SM_Main   <= s_Idle;
           
             
        when others =>
          r_SM_Main <= s_Idle;
 
      end case;
    end if;
  end process p_UART_TX;
 
  o_TX_Done <= r_TX_Done;
   
end RTL;
