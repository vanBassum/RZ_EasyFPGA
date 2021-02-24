library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;



entity SSquare is
	port(
		clk			: in std_logic;
		xPos			: in integer;
		yPos			: in integer;
		w				: in integer;
		h				: in integer;
		disp_x		: in integer;
		disp_y		: in integer;
		q				: out std_logic);
end entity;


architecture struct of SSquare is
begin
	process(clk)
	begin
	
		if (xPos <= disp_x) and (disp_x <= (xPos + w)) and (yPos <= disp_y) and (disp_y <= (yPos + h))
		then
			q <= '1';
		else
			q <= '0';
		end if;
	
	end process;
end;

















