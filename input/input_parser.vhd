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
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all ;

entity input_parser is
	generic (
				V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 key      : in  std_logic_vector(3 downto 0) ;
			 sw       : in  std_logic_vector(9 downto 0) ;
			 clock	  : in  std_logic ;
			 jump     : out std_logic ;
			 reset    : out std_logic ;
			 pause    : out std_logic ;
			 gravity  : out integer range 0 to V_RES - 1 
		 ) ;
end input_parser ;

architecture behavior of input_parser is

begin
	-- Syncronize input with circuit clock changes to minimize hazards.
	process(clock)
		variable tmp_key	: std_logic_vector(3 downto 0) ;
		variable tmp_sw		: std_logic_vector(9 downto 0) ;
	begin
		if rising_edge(clock) then
			-- Update output.
			jump	<= not tmp_key(3) ;
			reset	<= not tmp_key(2) ;
			pause	<= tmp_sw(9) ;
			gravity <= to_integer(signed(tmp_sw(7 downto 0))) ;

			-- Update local buffer.
			tmp_key := key ;
			tmp_sw  := sw ;
		end if ;
	end process ;
end behavior ;
