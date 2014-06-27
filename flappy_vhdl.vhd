-- file: flappy_vhdl.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Developed for Altera's Cyclone II: EP2C20F484C7.
--
-- Top-Level Entity for the project.

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all;

library modules ;
use modules.colision.all ;
use modules.control.all ;
use modules.input.all ;
use modules.obstacles.all ;
use modules.output.all ;
use modules.player.all ;

entity flappy_vhdl is
	generic (
				V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 -- Input keys
			 key      : in  std_logic_vector(3 downto 0) ;
			 sw       : in  std_logic_vector(9 downto 0) ;
			 -- LEDs output
			 hex0     : out std_logic_vector(0 to 6) ;
			 hex1     : out std_logic_vector(0 to 6) ;
			 hex2     : out std_logic_vector(0 to 6) ;
			 hex3     : out std_logic_vector(0 to 6) ;
			 ledr     : out std_logic_vector(9 downto 0) ;
			 ledg     : out std_logic_vector(7 downto 0) ;
			 -- VGA output
			 vga_r	  : out std_logic_vector(3 downto 0) ;
			 vga_g	  : out std_logic_vector(3 downto 0) ;
			 vga_b	  : out std_logic_vector(3 downto 0) ;
			 vga_hs	  : out std_logic ;
			 vga_vs	  : out std_logic ;
			 -- Clock
			 clock_27 : in  std_logic
		 ) ;
end flappy_vhdl ;

architecture behavior of flappy_vhdl is
	signal timer : std_logic ;
	signal timer2 : std_logic ;
	signal draw_en : std_logic ;

	signal pos  : integer range 31 downto 0;
	signal play : integer range 0 to 95 ;
	signal gravity : integer range 0 to 95 ;

	signal id   : integer range 0 to 3 ;
	signal low  : integer range 0 to 95 ;
	signal high : integer range 0 to 95 ;

	signal n_low  : integer range 0 to 95 ;
	signal n_high : integer range 0 to 95 ;
	signal first_low  : integer range 0 to 95 ;
	signal first_high : integer range 0 to 95 ;

	signal game_over : std_logic ;
	signal reset     : std_logic ;
	signal pause     : std_logic ;
	signal jump      : std_logic ;
	signal obst_rem  : std_logic ;
	signal new_obst  : std_logic ;
	signal int_reset : std_logic ;

	-- Enable signals for each module.
	signal ctl_calculate_speed    : std_logic ;
	signal ctl_calculate_position : std_logic ;
	signal ctl_obst_regbank       : std_logic ;
	signal ctl_update_obstacles   : std_logic ;
	signal ctl_colision_detection : std_logic ;
	signal ctl_draw_frame         : std_logic ;
	signal ctl_ledcon             : std_logic ;

	signal aux_speed    : integer range -V_RES to V_RES - 1 ;
	signal aux_position : integer range 0 to V_RES - 1 ;
	
	signal obst_count : integer range 0 to 255 ;
	
begin
	gc: game_control
	port map (
				 game_over  => game_over,
				 reset      => reset,
				 pause      => pause,
				 jump       => jump,
				 clock      => clock_27,
				 obst_rem   => obst_rem,
				 new_obst   => new_obst,
				 timer      => timer,

				 calculate_speed    => ctl_calculate_speed,
				 calculate_position => ctl_calculate_position,
				 obst_regbank       => ctl_obst_regbank,
				 update_obstacles   => ctl_update_obstacles,
				 colision_detection => ctl_colision_detection,
				 draw_frame         => ctl_draw_frame,
				 ledcon             => ctl_ledcon,
				 internal_reset     => int_reset
			 ) ;

----input: input_parser
----port map (
----			 key      => key,
----			 sw       => sw,
----			 jump     => jump,
----			 reset    => reset,
----			 pause    => pause,
----			 gravity  => gravity
----		 ) ;

	colisi: colision_detection
	port map (
				 player     => play,
				 position   => pos,
				 obst_low   => first_low,
				 obst_high  => first_high,
				 game_over  => game_over,
				 clock      => clock_27,
				 enable     => ctl_colision_detection,
				 reset      => int_reset
			 ) ;

	regbank: obst_regbank
	port map (
				 in_low  => n_low,
				 in_high => n_high,
				 up_clk  => timer,

				 id      => id,
				 low     => low,
				 high    => high,
				 pos     => pos,
				 f_low   => first_low,
				 f_high  => first_high,

				 clock   => clock_27,
				 enable  => ctl_obst_regbank,
				 reset   => int_reset,
				 obst_rem => draw_en
			 ) ;

	output: draw_frame
	port map (
				 player     => play,
				 obst_low   => low,
				 obst_high  => high,
				 obst_pos   => pos,
				 obst_id    => id,
				 red        => vga_r,
				 green      => vga_g,
				 blue       => vga_b,
				 hsync      => vga_hs,
				 vsync      => vga_vs,
				 clock      => clock_27,
				 enable     => ctl_draw_frame,
				 reset      => int_reset
			 ) ;

	-- Simple timer
	div: clock_divider
	generic map ( RATE => 2000000 )
	port map (
				 clk_in  => clock_27,
				 clk_out => timer,
				 enable  => '1',
				 reset   => int_reset
			 ) ;

	-- DEBUG: Gradually changes size of obstacles
	iup_obs: update_obstacles
	port map  (
			 new_obst     => draw_en ,
			 obst_count   => obst_count ,
			 low_obst     => n_low ,
			 high_obst    => n_high ,
			 obst_rem     => open ,
			 clock        => timer ,
			 enable       => ctl_update_obstacles ,
			 reset        => int_reset
		 ) ;
	
	div2: clock_divider
	generic map ( RATE => 10000000 )
	port map (
				 clk_in  => clock_27,
				 clk_out => timer2,
				 enable  => '1',
				 reset   => int_reset
			 ) ;

	-- calculate position	
	cp: calculate_position
	generic map ( V_RES => V_RES )
	port map (
				 jump     =>  jump,
				 gravity  =>  2,
				 position =>  play ,
				 clock    =>  timer2 ,
				 enable   =>  ctl_calculate_position ,
				 reset    =>  int_reset
			 ) ;

	-- leds controller
	lcon: ledcon
	port map (
				 obst_count => obst_count,
				 pause      => pause,
				 game_over  => game_over,
				 hex0       => hex0,
				 hex1       => hex1,
				 hex2       => hex2,
				 hex3       => hex3,
				 ledr       => open,
				 ledg       => open,
				 clock      => clock_27,
				 enable     => '1',
				 reset      => reset
			 ) ;

	-- DEBUG
	--game_over <= sw(9) ;
	reset     <= not key(1) ;
	pause     <= sw(7) ;
	jump      <= not key(2) ;
	obst_rem  <= sw(6) ;
	new_obst  <= sw(5) ;

	ledg(5) <= game_over ;
	ledg(3 downto 0) <= key ;
	ledr <= sw ;
end behavior ;
