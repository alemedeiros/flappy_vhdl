-- file: obst/obst_pack.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.

library ieee ;
use ieee.std_logic_1164.all ;

package obstacles is

	-- Set of 2^n registers to save the obstacles positions (2B for each
	-- obstacle) with register shifts (value shifts from one register to another,
	-- discarding obstacle 0).
	component obst_regbank
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
	end component ;

	-- Update and generate new obstacles for game.
	component update_obstacles
		port (
				 rand         : in  std_logic_vector(7 downto 0) ;
				 new_obst     : in  std_logic ;
				 obst_count   : out std_logic_vector(7 downto 0) ;
				 obst_rem     : out std_logic ;
				 clock        : in  std_logic ;
				 enable       : in  std_logic ;
				 reset        : in  std_logic
			 ) ;
	end component ;

	-- random number module.
	component generate_random
		port (
				 rand   : out std_logic_vector(7 downto 0) ;
				 clock  : in  std_logic
			 ) ;
	end component ;
end obstacles ;
