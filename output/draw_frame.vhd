-- file: output/draw_frame.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Draw game images from current game state (player position and current
-- obstacles) using vgacon.

library ieee ;
use ieee.std_logic_1164.all ;

entity draw_frame is
	port (
			 position   : in  std_logic_vector(7 downto 0) ;
			 obst_low   : in  std_logic_vector(7 downto 0) ;
			 obst_high  : in  std_logic_vector(7 downto 0) ;
			 obst_id    : out std_logic_vector(2 downto 0) ;
			 clock      : in  std_logic ;
			 enable     : in  std_logic ;
			 reset      : in  std_logic
		 ) ;
end draw_frame ;
