library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;


entity DFlipFlop is
	port(	clk 			: in std_logic;
			D				: in std_logic_vector(7 downto 0);
			Q				: out std_logic_vector(7 downto 0));
			
end entity;



architecture struct of DFlipFlop is begin
	
	process(clk)
	begin
		if rising_edge(clk) then
			Q<=D;
			
		end if;
	end process;
	
end;





