-- file: output/ledcon.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Leds and 7seg display controller -- converts internal signals to led
-- outputs.

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.numeric_std.all ;

library module ;
use module.output.hex2disp ;

entity ledcon is
	port (
			 obst_count : in  integer range 0 to 255 ;
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
end ledcon ;

architecture behavior of ledcon is
	signal val : std_logic_vector(7 downto 0) ;
begin
	val <= std_logic_vector(to_unsigned(obst_count,8)) ;

	disp0: hex2disp port map (val(3 downto 0), hex0) ;
	disp1: hex2disp port map (val(7 downto 4), hex1) ;
	hex2 <= (others => '1') ;
	hex3 <= (others => '1') ;
end behavior ;
