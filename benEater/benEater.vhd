library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;




--https://www.youtube.com/watch?v=HyznrdDSSGM&list=PLowKtXNTBypGqImE405J2565dvjafglHU&ab_channel=BenEater

entity benEater is
	port(	CLK			: in std_logic;
			Digits		: out std_logic_vector(3 downto 0);
			Segments		: out std_logic_vector(7 downto 0);
			LED1			: out std_logic;
			LED2			: out std_logic;
			LED3			: out std_logic;
			LED4			: out std_logic;
			KEY1			: in std_logic;
			KEY2			: in std_logic;
			KEY3			: in std_logic;
			KEY4			: in std_logic;
			LEDMATCOL	: out std_logic_vector(7 downto 0);
			LEDMATROW	: out std_logic_vector(2 downto 0));
end entity;





architecture struct of benEater is 
	signal clkdiv  	: std_logic_vector(31 downto 0);
	
begin


	LedMatrix_1 : entity work.LedMatrix
	port map(
			clk		 => clkdiv(12),
			blue1		 => "10000000",
			blue2		 => "01000000",
			red1		 => "00100000",
			red2		 => "00010000",
			red3		 => "00001000",
			red4		 => "00000100",
			red5		 => "00000010",
			LEDMATCOL => LEDMATCOL,
			LEDMATROW => LEDMATROW
	);



	
	
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			clkdiv <= clkdiv + 1;
			
		end if;
	end process;
		

	
	
end;