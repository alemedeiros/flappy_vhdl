-- file: colision/colision_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;


package colision is
	-- Check for colision between first obstacle with player.
	component colision_detection
		port (
				 position   : in  std_logic_vector(7 downto 0) ;
				 obst_low   : in  std_logic_vector(7 downto 0) ;
				 obst_high  : in  std_logic_vector(7 downto 0) ;
				 game_over  : out std_logic ;
				 clock      : in  std_logic ;
				 enable     : in  std_logic ;
				 reset      : in  std_logic
			 ) ;
	end component ;
end colision ;

