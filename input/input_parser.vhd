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
			 clock	  : in  std_logic ;
			 jump     : out std_logic ;
			 reset    : out std_logic ;
			 pause    : out std_logic ;
			 gravity  : out std_logic_vector(7 downto 0)
		 ) ;
end input_parser ;

architecture behavior of input_parser is

begin

	process(clock)
		variable tmp_key	: std_logic_vector(3 downto 0) ;
		variable tmp_sw		: std_logic_vector(9 downto 0) ;
	begin
		if rising_edge(clock) then
			jump	<= tmp_key(3) ;
			reset	<= tmp_key(2) ;
			pause	<= tmp_sw(9) ;
			gravity <= tmp_sw(7 downto 0) ;

			tmp_key := key ;
			tmp_sw  := sw ;
		end if ;
	end process ;
end behavior ;
