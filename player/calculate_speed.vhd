-- file: player/calculate_speed.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Calculate current speed based on internal register for speed, gravity value
-- and jump signal.

library ieee ;
use ieee.std_logic_1164.all ;
use ieee.std_logic_unsigned.all ;
use ieee.numeric_std.all;

library modules;
use modules.nbit_register_pack.all ;

entity calculate_speed is
    generic (
			 V_RES  : natural := 96    -- Vertical Resolution
			) ;
	port (
			 jump    : in  std_logic ;
			 gravity : in  std_logic_vector(3 downto 0) ;
			 speed   : out integer range - V_RES to V_RES - 1  ;
			 clock   : in  std_logic ;
			 enable  : in  std_logic ;
			 reset   : in  std_logic
		 ) ;
end calculate_speed ;

architecture behavior of calculate_speed is
  signal new_sp, old_sp: std_logic_vector(7 downto 0) ;
  signal inc : std_logic_vector(3 downto 0) := "0001";
  signal jump_aux : std_logic ;
begin  
  process (clock)
  begin
   if enable = '1' and rising_edge(clock) then
      new_sp <= (old_sp + inc) ;
      end if ;
  end process ;
 
  process (jump)
  begin
     if jump_aux = '0' then -- isso tá errado pq se o cara ficar clicando ele vai ficar parado  
      inc <= gravity ;
     elsif rising_edge(jump) then 
      inc <= "0001" ;
     end if;
   end process ;
   
   speed_reg: nbit_register
    port map ( x     => new_sp ,
               y     => old_sp ,
               ld    => '1' ,
               clr   => reset ,
               clk   => clock
             ) ;   
   speed <= to_integer(signed(old_sp));
end behavior;