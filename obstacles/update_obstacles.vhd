-- file: obstacles/update_obstacles.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Update and generate new obstacles for game.

library ieee ;
use ieee.std_logic_1164.all ;

library modules;
use modules.obstacles.all;

entity update_obstacles is
    generic (
				H_RES  : natural := 128 ;  -- Horizontal Resolution
				V_RES  : natural := 96 ;   -- Vertical Resolution
				N_OBST : natural := 4      -- Number of obstacles
			) ;
	port (
			 new_obst     : in  std_logic ;
			 obst_count   : buffer integer range -2 to 255 ;
			 low_obst     : out integer range 0 to V_RES - 1 ;
			 high_obst    : out integer range 0 to V_RES - 1 ;
			 obst_rem     : out std_logic ;
			 clock        : in  std_logic ;
			 enable       : in  std_logic ;
			 reset        : in  std_logic
		 ) ;
end update_obstacles ;

architecture behavior of update_obstacles is
  signal pos      : integer range 0 to H_RES / N_OBST - 1 ;
  signal low_aux  : integer range 0 to V_RES - 1 ;
begin

 process (new_obst)
 begin
   if reset = '1' then
    obst_count <= -2 ;
   elsif enable = '1' and rising_edge(new_obst) then 
    obst_count <= obst_count + 1 ;
   end if; 
 end process ;

 qlow1: generate_random
	 generic map (V_RES => V_RES)
     port map (seed => "10011",
			  clock => new_obst,
			  rand  => low_aux) ;
			  
  high_obst <= V_RES - low_aux - 35 ;

  low_obst <= low_aux ;
  obst_rem <= new_obst ;
end behavior; 
