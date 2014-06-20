-- file: nbit_register_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- Solution to MC613 - Lab06.Q2.A
--
-- This package contains the following components:
--
--  * nbit_register:
-- A n bit register

library ieee ;
use ieee.std_logic_1164.all ;

package nbit_register_pack is
  component nbit_register
    generic ( n : integer := 8) ;
    port ( x    : in  std_logic_vector (n-1 downto 0) ; -- Load input
           y    : out std_logic_vector (n-1 downto 0) ; -- Stored value
           ld   : in  std_logic ;                       -- Load control bit
           clr  : in  std_logic ;                       -- Clear control bit
           clk  : in  std_logic                         -- Clock
         ) ;
  end component ;
end nbit_register_pack ;
