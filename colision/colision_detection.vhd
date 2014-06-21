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
			V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 position   : in  integer range 0 to V_RES - 1 ;
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
	process(clock, enable)
	variable tmp_game_over: std_logic := '0';
	begin
		if (reset = '0' and enable = '1' and rising_edge(clock)) then
			if (position = 0 or obst_low >= position or V_RES - 1 - obst_high <= position) then
			  tmp_game_over := '1' ;
			end if;
		end if ;
	game_over <= tmp_game_over ;
	end process ;
end behavior ;