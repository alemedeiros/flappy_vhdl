-- file: output/draw_frame.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Draw game images from current game state (player position and current
-- obstacles) using vgacon.

library ieee ;
use ieee.std_logic_1164.all ;

library module ;
use module.output.vgacon ;
use module.output.pixel_counter ;
use module.output.frame_builder ;
use module.input.clock_divider ;

entity draw_frame is
	generic (
				H_RES  : natural := 128 ;  -- Horizontal Resolution
				V_RES  : natural := 96 ;   -- Vertical Resolution
				N_OBST : natural := 4      -- Number of obstacles
			) ;
	port (
			 -- Input data
			 player    : in  integer range 0 to V_RES - 1 ;
			 obst_low  : in  integer range 0 to V_RES - 1 ;
			 obst_high : in  integer range 0 to V_RES - 1 ;
			 obst_pos  : in  integer range 0 to H_RES / N_OBST - 1;
			 obst_id   : out integer range 0 to N_OBST - 1 ;

			 -- VGA output
			 red      : out std_logic_vector(3 downto 0) ;
			 green    : out std_logic_vector(3 downto 0) ;
			 blue     : out std_logic_vector(3 downto 0) ;
			 hsync    : out std_logic ;
			 vsync    : out std_logic ;

			 -- Control signals
			 clock      : in  std_logic ;
			 enable     : in  std_logic ;
			 reset      : in  std_logic
		 ) ;
end draw_frame ;

architecture behavior of draw_frame is
	-- State type
	type state_t is (start, clear, update_frame) ;
	signal state	    : state_t := start ;
	signal next_state : state_t := start ;

	signal finish_write : std_logic ;

	-- Local control signals
	signal we       : std_logic := '1' ; -- VGA controller write enable
	signal lin      : integer range 0 to V_RES - 1 ;
	signal col      : integer range 0 to H_RES - 1 ;
	signal colour   : std_logic_vector(2 downto 0) ;

	-- Pixel counter signals
	signal pxl_count_rst : std_logic ;
	signal pxl_count_en  : std_logic ;

	-- Frame builder signals
	signal pxl_col_en : std_logic ;
	signal pxl_colour : std_logic_vector(2 downto 0) ;

	-- Timer signals
	signal timer        : std_logic ;
	signal timer_en     : std_logic ;
	signal timer_rst    : std_logic ;
begin
	-- VGA controller
	vga_controller: vgacon
	generic map (
					NUM_HORZ_PIXELS => H_RES,
					NUM_VERT_PIXELS => V_RES
				)
	port map (
				 clk27M       => clock,
				 rstn         => not reset,
				 red          => red,
				 green        => green,
				 blue         => blue,
				 hsync        => hsync,
				 vsync        => vsync,
				 write_clk    => clock,
				 write_enable => we,
				 write_addr   => col + (128 * lin),
				 data_in      => colour
			 ) ;

	-- Pixel counter, sweeps through each pixel of vga
	count_pixel: pixel_counter
	generic map (
					H_RES => H_RES,
					V_RES => V_RES
				)
	port map (
				 lin    => lin,
				 col    => col,
				 clock  => clock,
				 reset  => pxl_count_rst,
				 enable => pxl_count_en
			 ) ;

	-- Using the game state information, build a frame.
	build_frame: frame_builder
	generic map (
					H_RES  => H_RES,
					V_RES  => V_RES,
					N_OBST => N_OBST
				)
	port map (
				 player    => player,
				 obst_low  => obst_low,
				 obst_high => obst_high,
				 obst_pos  => obst_pos,
				 obst_id   => obst_id,

				 lin       => lin,
				 col       => col,

				 enable    => pxl_col_en,
				 colour    => pxl_colour
			 ) ;

	frame_timer : clock_divider
	generic map (
					RATE => 270000 
				)
	port map (
				 clk_in  => clock,
				 clk_out => timer,
				 enable  => timer_en,
				 reset   => timer_rst
			 ) ;

	-- Signal end of frame write
	finish_write <= '1' when (lin = V_RES - 1) and (col = H_RES - 1) else '0' ;

	-- Finite State Machine for drawing frame.
	fsm: process(state, finish_write, timer, enable)
	begin
		if enable = '0' then
			next_state <= state ;
			timer_en      <= '0' ;
			timer_rst     <= '0' ;

			pxl_col_en    <= '0' ;
			pxl_count_rst <= '0' ;
			pxl_count_en  <= '0' ;

			we            <= '0' ;
			colour        <= "000" ;
		else
			case state is
				when start =>
					if timer = '1' then
						next_state <= update_frame ;
					else
						next_state <= start ;
					end if ;
					timer_en      <= '1' ;
					timer_rst     <= '0' ;

					pxl_col_en    <= '0' ;
					pxl_count_rst <= '1' ;
					pxl_count_en  <= '0' ;

					we            <= '0' ;
					colour        <= "000" ;

				when clear =>
					if finish_write = '1' then
						next_state <= start ;
					else
						next_state <= clear ;
					end if ;
					timer_en      <= '0' ;
					timer_rst     <= '1' ;

					pxl_col_en    <= '0' ;
					pxl_count_rst <= '0' ;
					pxl_count_en  <= '1' ;

					we            <= '1' ;
					colour        <= "000" ;

				when update_frame =>
					if finish_write = '1' then
						next_state <= start ;
					else
						next_state <= update_frame ;
					end if ;
					timer_en      <= '0' ;
					timer_rst     <= '1' ;

					pxl_col_en    <= '1' ;
					pxl_count_rst <= '0' ;
					pxl_count_en  <= '1' ;

					we            <= '1' ;
					colour        <= pxl_colour ;

				when others =>
					next_state    <= start ;
					timer_en      <= '0' ;
					timer_rst     <= '1' ;

					pxl_col_en    <= '0' ;
					pxl_count_rst <= '1' ;
					pxl_count_en  <= '0' ;

					we            <= '0' ;
					colour        <= "000" ;
			end case ;
		end if ;
	end process ;

	-- Update state process.
	update_state: process(clock, reset)
	begin
		if reset = '1' then
			state <= clear ;
		elsif rising_edge(clock) then
			state <= next_state ;
		end if ;
	end process ;
end behavior ;
