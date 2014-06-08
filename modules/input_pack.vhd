-- file: modules/input_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package input is
	-- Parses input signals from switches and keys and attributes the adequate
	-- values to the internal signals.
	component input_parser
		port (
				 key      : in  std_logic_vector(3 downto 0) ;
				 sw       : in  std_logic_vector(9 downto 0) ;
				 jump     : out std_logic ;
				 reset    : out std_logic ;
				 gravity  : out std_logic_vector(7 downto 0)
			 ) ;
	end component ;

	-- Divides 27MHz clock into adequate clock value
	component clock_divider
		port (
				 clock_27 : in  std_logic ;
				 clock    : out std_logic
			 ) ;
	end component ;
end input ;
