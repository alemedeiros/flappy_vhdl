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
    generic (
				V_RES  : integer := 96    -- Vertical Resolution
			) ;
	port (
			 rand   : out integer range 0 to (V_RES/2 - 1) ;
			 clock  : in  std_logic
		 ) ;
end generate_random ;

architecture behavior of generate_random is
begin
   process (clock)
      begin
		if rising_edge(clock) then
		 rand <= V_RES/2 - 2;
		end if ;
    end process ; 
end behavior ;