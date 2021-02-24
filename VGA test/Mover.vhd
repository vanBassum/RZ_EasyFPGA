library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity Mover is
GENERIC(
	speed : integer := 17;
	x 		: integer := 17;
	y 		: integer := 17);
	
port(
	clk			: in std_logic;
	disp_x		: in integer;
	disp_y		: in integer;
	q				: out std_logic);
end entity;


architecture struct of Mover is
	signal xDir				: std_logic := '1';
	signal yDir				: std_logic := '1';
	signal xPos				: integer := x;
	signal yPos				: integer := y;
	signal w					: integer := 10;
	signal h					: integer := 10;
	
	signal step				: integer := 1;
	
begin

	process(disp_x, disp_y)
	begin
		if (xPos <= disp_x) and (disp_x <= (xPos + w)) and (yPos <= disp_y) and (disp_y <= (yPos + h))
		then
			q <= '1';
		else
			q <= '0';
		end if; 
	end process;




	process(clk)
	begin
		if rising_edge(clk) then
		
			if xDir = '1' then
				xPos <= xPos + step;
			else
				xPos <= xPos - step;
			end if;
			
			
			if yDir = '1' then
				yPos <= yPos + step;
			else
				yPos <= yPos - step;
			end if;
			
		end if;
		
	
	
		if xPos <= 0 then
			xDir <= '1';
		elsif (xPos + w) >= 800 then
			xDir <= '0';
		end if;
		
		if yPos <= 0 then
			yDir <= '1';
		elsif (yPos + h) >= 600 then
			yDir <= '0';
		end if;
			
	end process;
end;

































