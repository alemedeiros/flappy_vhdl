-- file: output/draw_frame.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Generate a frame from the current game state.

library ieee ;
use ieee.std_logic_1164.all ;

entity frame_builder is
	port (
			 -- Game state data.
			 player    : in  integer range 0 to 95 ;
			 obst_low  : in  integer range 0 to 95 ;
			 obst_high : in  integer range 0 to 95 ;
			 obst_pos  : in  integer range 0 to 127 ;
			 obst_id   : out integer range 0 to 3 ;

			 lin : in  integer range 0 to 95 ;
			 col : in  integer range 0 to 127 ;

			 colour    : out std_logic_vector(2 downto 0) ;
			 wren      : out std_logic
		 ) ;
end frame_builder ;

architecture behavior of frame_builder is
begin
	wren <= '1' ;
	process(lin, col)
		variable curr_id : integer range 0 to 3 ;
	begin
		-- Background colour is black
		colour <= "000" ;
		
		-- Determine current obstacle.
		curr_id := col / 32 ;
		obst_id <= curr_id ;

		if lin = player and col = 10 then         -- Player colour
			colour <= "110" ;
		elsif col = curr_id * 32 + obst_pos then -- Obstacles colour
			if lin < obst_high then              -- Top obstacle
				colour <= "010" ;
			elsif lin >= 95 - obst_low then      -- Bottom obstacle
				colour <= "010" ;
			end if ;
		end if ;
	end process ;
end behavior ;
