-- file: input/clock_divider.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Divides 27MHz clock into adequate clock value

library ieee ;
use ieee.std_logic_1164.all ;

entity clock_divider is
	port (
			 clock_27 : in  std_logic ;
			 clock    : out std_logic
		 ) ;
end clock_divider ;
