-- file: modules/player_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package player is

	-- Calculate current speed based on internal register for speed, gravity value
	-- and jump signal.
	component calculate_speed
		generic (
		V_RES  : natural     -- Vertical Resolution
	) ;
	port (
			 jump    : in  std_logic ;
			 gravity : in  integer range 0 to V_RES - 1 ;
			 speed   : out integer range - V_RES to V_RES - 1 ;
			 clock   : in  std_logic ;
			 enable  : in  std_logic ;
			 reset   : in  std_logic
		 ) ;
	end component ;

	-- Calculate current position based on internal register for position and
	-- current speed value.
	component calculate_position
		generic (
		V_RES  : natural     -- Vertical Resolution
	) ;	
	port (
			 jump     : in  std_logic ;
			 gravity  : in  integer range 0 to V_RES - 1 ;
			 position : out integer range 0 to V_RES - 1 ;
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic
		 ) ;
	end component ;
end player ;
