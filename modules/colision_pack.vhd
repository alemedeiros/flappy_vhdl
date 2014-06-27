-- file: modules/colision_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package colision is
	-- Check for colision between first obstacle with player.
	component colision_detection
		generic (
					H_RES  : natural := 128 ;  -- Horizontal Resolution
					V_RES  : natural := 96 ;   -- Vertical Resolution
					N_OBST : natural := 4 ;    -- Number of obstacles
					P_POS  : natural := 20     -- Player Horizontal position
				) ;
		port (
				 player     : in  integer range 0 to V_RES - 1 ;
				 position   : in  integer range 0 to H_RES / N_OBST - 1;
				 obst_low   : in  integer range 0 to V_RES - 1 ;
				 obst_high  : in  integer range 0 to V_RES - 1 ;
				 game_over  : out std_logic ;
				 clock      : in  std_logic ;
				 enable     : in  std_logic ;
				 reset      : in  std_logic
			 ) ;
	end component ;
end colision ;
