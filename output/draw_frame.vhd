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

entity draw_frame is
	port (
			 -- Input data
			 position   : in  std_logic_vector(7 downto 0) ;
			 obst_low   : in  std_logic_vector(7 downto 0) ;
			 obst_high  : in  std_logic_vector(7 downto 0) ;
			 obst_id    : out std_logic_vector(2 downto 0) ;

			 -- VGA output
			 red      : out std_logic_vector(3 downto 0) ;
			 green    : out std_logic_vector(3 downto 0) ;
			 blue     : out std_logic_vector(3 downto 0) ;
			 hsync    : out std_logic ;
			 vsync    : out std_logic ;

			 -- DEBUG
			 hex      : out std_logic_vector(6 downto 0) ;
			 st       : in std_logic ;

			 -- Control signals
			 clock      : in  std_logic ;
			 enable     : in  std_logic ;
			 reset      : in  std_logic
		 ) ;
end draw_frame ;

architecture behavior of draw_frame is
	-- State type
	type state_t is (clear, update_frame) ;
	signal state	  : state_t := clear ;
	signal next_state : state_t := clear ;

	signal ch : std_logic ; -- Change state signal
	signal finish_write : std_logic ;
	signal data : std_logic_vector(2 downto 0) ;

	-- Local control signals
	signal we : std_logic := '1' ; -- VGA controller write enable
	signal pos : integer range 0 to 12287 ;
	signal lin : integer range 0 to 95 ;
	signal col : integer range 0 to 127 ;
begin
	-- VGA controller
	vga_controller: vgacon
	port map (
				 clk27M		  => clock,
				 rstn		  => '1',
				 red		  => red,
				 green		  => green,
				 blue		  => blue,
				 hsync		  => hsync,
				 vsync		  => vsync,
				 write_clk	  => clock,
				 write_enable => we,
				 write_addr	  => pos,
				 data_in	  => data
			 ) ;

	-- Pixel counter, sweeps through each pixel of vga
	pxl_count: pixel_counter
	port map (
				 lin => lin,
				 col => col,
				 clock => clock,
				 reset => reset,
				 enable => enable
			 ) ;
	pos <= col + (128 * lin) ;

	-- Set finish write:
	finish_write <= '1' when (lin = 95) and (col = 127) else '0' ;

	-- DEBUG
	ch <= finish_write ;

	-- Finite State Machine for drawing frame.
	fsm: process(state, ch)
	begin
		case state is
			when clear		  =>
				if ch = '1' then
					next_state <= update_frame ;
				else
					next_state <= clear ;
				end if ;
				data <= "000" ;

			when update_frame =>
				if ch = '1' then
					next_state <= update_frame ;
				else
					next_state <= update_frame ;
				end if ;
				data <= "111" ;

		end case ;
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
