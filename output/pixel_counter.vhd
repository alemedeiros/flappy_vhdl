-- file: output/pixel_counter.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Sweeps through each bit of a VGA screen.

library ieee ;
use ieee.std_logic_1164.all ;

entity pixel_counter is
	generic (
				--  When changing this, remember to keep 4:3 aspect ratio
				--  Must also keep in mind that our native resolution is 640x480, and
				--  you can't cross these bounds (although you will seldom have enough
				--  on-chip memory to instantiate this module with higher res).
				NUM_HORZ_PIXELS : natural := 128 ;  -- Number of horizontal pixels
				NUM_VERT_PIXELS : natural := 96     -- Number of vertical pixels
			) ;
	port (
			 lin : out integer range 0 to NUM_VERT_PIXELS - 1 ;
			 col : out integer range 0 to NUM_HORZ_PIXELS - 1 ;

			 clock  : in std_logic ;
			 reset  : in std_logic ;
			 enable : in std_logic 
		 ) ;
end pixel_counter ;

architecture behavior of pixel_counter is
	signal my_lin : integer range 0 to NUM_VERT_PIXELS - 1 ;
	signal my_col : integer range 0 to NUM_HORZ_PIXELS - 1 ;
begin
	count_col: process (clock, reset)
	begin
		if reset = '1' then
			my_col <= 0 ;
		elsif rising_edge(clock) then
			if enable = '1' then
				if my_col = 127 then
					my_col <= 0 ;
				else
					my_col <= my_col + 1 ;
				end if ;
			end if ;
		end if ;
	end process count_col ;

	count_lin: process (clock, reset)
	begin
		if reset = '1' then
			my_lin <= 0;
		elsif rising_edge(clock) then
			if enable = '1' and my_col = 127 then
				if my_lin = 95 then
					my_lin <= 0 ;
				else
					my_lin <= my_lin + 1 ;
				end if;
			end if;
		end if;
	end process count_lin ;


	lin <= my_lin ;
	col <= my_col ;
end behavior ;
