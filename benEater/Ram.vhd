library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity Ram is
	port(	
			clk		: in STD_LOGIC;                             
			wr			: in STD_LOGIC;                             
			rd			: in  STD_LOGIC;    
			addr		: in STD_LOGIC_VECTOR(7 DOWNTO 0);  
			databus	: inout STD_LOGIC_VECTOR(7 DOWNTO 0)); 
			
end entity;



architecture struct of Ram is 
	TYPE memory IS ARRAY(31 DOWNTO 0) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal ram 			: memory := (
	
0 => x"01", --LDI
1 => x"05", --
2 => x"04", --OUT
3 => x"09", --SUI
4 => x"01", --
5 => x"04", --OUT
6 => x"08", --JNZ
7 => x"03", --
8 => x"01", --LDI
9 => x"08", --
10 => x"04", --OUT
11 => x"FF", --HLT






 
others=>"00000000");
	
	
	
	
	
	
	signal addr_int 	: integer range 0 to 255;
begin
	
	addr_int <= to_integer(unsigned(addr));
	
	process(clk, rd)
	begin
	
		if rd = '1' then
			databus <= ram(addr_int);
		else
			databus <= "ZZZZZZZZ";
		
			if rising_edge(clk) then
				if wr = '1' then
					ram(addr_int) <= databus;
				end if;
			end if;
		end if;
	end process;
end;
