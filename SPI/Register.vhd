library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;


entity Reg is
	port(	clk			: in std_logic;
			ld 			: in std_logic;
			oe				: in std_logic;
			rst			: in std_logic;
			dout			: out std_logic_vector(7 downto 0);
			databus		: inout std_logic_vector(7 downto 0));
			
end entity;



architecture struct of Reg is 
	signal a 			: std_logic_vector(7 downto 0) := "10101010";
	
begin
	
	
	process(clk, rst)
	begin
		if rst = '1' then
			a <= "00000000";
		elsif rising_edge(clk) then
			if ld = '1' then
				a <= databus;
			end if;
		end if;
	end process;
	
	
	process(oe, databus)	
	begin
		if oe = '0' then
			databus <= "ZZZZZZZZ";
		else
			databus <= a;
		end if;
	end process;
	
	dout <= a;
	
end;





