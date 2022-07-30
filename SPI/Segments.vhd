library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity Segments is
	port(	clk			: in std_logic;
			seg			: out std_logic_vector(7 downto 0);
			dig			: out std_logic_vector(3 downto 0);
			seg1			: in std_logic_vector(3 downto 0);
			seg2			: in std_logic_vector(3 downto 0);
			seg3			: in std_logic_vector(3 downto 0);
			seg4			: in std_logic_vector(3 downto 0));
end entity;



architecture struct of Segments is 
	signal cnt 			: std_logic_vector(1 downto 0);
	signal data			: std_logic_vector(3 downto 0); 
begin
	
	process(clk)
	begin
		if(rising_edge(clk)) then
		
			case cnt is
				when "00" => 
					data <= seg4;
					dig  <= "1110";
				when "01" => 
					data <= seg3;
					dig  <= "1101";
				when "10" => 
					data <= seg2;
					dig  <= "1011";
				when "11" => 
					data <= seg1;
					dig  <= "0111";
			end case;
		end if;
		
		if(falling_edge(clk)) then
			cnt <= cnt + 1;
		end if;
		
		
		case data is
			when x"0" => seg <= x"c0";
			when x"1" => seg <= x"f9";
			when x"2" => seg <= x"a4";
			when x"3" => seg <= x"b0";
			when x"4" => seg <= x"99";
			when x"5" => seg <= x"92";
			when x"6" => seg <= x"82";
			when x"7" => seg <= x"f8";
			when x"8" => seg <= x"80";
			when x"9" => seg <= x"90";
			when x"A" => seg <= x"88";
			when x"B" => seg <= x"83";
			when x"C" => seg <= x"c6";
			when x"D" => seg <= x"a1";
			when x"E" => seg <= x"86";
			when x"F" => seg <= x"8e";
		end case;
	end process;
	
	

	
	
	
end;








