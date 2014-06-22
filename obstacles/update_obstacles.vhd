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
use modules.obstacles_pack.all;

entity update_obstacles is
    generic (
				H_RES  : natural := 128 ;  -- Horizontal Resolution
				V_RES  : natural := 96 ;   -- Vertical Resolution
				N_OBST : natural := 4      -- Number of obstacles
			) ;
	port (
			 new_obst     : in  std_logic ;
			 obst_count   : buffer integer range 0 to 255 ;
			 obst_rem     : out std_logic ;
			 clock        : in  std_logic ;
			 enable       : in  std_logic ;
			 reset        : in  std_logic
		 ) ;
end update_obstacles ;

architecture behavior of update_obstacles is
  signal aux_low, aux_high : integer range 0 to V_RES/2 - 1 ;
  signal low, high     : integer range 0 to V_RES - 1 ;
  signal pos      : integer range 0 to H_RES / N_OBST - 1 ;
begin

 process (new_obst)
 begin
   if reset = '1' then
    obst_count <= 0 ;
   elsif enable = '1' and rising_edge(new_obst) then 
    obst_count <= obst_count + 1 ;
   end if; 
 end process ;

 qlow1: generate_random
	 generic map (V_RES => V_RES)
     port map (clock => new_obst,
			  rand  => aux_low) ;
			  
 qhigh1: generate_random
	 generic map (V_RES => V_RES)
     port map (clock => new_obst,
			  rand  => aux_high) ;


qbanco: obst_regbank
  generic map (H_RES => H_RES, 
			   V_RES => V_RES,
			   N_OBST => N_OBST
			)
  port map (
			 in_low   => aux_low,
			 in_high  => aux_high,
			 up_clk   => new_obst,

			 id 	  => 0,
			 low      => low,
			 high     => high,
			 pos      => pos,

			 clock    => clock,
			 enable   => enable,
			 reset    => reset,
			 obst_rem => obst_rem
		 ) ;
end behavior; 
