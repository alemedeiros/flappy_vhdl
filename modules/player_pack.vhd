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
		port (
				 jump    : in  std_logic ;
				 gravity : in  std_logic_vector(7 downto 0) ;
				 speed   : out std_logic_vector(7 downto 0) ;
				 clock   : in  std_logic ;
				 enable  : in  std_logic ;
				 reset   : in  std_logic
			 ) ;
	end component ;

	-- Calculate current position based on internal register for position and
	-- current speed value.
	component calculate_position
		port (
				 speed    : in  std_logic_vector(7 downto 0) ;
				 position : out std_logic_vector(7 downto 0) ;
				 clock    : in  std_logic ;
				 enable   : in  std_logic ;
				 reset    : in  std_logic
			 ) ;
	end component ;
end player ;
