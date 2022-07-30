library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;


entity Latch is
	port(	load 			: in std_logic;
			clk			: in std_logic;
			D				: in std_logic_vector(7 downto 0);
			Q				: out std_logic_vector(7 downto 0));
			
end entity;



architecture struct of Latch is begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			if load = '1' then
				Q<=D;
			end if;
		end if;
	end process;
end;





