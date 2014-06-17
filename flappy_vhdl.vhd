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

	signal pos  : integer range 31 downto 0;
	signal play : integer range 0 to 95 ;

	signal id   : integer range 0 to 3 ;
	signal low  : integer range 0 to 95 ;
	signal high : integer range 0 to 95 ;
begin
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
				 enable     => '1',
				 reset      => not key(1)
			 ) ;

	-- Simple 1 second timer
	process(clock_27)
		variable count : integer range 0 to 2000000 := 0 ;
	begin
		if rising_edge(clock_27) then
			count := count + 1 ;
		end if ;
		
		if count = 0 then
			timer <= '1' ;
		else
			timer <= '0' ;
		end if ;
	end process ;

	-- Change obst_pos value
	process(timer)
		variable tmp : integer range 31 downto 0 := 31 ;
	begin
		if rising_edge(timer) then
			tmp := tmp - 1 ;
		end if ;

		pos <= tmp ;
	end process ;

	-- Change player value
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

	-- Changes obstacles values
	process(id)
	begin
		case id is
			when 0 =>
				low <= 20 ;
				high <= 20 ;
			when 1 =>
				low <= 40 ;
				high <= 40 ;
			when 2 =>
				low <= 40 ;
				high <= 30 ;
			when 3 =>
				low <= 30 ;
				high <= 40 ;
		end case ;
	end process ;

	ledg(3 downto 0) <= key ;
	ledr <= sw ;
end behavior ;
