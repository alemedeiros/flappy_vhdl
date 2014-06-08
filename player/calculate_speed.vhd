-- file: player/calculate_speed.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current speed based on internal register for speed, gravity value
-- and jump signal.

library ieee ;
use ieee.std_logic_1164.all ;

entity calculate_speed is
	port (
			 jump    : in  std_logic ;
			 gravity : in  std_logic_vector(7 downto 0) ;
			 speed   : out std_logic_vector(7 downto 0) ;
			 clock   : in  std_logic ;
			 enable  : in  std_logic ;
			 reset   : in  std_logic
		 ) ;
end calculate_speed ;
