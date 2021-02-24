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
			
			
			
			
			);
end entity;





architecture struct of benEater is 
		
begin


	
	
end;