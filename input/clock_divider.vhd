-- file: input/clock_divider.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Divides 27MHz clock into adequate clock value

library ieee ;
use ieee.std_logic_1164.all ;

entity clock_divider is
	generic (
				RATE : natural := 270000
			) ;
	port (
			 clk_in  : in  std_logic ;
			 clk_out : out std_logic ;

			 enable  : in  std_logic ;
			 reset   : in  std_logic
		 ) ;
end clock_divider ;

architecture behavior of clock_divider is
	signal count: integer range 0 to RATE - 1;
begin
	-- Counter for rate
	process(clk_in, reset)
	begin
		if reset = '1' then
			count <= 0 ;
		elsif rising_edge(clk_in) and enable = '1' then
			if count = RATE - 1 then
				count <= 0 ;
			else
				count <= count + 1 ;
			end if ;
		end if ;
	end process ;

	-- Sets clk_out
	clk_out <= '1' when count = (RATE - 1) else '0' ;
end behavior ;
