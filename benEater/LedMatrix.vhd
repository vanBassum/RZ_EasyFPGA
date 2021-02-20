library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;


entity LedMatrix is
	port(	
			clk			: in std_logic;
			blue1			: in STD_LOGIC_VECTOR(7 DOWNTO 0); 
			blue2			: in STD_LOGIC_VECTOR(7 DOWNTO 0); 
			red1			: in STD_LOGIC_VECTOR(7 DOWNTO 0); 
			red2			: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			red3			: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			red4			: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			red5			: in STD_LOGIC_VECTOR(7 DOWNTO 0);
			LEDMATCOL	: out std_logic_vector(7 downto 0);
			LEDMATROW	: out std_logic_vector(2 downto 0));
end entity;



architecture struct of LedMatrix is 
	signal counter 	: std_logic_vector(2 downto 0);
	
begin
	
	LEDMATROW <= counter;
	
	
	process(clk)
	begin
		if rising_edge(clk) then
			counter <= counter + 1;
		end if;

		case counter is
			when "000" => LEDMATCOL <= blue1;
			when "001" => LEDMATCOL <= red3;
			when "010" => LEDMATCOL <= red1;
			when "011" => LEDMATCOL <= red5;
			when "100" => LEDMATCOL <= blue2;
			when "101" => LEDMATCOL <= red4;
			when "110" => LEDMATCOL <= red2;
			when "111" => LEDMATCOL <= "00000000";
		end case;
	end process;
end;
