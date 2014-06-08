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

entity ledcon is
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
end ledcon ;
