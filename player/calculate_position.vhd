-- file: player/calculate_position.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current position based on internal register for position and
-- current speed value.

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;

library modules;
use modules.nbit_register_pack.all ;

entity calculate_position is
	port (
			 speed    : in  std_logic_vector(7 downto 0) ;
			 position : out std_logic_vector(7 downto 0) ;
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic
		 ) ;
end calculate_position ;


architecture behavior of calculate_position is
  signal new_y, old_y: std_logic_vector(7 downto 0);
begin  
  position_reg: nbit_register
    port map ( x     => new_y,
               y     => old_y,
               ld    => '1',
               clr   => '0',
               clk   => clock
             ) ;
  process (clock, reset)
  begin 
   if reset = '1' then 
     new_y <= "01111111" ;
   elsif enable = '1' and rising_edge(clock) then
     new_y <= (old_y + speed) ;      
   end if;          
  end process;
 position <= old_y;
end behavior;