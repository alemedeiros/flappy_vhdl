-- file: player/calculate_position.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current position based on internal register for position and
-- current speed value.

library ieee ;
use ieee.std_logic_1164.all ;

entity calculate_position is
	generic (
				V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 jump     : in  std_logic ;
			 gravity  : in  integer range 0 to V_RES - 1 ;
			 position : out integer range 0 to V_RES - 1 ;
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic
		 ) ;
end calculate_position ;


architecture behavior of calculate_position is
	--signal y: integer range 0 to V_RES - 1 := V_RES / 2 ;
	signal my_speed : integer range - V_RES to V_RES - 1 ;
begin
	process (clock, reset)
		variable y: integer range 0 to V_RES - 1 := V_RES / 2 ;
	begin
		if reset = '1' then
			y := V_RES / 2 ;
		elsif enable = '1' and rising_edge(clock) then
			y := y + my_speed ;
		end if;
		position <= y ;
	end process;

	process (clock, reset)
		variable sp  : integer range - V_RES to V_RES - 1 := -5 ;
	begin
		if reset = '1' then
			sp := -5 ;
		elsif enable = '1' and rising_edge(clock) then
			if jump = '1' then
				sp := -5 ;
			else
				sp := sp + gravity ;
			end if ;
		end if ;
		my_speed <= sp;
	end process ;
end behavior;
