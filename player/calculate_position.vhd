-- file: player/calculate_position.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current position based on internal register for position and
-- current speed value.

library ieee ;
use ieee.std_logic_1164.all ;

entity calculate_position is
	port (
			 speed    : in  std_logic_vector(7 downto 0) ;
			 position : out std_logic_vector(7 downto 0) ;
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic
		 ) ;
end calculate_position ;
