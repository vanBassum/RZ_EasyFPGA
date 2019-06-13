

library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;

entity SegmentDisplay is	
	port
	(
		Clk								: in std_logic;
		Dig								: out std_logic_vector(3 downto 0);
		Seg								: out std_logic_vector(7 downto 0);
		Num 								: in std_logic_vector(15 downto 0)

	);
end entity;

architecture Implementation of SegmentDisplay is
	signal cnt 							: std_logic_vector(1 downto 0) := b"00";
	signal state 						: std_logic_vector(1 downto 0) := b"00";
	signal activedigit	 			: std_logic_vector(3 downto 0) := b"0000";
begin
	--Components
	
	
	
	--Wiring
	
	
	
	--Processes

	process(Clk)
	begin
		if(rising_edge(Clk)) then
		

			case state is
				when "00" => 			--first, determain the active digit
					case cnt is
						when "00" => activedigit <= Num(3 downto 0);
						when "01" => activedigit <= Num(7 downto 4);
						when "10" => activedigit <= Num(11 downto 8);
						when "11" => activedigit <= Num(15 downto 12);
					end case;
					
				when "01" => 			--Next, display the active digit
					case activedigit is
						when x"0" => Seg <= x"c0";
						when x"1" => Seg <= x"f9";
						when x"2" => Seg <= x"a4";
						when x"3" => Seg <= x"b0";
						when x"4" => Seg <= x"99";
						when x"5" => Seg <= x"92";
						when x"6" => Seg <= x"82";
						when x"7" => Seg <= x"f8";
						when x"8" => Seg <= x"80";
						when x"9" => Seg <= x"90";
						when x"A" => Seg <= x"88";
						when x"B" => Seg <= x"83";
						when x"C" => Seg <= x"c6";
						when x"D" => Seg <= x"a1";
						when x"E" => Seg <= x"86";
						when x"F" => Seg <= x"8e";
					end case;
					
					case cnt is
						when "00" => Dig <= "1110"; 
						when "01" => Dig <= "1101"; 
						when "10" => Dig <= "1011"; 
						when "11" => Dig <= "0111";
					end case;			
								
				when "10" => 			--This increase the count, so we will display the next digit
					cnt <= cnt + 1;
					
				when others =>
					
				
			end case;
		end if;
		
		
		if(falling_edge(Clk)) then
			state <= state + 1;
		end if;
		

		
	end process;
	

	
end;

