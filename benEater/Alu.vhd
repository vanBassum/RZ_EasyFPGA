library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use IEEE.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity Alu is
	port(	sub			: in std_logic;
			oe				: in std_logic;
			co				: out std_logic;	--Carry over
			zo				: out std_logic;	--IsZero
			databus		: inout std_logic_vector(7 downto 0);
			dataA			: in std_logic_vector(7 downto 0);
			dataB			: in std_logic_vector(7 downto 0));
			
end entity;



architecture struct of Alu is 
	signal result 		: std_logic_vector(8 downto 0);
	signal a 			: std_logic_vector(8 downto 0);
	signal b 			: std_logic_vector(8 downto 0);
begin
	
	
	process(oe, dataA, dataB, sub)
	begin

		if oe = '0' then
			databus <= "ZZZZZZZZ";
		else
			if sub = '0' then
				result <= a + b;
			else
				result <= a - b;
			end if;
		
			databus <= result(7 downto 0);
		end if;
		
		if (result(7 downto 0) = "00000000") then
			zo <= '1';
		else
			zo <= '0';
		end if;
	
		co <= result(8);
	end process;
	

		
	a(7 downto 0) <= dataA;
	b(7 downto 0) <= datab;
		
end;






