library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;


entity RegIn is
	port(	clk			: in std_logic;
			data 			: in std_logic;
			rst			: in std_logic;
			dout			: out std_logic_vector(7 downto 0));
			
end entity;



architecture struct of RegIn is 
	signal a 			: std_logic_vector(7 downto 0) := "10101010";
	
begin
	process(clk, rst)
	begin
		if rst = '0' then
			if rising_edge(clk) then
				a(7) <= a(6);
				a(6) <= a(5);
				a(5) <= a(4);
				a(4) <= a(3);
				a(3) <= a(2);
				a(2) <= a(1);
				a(1) <= a(0);
				a(0) <= data;
			end if;
		end if;
	end process;
	dout <= a;
end;





