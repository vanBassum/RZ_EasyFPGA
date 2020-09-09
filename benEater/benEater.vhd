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
			KEY4			: in std_logic);
			
end entity;



architecture struct of benEater is 
	signal MCLK			: std_logic := '0';
	signal NCLK			: std_logic := '0';
	signal RST			: std_logic := '0';
	
	signal HL   : std_logic := '0';  -- Halt clock
	signal MI   : std_logic := '0';  -- Memory address register in
	signal RI   : std_logic := '0';  -- RAM data in
	signal RO   : std_logic := '0';  -- RAM data out
	signal IO   : std_logic := '0';  -- Instruction register out
	signal II   : std_logic := '0';  -- Instruction register in
	signal AI   : std_logic := '0';  -- A register in
	signal AO   : std_logic := '0';  -- A register out
	signal EO   : std_logic := '0';  -- ALU out
	signal SU   : std_logic := '0';  -- ALU subtract
	signal CY   : std_logic := '0';  -- ALU cary out
	signal BI   : std_logic := '0';  -- B register in
	signal OI   : std_logic := '0';  -- Output register in
	signal CE   : std_logic := '0';  -- Program counter enable
	signal CO   : std_logic := '0';  -- Program counter out
	signal JP   : std_logic := '0';  -- Jump (program counter in)
	signal FI   : std_logic := '0';  -- Flags in




	signal databus		: std_logic_vector(7 downto 0);
	signal REGAD		: std_logic_vector(7 downto 0);
	signal REGBD		: std_logic_vector(7 downto 0);
	signal MARD			: std_logic_vector(7 downto 0);
	signal IRD			: std_logic_vector(7 downto 0);
	signal OUTD			: std_logic_vector(7 downto 0);
	

	signal seg1			: std_logic_vector(3 downto 0) := b"0000";
	signal seg2			: std_logic_vector(3 downto 0) := b"0000";
	signal seg3			: std_logic_vector(3 downto 0) := b"0000";
	signal seg4			: std_logic_vector(3 downto 0) := b"0000";
	signal div			: std_logic_vector(31 downto 0);
begin
	
	
	RegA : entity work.Reg				--Register B
	port map	(
		clk			=> MCLK,	
		ld 			=> AI,
		oe				=> AO,
		rst			=> RST,
		dout			=> REGAD,
		databus		=> databus);
		
	RegB : entity work.Reg				--Register A
	port map	(
		clk			=> MCLK,	
		ld 			=> BI,
		oe				=> '1',
		rst			=> RST,
		dout			=> REGBD,
		databus		=> databus);		
		
	Alu : entity work.Alu				--Arithmetic logic unit
	port map	(
		sub			=> SU,
		oe				=> EO,
		co				=> CY,			
		databus		=> databus,
		dataA			=> REGAD,
		dataB			=> REGBD);
		
	IR	: entity work.Reg					--Instruction register
	port map	(
		clk			=> MCLK,	
		ld 			=> II,
		oe				=> IO,
		rst			=> RST,
		dout			=> IRD,
		databus		=> databus);
		
	MAR : entity work.Reg				--Memory address register
	port map	(
		clk			=> MCLK,	
		ld 			=> MI,
		oe				=> '0',
		rst			=> RST,
		dout			=> MARD,
		databus		=> databus);
		
	Ram : entity work.Ram				--RAM
	port map	(
		clk	  		=> MCLK,
	   wr		  		=> RI,
	   rd		  		=> RO,
	   addr	  		=> MARD,
	   databus 		=> databus);	
		
		
	PC	: entity work.ProgramCounter	--Program counter
	port map	(
		clk			=> MCLK,
		inc			=> CE,
		oe				=> CO,
		wr				=> JP,
		databus		=> databus);
		
	outp1 : entity work.Reg				--7 seg output
	port map	(
		clk			=> MCLK,	
		ld 			=> OI,
		oe				=> '0',
		rst			=> RST,
		dout			=> OUTD,
		databus		=> databus);
		
	ctrl : entity work.Control
	port map(
		CLK			=> NCLK,
		IST			=> IRD,
		HL				=> HL, 
		MI				=> MI, 
		RI				=> RI, 
		RO				=> RO, 
		IO				=> IO, 
		II				=> II, 
		AI				=> AI, 
	   AO				=> AO, 
	   EO				=> EO, 
	   SU				=> SU, 
	   CY				=> CY, 
	   BI				=> BI, 
	   OI				=> OI, 
	   CE				=> CE, 
	   CO				=> CO, 
	   JP				=> JP, 
	   FI				=> FI);

		

		
		
	Seg : entity work.Segments
	port map
	(
		clk 			=> div(10),
		seg 			=> Segments,
		dig 			=> Digits,
		seg1			=> seg1,
		seg2			=> seg2,
		seg3			=> seg3,
		seg4			=> seg4);

		
		

	MCLK 	<= KEY1;	
	NCLK  <= not MCLK;
	LED1	<= MCLK;
	LED2	<= NCLK;
	LED3	<= '1';
	LED4	<= '1';
		
	process (CLK)
	begin
		if rising_edge(CLK) then
			div 	<= div + 1;
			--seg1	<= OUTD(7 downto 4);
			--seg2	<= OUTD(3 downto 0);
			--seg3 	<= databus(7 downto 4);
			--seg4 	<= databus(3 downto 0);
		end if;
		
	end process;
end;

