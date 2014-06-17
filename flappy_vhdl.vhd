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
			 ledr     : out std_logic_vector(0 to 9) ;
			 ledg     : out std_logic_vector(0 to 7) ;
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

begin
	output: draw_frame
	port map (
				 position   => "10101010",
				 obst_low   => "00001111",
				 obst_high  => "11110000",
				 obst_id    => open,
				 red        => vga_r,
				 green      => vga_g,
				 blue       => vga_b,
				 hsync      => vga_hs,
				 vsync      => vga_vs,
				 clock      => clock_27,
				 enable     => '1',

				 -- DEBUG
				 hex        => hex0,
				 st         => sw(0),

				 reset      => key(1)
			 ) ;
end behavior ;
