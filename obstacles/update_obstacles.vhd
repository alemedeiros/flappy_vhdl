-- file: obstacles/update_obstacles.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Update and generate new obstacles for game.

library ieee ;
use ieee.std_logic_1164.all ;

entity update_obstacles is
	port (
			 rand         : in  std_logic_vector(7 downto 0) ;
			 new_obst     : in  std_logic ;
			 obst_count   : out std_logic_vector(7 downto 0) ;
			 obst_rem     : out std_logic ;
			 clock        : in  std_logic ;
			 enable       : in  std_logic ;
			 reset        : in  std_logic
		 ) ;
end update_obstacles ;
