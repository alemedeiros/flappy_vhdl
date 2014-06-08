-- file: input/input_parser.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Parses input signals from switches and keys and attributes the adequate
-- values to the internal signals.

library ieee ;
use ieee.std_logic_1164.all ;

entity input_parser is
	port (
			 key      : in  std_logic_vector(3 downto 0) ;
			 sw       : in  std_logic_vector(9 downto 0) ;
			 jump     : out std_logic ;
			 reset    : out std_logic ;
			 gravity  : out std_logic_vector(7 downto 0)
		 ) ;
end input_parser ;
