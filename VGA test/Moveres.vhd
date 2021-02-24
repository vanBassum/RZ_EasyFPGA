library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity Movers is
GENERIC(
	x 		: integer := 17;
	y 		: integer := 17);
		
port(
	clk			: in std_logic;
	disp_x		: in integer;
	disp_y		: in integer;
	q				: out std_logic;
	freeze		: in std_logic);
end entity;


architecture struct of Movers is
	signal q1		: std_LOGIC;
	signal q2		: std_LOGIC;
	signal q3		: std_LOGIC;
	signal q4		: std_LOGIC;
	signal q5		: std_LOGIC;
	signal clkk		: std_logic;
begin

	clkk <= clk AND freeze;



	mov1 : entity work.Mover
	generic map(
		speed => 16,
		x => x,
		y => y
	)
	port map (
		clk	 => clkk,
		disp_x => disp_x,
		disp_y => disp_y,
		q		 => q1	
	);
	
	mov2 : entity work.Mover
	generic map(
		speed => 17,
		x => x,
		y => y
	)
	port map (
		clk	 => clkk,
		disp_x => disp_x,
		disp_y => disp_y,
		q		 => q2	
	);
	
	mov3 : entity work.Mover
	generic map(
		speed => 18,
		x => x,
		y => y
	)
	port map (
		clk	 => clkk,
		disp_x => disp_x,
		disp_y => disp_y,
		q		 => q3	
	);
	
	mov4 : entity work.Mover
	generic map(
		speed => 19,
		x => x,
		y => y
	)
	port map (
		clk	 => clkk,
		disp_x => disp_x,
		disp_y => disp_y,
		q		 => q4	
	);
	
	
	mov5 : entity work.Mover
	generic map(
		speed => 15,
		x => x,
		y => y
	)
	port map (
		clk	 => clkk,
		disp_x => disp_x,
		disp_y => disp_y,
		q		 => q5	
	);
	

	q <= q1 OR q2 OR q3 OR q5;
	
end;

































