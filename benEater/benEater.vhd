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
	
	signal clkdiv  	: std_logic_vector(31 downto 0);
	signal databus		: std_logic_vector(7 downto 0);
	
	signal dregA		: std_logic_vector(7 downto 0);
	signal dregb		: std_logic_vector(7 downto 0);
	signal MARD			: std_logic_vector(7 downto 0);
	signal IRD			: std_logic_vector(7 downto 0);
	signal OUTD			: std_logic_vector(7 downto 0);
	signal pcd			: std_logic_vector(7 downto 0);
	
	signal mist			: std_logic_vector(7 downto 0);
	signal flagsI		: std_logic_vector(7 downto 0);
	signal flagsQ		: std_logic_vector(7 downto 0);

	
	signal seg1			: std_logic_vector(3 downto 0) := b"0000";
	signal seg2			: std_logic_vector(3 downto 0) := b"0000";
	signal seg3			: std_logic_vector(3 downto 0) := b"0000";
	signal seg4			: std_logic_vector(3 downto 0) := b"0000";
	
	signal BTN1			: std_logic := '0';
	signal BTN2			: std_logic := '0';
	signal BTN3			: std_logic := '0';
	signal BTN4			: std_logic := '0';
	signal ONE			: std_logic := '0';
	
	signal DCLK			: std_logic := '0';
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
	signal BI   : std_logic := '0';  -- B register in
	signal BO   : std_logic := '0';  -- B register out
	signal EO   : std_logic := '0';  -- ALU out
	signal SU   : std_logic := '0';  -- ALU subtract
	signal CY   : std_logic := '0';  -- ALU cary out
	signal ZF   : std_logic := '0';  -- ALU Zero flag
	signal OI   : std_logic := '0';  -- Output register in
	signal CE   : std_logic := '0';  -- Program counter enable
	signal CO   : std_logic := '0';  -- Program counter out
	signal JP   : std_logic := '0';  -- Jump (program counter in)
	signal FI   : std_logic := '0';  -- Flags in
	
begin

	RegF : entity work.Reg				--Register flags
	port map(
		clk			=> MCLK,	
		ld 			=> FI,
		oe				=> '0',
		rst			=> RST,
		dout			=> flagsQ,
		databus		=> flagsI
	);


	RegA : entity work.Reg				--Register B
	port map	(
		clk			=> MCLK,	
		ld 			=> AI,
		oe				=> AO,
		rst			=> RST,
		dout			=> dregA,
		databus		=> databus);
		
		
	RegB : entity work.Reg				--Register A
	port map	(
		clk			=> MCLK,	
		ld 			=> BI,
		oe				=> BO,
		rst			=> RST,
		dout			=> dregb,
		databus		=> databus);	
		
	Alu : entity work.Alu				--Arithmetic logic unit
	port map	(
		sub			=> SU,
		oe				=> EO,
		co				=> CY,			
		zo				=> ZF,
		databus		=> databus,
		dataA			=> DregA,
		dataB			=> DregB);

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
		databus		=> databus,
		dout			=> pcd,
		rst			=> RST);
		
	REGO : entity work.Reg				--output register
	port map	(
		clk			=> MCLK,	
		ld 			=> OI,
		oe				=> '0',
		rst			=> RST,
		dout			=> OUTD,
		databus		=> databus);
			
	ctrl : entity work.Control			--Control logic
	port map(
		CLK			=> NCLK,
		IST			=> IRD,
		RST			=> RST,
		FLG			=> flagsQ,
		mistq 		=> mist(7 downto 4),
		HLq			=> HL, 
		MIq			=> MI, 
		RIq			=> RI, 
		ROq			=> RO, 
		IOq			=> IO, 
		IIq			=> II, 
		AIq			=> AI, 
	   AOq			=> AO, 
	   EOq			=> EO, 
	   SUq			=> SU, 
	   BIq			=> BI, 
	   OIq			=> OI, 
	   CEq			=> CE, 
	   COq			=> CO, 
	   JPq			=> JP,
		FIq			=> FI);
		
		
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
		
	debounce_1 : entity work.debounce	
	port map(
		reset_n	=> '1',
		clk 		=> clk,
		button 	=> not KEY1,
		result 	=> BTN1);
		
	debounce_2 : entity work.debounce
	port map(
		reset_n	=> '1',
		clk 		=> clk,
		button 	=> not KEY2,
		result 	=> BTN2);
		
	debounce_3 : entity work.debounce
	port map(
		reset_n	=> '1',
		clk 		=> clk,
		button 	=> not KEY3,
		result 	=> BTN3);
	
	debounce_4 : entity work.debounce
	port map(
		reset_n	=> '1',
		clk 		=> clk,
		button 	=> not KEY4,
		result 	=> BTN4);

		
	process(DCLK)							-- Clock divider
	begin	
		if ONE = '0' then
			if BTN3 = '1' then
				MCLK <= DCLK;
			elsif BTN4 = '1' then
				ONE <= '1';
			else
				MCLK <= BTN1;
			end if;	
		else
			if MIST(7 downto 4) = "0000" then
				ONE <= '0';
			else
				MCLK <= DCLK;
			end if;
		end if;


	end process;
	
	flagsI(0) <= CY;	--Carry
	flagsI(1) <= ZF;	--Zero
		
	DCLK <= clkdiv(22);	
	NCLK  <= not MCLK;
	RST	<= BTN2;
		
	LED1	<= not MCLK;
	LED2 	<= not NCLK;
	LED3	<= not RST;
	
	SEG1 <= OUTD(7 downto 4);
	SEG2 <= OUTD(3 downto 0);	
	
	
	process(CLK)
	begin
		if(rising_edge(CLK)) then
			clkdiv <= clkdiv + 1;
			
		end if;
	end process;
		

	
	
end;