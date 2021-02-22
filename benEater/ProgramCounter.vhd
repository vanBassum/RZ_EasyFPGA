library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity ProgramCounter is
	port(	
			clk		: in std_logic;
			rst		: in std_logic;
			inc		: in STD_LOGIC;                             
			oe			: in STD_LOGIC;                             
			wr			: in  STD_LOGIC;      
			databus	: inout STD_LOGIC_VECTOR(7 DOWNTO 0);
			dout		: out STD_LOGIC_VECTOR(7 DOWNTO 0)); 
			
			
end entity;



architecture struct of ProgramCounter is 
	signal counter 	: std_logic_vector(7 downto 0);
	
begin
	
	process(clk, rst)
	begin
	
		dout <= counter;
		
		
		if RST = '1' then
			counter <= x"00";
		elsif rising_edge(clk) then
			if wr = '1' then
				counter <= databus;
			elsif inc = '1' then
				counter <= counter + 1;
			end if;
			
		end if;

	
		if oe = '1' then
			databus <= counter;
		else
			databus <= "ZZZZZZZZ";	
			
		end if;	
	end process;
end;
