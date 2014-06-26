-- file: control/game_control.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Main game Finite State machine.

library ieee ;
use ieee.std_logic_1164.all ;

entity game_control is
	port (
			 game_over  : in  std_logic ;
			 reset      : in  std_logic ;
			 pause      : in  std_logic ;
			 jump       : in  std_logic ;
			 clock      : in  std_logic ;
			 obst_rem   : in  std_logic ;
			 new_obst   : out std_logic ;
			 timer      : in  std_logic ;

			 -- Enable signals for each module.
			 calculate_speed    : out std_logic ;
			 calculate_position : out std_logic ;
			 obst_regbank       : out std_logic ;
			 update_obstacles   : out std_logic ;
			 colision_detection : out std_logic ;
			 draw_frame         : out std_logic ;
			 ledcon             : out std_logic ;
			 internal_reset     : out std_logic
		 ) ;
end game_control ;


architecture behavior of game_control is
	-- State type
	type state_t is (start, update, draw, loser) ;
	signal state	  : state_t := start ;
	signal next_state : state_t := start ;
begin
	process (reset, clock) --clock)
		variable count : integer ;
	begin
		if reset = '1' then
			state <= start ;
		elsif rising_edge(clock) then
			case state is
				when start =>
					state              <= update ;

					calculate_speed    <= '0' ;
					calculate_position <= '0' ;
					obst_regbank       <= '0' ;
					update_obstacles   <= '0' ;
					new_obst           <= '0' ;
					colision_detection <= '0' ;
					draw_frame         <= '0' ;
					ledcon             <= '0' ;
					internal_reset     <= '1' ;

				when update =>
					if game_over = '1' then
						state          <= loser ;
					elsif pause = '1' then
						state          <= draw ;
					else
						state          <= update ;
					end if ;
					--state              <= draw ;

					calculate_speed    <= '1' ;
					calculate_position <= '1' ;
					obst_regbank       <= '1' ;
					update_obstacles   <= '1' ;
					new_obst           <= '0' ; -- CHECK
					colision_detection <= '1' ;
					draw_frame         <= '1' ; -- Migué
					ledcon             <= '0' ;
					internal_reset     <= '0' ;

				when draw =>
					if game_over = '1' then
						state          <= loser ;
					elsif pause = '1' then
						state          <= draw ;
					else
						state          <= update ;
					end if ;

					calculate_speed    <= '0' ;
					calculate_position <= '0' ;
					obst_regbank       <= '1' ;
					update_obstacles   <= '0' ;
					new_obst           <= '0' ;
					colision_detection <= '1' ;
					draw_frame         <= '1' ;
					ledcon             <= '1' ;
					internal_reset     <= '0' ;

				when loser =>
					state <= loser ;

					calculate_speed    <= '0' ;
					calculate_position <= '0' ;
					obst_regbank       <= '0' ;
					update_obstacles   <= '0' ;
					new_obst           <= '0' ;
					colision_detection <= '0' ;
					draw_frame         <= '1' ;
					ledcon             <= '1' ;
					internal_reset     <= '0' ;

				when others =>
					state              <= start ;

			end case ;
		end if ;
	end process ;	
end behavior ;
