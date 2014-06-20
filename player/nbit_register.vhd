-- file: nbit_register.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- Solution to MC613 - Lab06.Q2.A
--
-- A n bit register

library ieee ;
use ieee.std_logic_1164.all ;

entity nbit_register is
  generic ( n : integer := 8) ;
  port ( x    : in  std_logic_vector (n-1 downto 0) ; -- Load input
         y    : out std_logic_vector (n-1 downto 0) ; -- Stored value
         ld   : in  std_logic ;                       -- Load control bit
         clr  : in  std_logic ;                       -- Clear control bit
         clk  : in  std_logic                         -- Clock
       ) ;
end nbit_register ;

architecture arch of nbit_register is
begin
  process (clk, clr)
  begin
    if clr = '1' -- Assincronous clear
    then
      y <= (others => '0') ;
    elsif clk'event and clk = '1'
    then
    -- Rising edge
      if ld = '1'
      then
      -- Load
        y <= x ;
      end if ;
    end if ;
  end process ;
end arch ;
