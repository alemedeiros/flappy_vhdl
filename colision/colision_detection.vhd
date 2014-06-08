-- file: colision/colision_detection.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Check for colision between first obstacle with player.

library ieee ;
use ieee.std_logic_1164.all ;

entity colision_detection is
	port (
			 position   : in  std_logic_vector(7 downto 0) ;
			 obst_low   : in  std_logic_vector(7 downto 0) ;
			 obst_high  : in  std_logic_vector(7 downto 0) ;
			 game_over  : out std_logic ;
			 clock      : in  std_logic ;
			 enable     : in  std_logic ;
			 reset      : in  std_logic
		 ) ;
end colision_detection ;
