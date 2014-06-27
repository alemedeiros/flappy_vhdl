-- file: colision/colision_detection.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Check for colision between first obstacle with player.

library ieee ;
use ieee.std_logic_1164.all ;
use IEEE.std_logic_arith.all; 


entity colision_detection is
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
end colision_detection ;

architecture behavior of colision_detection is 
begin
	-- Reading values process
	process(clock)
		variable tmp : std_logic := '0' ;
	begin
		if (reset = '0' and enable = '1' and rising_edge(clock)) then
			tmp := '0' ;
			if (player >= V_RES or player < 0 or (((V_RES - 1 - obst_low) <= player or obst_high > player) and position = P_POS) ) then
				tmp := '1' ;
			end if;
		end if ;
		game_over <= tmp ;
	end process ;
end behavior ;
