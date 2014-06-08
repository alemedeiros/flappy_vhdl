-- file: output/output_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package output is
	-- Draw game images from current game state (player position and current
	-- obstacles) using vgacon.
	component draw_frame
		port (
				 position   : in  std_logic_vector(7 downto 0) ;
				 obst_low   : in  std_logic_vector(7 downto 0) ;
				 obst_high  : in  std_logic_vector(7 downto 0) ;
				 obst_id    : out std_logic_vector(2 downto 0) ;
				 clock      : in  std_logic ;
				 enable     : in  std_logic ;
				 reset      : in  std_logic
			 ) ;
	end component ;

	-- Leds and 7seg display controller -- converts internal signals to led
	-- outputs.
	component ledcon
		port (
				 obst_count : in  std_logic_vector(7 downto 0) ;
				 pause      : in  std_logic ;
				 game_over  : in  std_logic ;
				 hex0       : out std_logic_vector(0 to 6) ;
				 hex1       : out std_logic_vector(0 to 6) ;
				 hex2       : out std_logic_vector(0 to 6) ;
				 hex3       : out std_logic_vector(0 to 6) ;
				 ledr       : out std_logic_vector(0 to 9) ;
				 ledg       : out std_logic_vector(0 to 7) ;
				 clock      : in  std_logic ;
				 enable     : in  std_logic ;
				 reset      : in  std_logic
			 ) ;
	end component ;

	-- VGA controller
	component vgacon
		generic (
					--  When changing this, remember to keep 4:3 aspect ratio
					--  Must also keep in mind that our native resolution is 640x480, and
					--  you can't cross these bounds (although you will seldom have enough
					--  on-chip memory to instantiate this module with higher res).
					NUM_HORZ_PIXELS : natural := 128 ;  -- Number of horizontal pixels
					NUM_VERT_PIXELS : natural := 96     -- Number of vertical pixels
				) ;
		port (
				 clk27M       : in  std_logic ;
				 rstn         : in  std_logic ;
				 write_enable : in  std_logic ;
				 write_clk    : in  std_logic ;
				 write_addr   : in  integer range 0 to 
				 NUM_HORZ_PIXELS * NUM_VERT_PIXELS - 1 ;
				 data_in      : in  std_logic_vector(2 downto 0) ;
				 vga_clk      : buffer std_logic ;       -- Ideally 25.175 MHz
				 red          : out std_logic_vector(3 downto 0) ;
				 green        : out std_logic_vector(3 downto 0) ;
				 blue         : out std_logic_vector(3 downto 0) ;
				 hsync        : out std_logic ;
				 vsync        : out std_logic
			 ) ;
	end component ;
end output ;
