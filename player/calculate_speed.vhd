-- file: player/calculate_speed.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current speed based on internal register for speed, gravity value
-- and jump signal.

library ieee ;
use ieee.std_logic_1164.all ;

entity calculate_speed is
	generic (
				V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 jump    : in  std_logic ;
			 gravity : in  integer range 0 to V_RES - 1 ;
			 speed   : out integer range - V_RES to V_RES - 1  ;
			 clock   : in  std_logic ;
			 enable  : in  std_logic ;
			 reset   : in  std_logic
		 ) ;
end calculate_speed ;

architecture behavior of calculate_speed is
	--signal sp  : integer range - V_RES to V_RES - 1 := -1;
	signal jump_aux : std_logic ;
begin
	process (clock, reset)
		variable sp  : integer range - V_RES to V_RES - 1 := -1;
	begin
		if enable = '1' and rising_edge(clock) then
			if jump = '1' then
				sp := -1 ;
			else
				sp := sp + gravity ;
			end if ;
		end if ;
		speed <= sp;
	end process ;
end behavior;
