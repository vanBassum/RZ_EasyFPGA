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
			SCK			: in std_logic;
			NCS			: in std_logic;
			MOSI			: in std_logic;
			MISO			: out std_logic);
end entity;





architecture struct of benEater is 
	signal clkdiv  	: std_logic_vector(31 downto 0);
	signal dregA		: std_logic_vector(7 downto 0);
	
	signal seg1			: std_logic_vector(3 downto 0) := b"0000";
	signal seg2			: std_logic_vector(3 downto 0) := b"0000";
	signal seg3			: std_logic_vector(3 downto 0) := b"0000";
	signal seg4			: std_logic_vector(3 downto 0) := b"0000";
	
begin
	
	Seg : entity work.Segments			-- Driver for the 7 segment display 
	port map
	(
		clk 			=> clkdiv(10),
		seg 			=> Segments,
		dig 			=> Digits,
		seg1			=> seg1,
		seg2			=> seg2,
		seg3			=> seg3,
		seg4			=> seg4);
		
	
	seg1 <= dregA(7 downto 4);
	seg2 <= dregA(3 downto 0);	
	
	
	process(SCK)
	begin
		if 
	end process;
	
	
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			clkdiv <= clkdiv + 1;
			
		end if;
	end process;

	
	
end;





