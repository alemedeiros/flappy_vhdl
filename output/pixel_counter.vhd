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
				H_HES : natural := 128 ;  -- Horizontal Resolution
				V_RES : natural := 96     -- Vertical Resolution
			) ;
	port (
			 lin : out integer range 0 to V_RES - 1 ;
			 col : out integer range 0 to H_RES - 1 ;

			 clock  : in std_logic ;
			 reset  : in std_logic ;
			 enable : in std_logic 
		 ) ;
end pixel_counter ;

architecture behavior of pixel_counter is
	signal my_lin : integer range 0 to V_RES - 1 ;
	signal my_col : integer range 0 to H_RES - 1 ;
begin
	-- Columns counter
	count_col: process (clock, reset)
	begin
		if reset = '1' then
			my_col <= 0 ;
		elsif rising_edge(clock) then
			if enable = '1' then
				if my_col = H_RES - 1 then
					my_col <= 0 ;
				else
					my_col <= my_col + 1 ;
				end if ;
			end if ;
		end if ;
	end process count_col ;

	-- Lines counter
	count_lin: process (clock, reset)
	begin
		if reset = '1' then
			my_lin <= 0;
		elsif rising_edge(clock) then
			if enable = '1' and my_col = H_RES - 1 then
				if my_lin = V_RES - 1 then
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
