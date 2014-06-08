-- file: obstacles/obst_regbank.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Set of 2^n registers to save the obstacles positions (2B for each
-- obstacle) with register shifts (value shifts from one register to another,
-- discarding obstacle 0).

library ieee ;
use ieee.std_logic_1164.all ;

entity obst_regbank is
	generic ( n : integer := 2 ) ;
	port (
			 wren     : in  std_logic ;
			 id       : in  std_logic_vector(n-1 downto 0) ;
			 shift    : in  std_logic ;
			 low      : out std_logic_vector(7 downto 0) ;
			 high     : out std_logic_vector(7 downto 0) ;
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic
		 ) ;
end obst_regbank ;
