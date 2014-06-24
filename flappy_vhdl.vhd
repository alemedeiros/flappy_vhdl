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

library modules ;
use modules.colision.all ;
use modules.control.all ;
use modules.input.all ;
use modules.obstacles.all ;
use modules.output.all ;
use modules.player.all ;

entity flappy_vhdl is
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
	signal draw_en : std_logic ;

	signal pos  : integer range 31 downto 0;
	signal play : integer range 0 to 95 ;

	signal id   : integer range 0 to 3 ;
	signal low  : integer range 0 to 95 ;
	signal high : integer range 0 to 95 ;

	signal n_low  : integer range 0 to 95 ;
	signal n_high : integer range 0 to 95 ;
begin
	regbank: obst_regbank
	port map (
				 in_low  => n_low,
				 in_high => n_high,
				 up_clk  => timer,

				 id      => id,
				 low     => low,
				 high    => high,
				 pos     => pos,

				 clock   => clock_27,
				 enable  => '1',
				 reset   => not key(2),
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
				 enable     => not draw_en,
				 reset      => not key(1)
			 ) ;

	-- Simple timer
	div: clock_divider
	generic map ( RATE => 2000000 )
	port map (
				 clk_in  => clock_27,
				 clk_out => timer,
				 enable  => '1',
				 reset   => '0'
			 ) ;

	-- DEBUG: Change player value
	process(timer)
		variable tmp : integer range 0 to 95 := 47 ;
		variable dir : std_logic := '0' ;
	begin
		if rising_edge(timer) then
			if dir = '0' then
				tmp := tmp + 1 ;
			else
				tmp := tmp - 1 ;
			end if ;
		end if ;

		if tmp = 30 then
			dir := '0' ;
		elsif tmp = 65 then
			dir := '1' ;
		end if ;

		play <= tmp ;
	end process ;

	-- DEBUG: Gradually changes size of obstacles
	process(timer)
		variable tmp_low  : integer range 0 to 95 ;
		variable tmp_high : integer range 0 to 95 := 40;
		variable dir      : std_logic := '0' ;
	begin
		if rising_edge(timer) then
			if dir = '0' then
				tmp_low  := tmp_low + 1 ;
				tmp_high  := tmp_high - 1 ;
			else
				tmp_low  := tmp_low - 1 ;
				tmp_high  := tmp_high + 1 ;
			end if ;
		end if ;

		if tmp_high = 0 then
			dir := '1' ;
		elsif tmp_high = 40 then
			dir := '0' ;
		end if ;

		n_low  <= tmp_low ;
		n_high <= tmp_high ;
	end process ;

	-- DEBUG
	ledg(5) <= draw_en ;
	ledg(3 downto 0) <= key ;
	ledr <= sw ;
end behavior ;
