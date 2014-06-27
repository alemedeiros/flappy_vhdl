-- file: modules/obstacles_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package obstacles is

	-- Set of n registers to save the obstacles positions (2 integers for each
	-- obstacle), when an obstacle reaches the horizontal position 0, it is
	-- automatically discarded and a new one is read from in_{low,high}
	component obst_regbank
		generic (
					H_RES  : natural := 128 ;  -- Horizontal Resolution
					V_RES  : natural := 96 ;   -- Vertical Resolution
					N_OBST : natural := 4      -- Number of obstacles
				) ;
		port (
				 -- New obstacles input
				 in_low   : in  integer range 0 to V_RES - 1 ;
				 in_high  : in  integer range 0 to V_RES - 1 ;
				 up_clk   : in  std_logic ;

				 -- Read current values
				 id       : in  integer range 0 to N_OBST - 1 ;
				 low      : out integer range 0 to V_RES - 1 ;
				 high     : out integer range 0 to V_RES - 1 ;
				 pos      : out integer range 0 to H_RES / N_OBST - 1 ;

				 -- Control signal
				 clock    : in  std_logic ;
				 enable   : in  std_logic ;
				 reset    : in  std_logic ;
				 obst_rem : out std_logic
			 ) ;
	end component ;

	-- Update and generate new obstacles for game.
	component update_obstacles
		generic (
					H_RES  : natural := 128 ;  -- Horizontal Resolution
					V_RES  : natural := 96 ;   -- Vertical Resolution
					N_OBST : natural := 4      -- Number of obstacles
				) ;
		port (
				 new_obst     : in  std_logic ;
				 obst_count   : buffer integer range 0 to 255 ;
				 low_obst     : out integer range 0 to V_RES - 1 ;
				 high_obst    : out integer range 0 to V_RES - 1 ;
				 obst_rem     : out std_logic ;
				 clock        : in  std_logic ;
				 enable       : in  std_logic ;
				 reset        : in  std_logic
			 ) ;
	end component ;

	-- Random number module.
	component generate_random
		generic (
					V_RES  : integer := 96    -- Vertical Resolution
				) ;
		port (
				 rand   : out integer range 0 to (V_RES/2 - 1) ;
				 clock  : in  std_logic
			 ) ;
	end component ;
end obstacles ;
