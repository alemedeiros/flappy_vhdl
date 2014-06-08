-- file: control/control_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package control is
	-- Main game Finite State machine.
	component game_control
		port (
				 game_over  : in  std_logic ;
				 reset      : in  std_logic ;
				 pause      : in  std_logic ;
				 jump       : in  std_logic ;
				 clock      : in  std_logic ;
				 obst_rem   : in  std_logic ;
				 new_obst   : out std_logic ;

				 -- Enable signals for each module.
				 calculate_speed    : out std_logic ;
				 calculate_position : out std_logic ;
				 obst_regbank       : out std_logic ;
				 update_obstacles   : out std_logic ;
				 colision_detection : out std_logic ;
				 draw_frame         : out std_logic ;
				 ledcon             : out std_logic
			 ) ;
	end component ;
end control ;
