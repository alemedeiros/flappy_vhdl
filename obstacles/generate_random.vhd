-- file: obstacles/generate_random.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Random number module.

library ieee ;
use ieee.std_logic_1164.all ;

entity generate_random is
	port (
			 rand   : out std_logic_vector(7 downto 0) ;
			 clock  : in  std_logic
		 ) ;
end generate_random ;
