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
			 f_low    : out integer range 0 to V_RES - 1 ;
			 f_high   : out integer range 0 to V_RES - 1 ;

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

	signal updating : std_logic ;

	signal tmp_pos      : integer range 0 to H_RES / N_OBST - 1 := H_RES / N_OBST - 1 ;
	signal tmp_obst_rem : std_logic ;
begin
	-- Reading values process
	process(clock)
	begin
		if rising_edge(clock) and updating = '0' then
			low      <= obst_low(id) ;
			high     <= obst_high(id) ;
			f_low    <= obst_low(0) ;
			f_high   <= obst_high(0) ;
			pos      <= tmp_pos ;
			if tmp_pos = 0 then
				obst_rem <= '1' ;
			else
				obst_rem <= '0' ;
			end if ;
		end if ;
	end process ;


	-- Update obstacle values
	process(up_clk, reset, enable)
	begin
		if reset = '1' then
			updating <= '1' ;
			-- Reset
			tmp_pos <= 0 ; -- H_RES / N_OBST - 1 ;
			for i in 0 to N_OBST - 1 loop
				obst_low(i)  <= 0 ;
				obst_high(i) <= 0 ;
			end loop ;
			updating <= '0' ;
		elsif rising_edge(up_clk) and enable = '1' then
			updating <= '1' ;

			if tmp_pos = 0 then
				-- Shift obstacles and read next obstacle
				tmp_obst_rem <= '1' ;
				tmp_pos <= H_RES / N_OBST - 1 ;

				for i in 1 to N_OBST - 1 loop
					obst_low(i-1)  <= obst_low(i) ;
					obst_high(i-1) <= obst_high(i) ;
				end loop ;

				obst_low(N_OBST - 1)  <= in_low ;
				obst_high(N_OBST - 1) <= in_high ;
			else
				tmp_obst_rem <= '0' ;
				tmp_pos <= tmp_pos - 1 ;
			end if ;
			updating <= '0' ;
		end if ;
	end process ;
end behavior ;
