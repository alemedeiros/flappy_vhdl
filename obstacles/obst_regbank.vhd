-- file: obstacles/obst_regbank.vhd
-- authors: Alexandre Medeiros and Gabriel Lopes
--
-- A Flappy bird implementation in VHDL for a Digital Circuits course at
-- Unicamp.
--
-- Set of n registers to save the obstacles positions (2 integers for each
-- obstacle), when an obstacle reaches the horizontal position 0, it is
-- automatically discarded and a new one is read from in_{low,high}.

library ieee ;
use ieee.std_logic_1164.all ;

entity obst_regbank is
	generic (
				H_RES  : natural := 128 ;  -- Horizontal Resolution
				V_RES  : natural := 96 ;   -- Vertical Resolution
				N_OBST : natural := 4      -- Number of obstacles
			) ;
	port (
			 -- New obstacles input
			 in_low   : in  integer range 0 to V_RES - 1 ;
			 in_high  : in  integer range 0 to V_RES - 1 ;
			 up_clk   : in  std_logic ; -- Update clock

			 -- Read current values
			 id       : in  integer range 0 to N_OBST - 1 ;
			 low      : out integer range 0 to V_RES - 1 ;
			 high     : out integer range 0 to V_RES - 1 ;
			 pos      : out integer range 0 to H_RES / N_OBST - 1 ;

			 -- Control signal
			 clock    : in  std_logic ;
			 enable   : in  std_logic ;
			 reset    : in  std_logic ;
			 obst_rem : out std_logic
		 ) ;
end obst_regbank ;

architecture behavior of obst_regbank is
	-- Declare a array type for the obstacles
	type obst_t is array (0 to N_OBST - 1) of integer range 0 to V_RES - 1 ;

	-- Obstacles array
	signal obst_low  : obst_t ;
	signal obst_high : obst_t ;
begin
	-- Reading values process
	process(clock, enable)
	begin
		if enable = '1' and rising_edge(clock) then
			low  <= obst_low(id) ;
			high <= obst_high(id) ;
		end if ;
	end process ;

	-- Update obstacle values
	process(up_clk, reset, enable)
		variable tmp_pos : integer range 0 to H_RES / N_OBST - 1 := H_RES / N_OBST - 1 ;
		variable tmp_obst_rem: std_logic := '0';
	begin
		if reset = '1' then
			-- Reset
			tmp_pos := H_RES / N_OBST - 1 ;
			for i in 0 to N_OBST - 1 loop
				obst_low(i)  <= 0 ;
				obst_high(i) <= 0 ;
			end loop ;
		elsif enable = '1' and rising_edge(up_clk) then
			-- Shift obstacles and read next obstacle
			if tmp_pos = 0 then
				for i in 1 to N_OBST - 1 loop
					obst_low(i-1)  <= obst_low(i) ;
					obst_high(i-1) <= obst_high(i) ;
				end loop ;

				obst_low(N_OBST - 1)  <= in_low ;
				obst_high(N_OBST - 1) <= in_high ;
				tmp_obst_rem := '1' ;
			end if ;

			tmp_pos := tmp_pos - 1 ;
		end if ;
		pos <= tmp_pos ;
		obst_rem <= tmp_obst_rem ;
	end process ;
end behavior ;
