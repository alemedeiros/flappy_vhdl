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
	generic (
				H_RES  : natural := 128 ;  -- Horizontal Resolution
				V_RES  : natural := 96 ;   -- Vertical Resolution
				N_OBST : natural := 4 ;    -- Number of obstacles
				P_POS  : natural := 20     -- Player Horizontal position
			) ;
	port (
			 -- Game state data.
			 player    : in  integer range 0 to V_RES - 1 ;
			 obst_low  : in  integer range 0 to V_RES - 1 ;
			 obst_high : in  integer range 0 to V_RES - 1 ;
			 obst_pos  : in  integer range 0 to H_RES / N_OBST - 1;
			 obst_id   : out integer range 0 to N_OBST - 1 ;

			 lin : in  integer range 0 to V_RES - 1 ;
			 col : in  integer range 0 to H_RES - 1 ;

			 enable    : in std_logic ;
			 colour    : out std_logic_vector(2 downto 0)
		 ) ;
end frame_builder ;

architecture behavior of frame_builder is
	signal c  : std_logic_vector(2 downto 0) ;
	signal id : integer range 0 to N_OBST - 1 ;
begin

	-- Process that determines the colour of each pixel.
	process(lin, col)
		variable curr_id : integer range 0 to N_OBST - 1 ;
	begin
		-- Background colour is black
		c <= "000" ;

		-- Determine current obstacle.
		curr_id := col / (H_RES / N_OBST) ;
		id <= curr_id ;

		if lin = player and col = P_POS then         -- Player colour
			c <= "110" ;
		elsif col = curr_id * (H_RES / N_OBST) + obst_pos then -- Obstacles colour
			if lin < obst_high then              -- Top obstacle
				c <= "010" ;
			elsif lin > (V_RES - 1) - obst_low then      -- Bottom obstacle
				c <= "010" ;
			end if ;
		end if ;
	end process ;

	colour  <= c  when enable = '1' else "ZZZ" ;
	obst_id <= id when enable = '1' else 0 ;
end behavior ;
