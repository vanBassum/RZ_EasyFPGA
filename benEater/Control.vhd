library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity Control is
	port(	
		CLK	: in std_logic;							--Clock
		RST	: in std_logic;							
		IST	: in std_logic_vector(7 downto 0);	--Instruction
		
		MISTq	: OUT std_logic_vector(3 downto 0);	--microinstruciuont
		
		HLq  	: out std_logic;  -- Halt clock
		MIq  	: out std_logic;  -- Memory address register in
		RIq  	: out std_logic;  -- RAM data in
		ROq  	: out std_logic;  -- RAM data out
		IOq  	: out std_logic;  -- Instruction register out
		IIq  	: out std_logic;  -- Instruction register in
		AIq  	: out std_logic;  -- A register in
		AOq  	: out std_logic;  -- A register out
		EOq  	: out std_logic;  -- ALU out
		SUq  	: out std_logic;  -- ALU subtract
		BIq  	: out std_logic;  -- B register in
		OIq  	: out std_logic;  -- Output register in
		CEq  	: out std_logic;  -- Program counter enable
		COq  	: out std_logic;  -- Program counter out
		JPq  	: out std_logic  -- Jump (program counter in)
		
		);
	
end entity;



architecture struct of Control is 
		signal MIST			: std_logic_vector(3 downto 0);		--Micro instrucion counter
		signal CTRL			: std_logic_vector(15 downto 0);		--Control word
		
		
		constant HL : std_logic_vector(15 downto 0) := x"0001";  -- Halt clock
		constant MI : std_logic_vector(15 downto 0) := x"0002";  -- Memory address register in
		constant RI : std_logic_vector(15 downto 0) := x"0004";  -- RAM data in
		constant RO : std_logic_vector(15 downto 0) := x"0008";  -- RAM data out
		constant IO : std_logic_vector(15 downto 0) := x"0010";  -- Instruction register out
		constant II : std_logic_vector(15 downto 0) := x"0020";  -- Instruction register in
		constant AI : std_logic_vector(15 downto 0) := x"0040";  -- A register in
		constant AO : std_logic_vector(15 downto 0) := x"0080";  -- A register out
		constant EO : std_logic_vector(15 downto 0) := x"0100";  -- ALU out
		constant SU : std_logic_vector(15 downto 0) := x"0200";  -- ALU subtract
		constant BI : std_logic_vector(15 downto 0) := x"0400";  -- B register in
		constant OI : std_logic_vector(15 downto 0) := x"0800";  -- Output register in
		constant CE : std_logic_vector(15 downto 0) := x"1000";  -- Program counter enable
		constant CO : std_logic_vector(15 downto 0) := x"2000";  -- Program counter out
		constant JP : std_logic_vector(15 downto 0) := x"4000";  -- Jump (program counter in)
		constant DN	: std_logic_vector(15 downto 0) := x"8000";  -- Reset microinstruction counter
		
begin


	MISTq <= MIST;

	process(CLK, RST)
	begin
		if RST = '1' then
			MIST <=X"0";
		elsif rising_edge(clk) then
			if (DN and CTRL) = DN then
				MIST <=X"0";
			else
				MIST <= MIST + 1;
			end if;
		end if;

		
	end process;

	
	process(MIST)
	begin		
	
	
	
		case MIST is
		
			--First 2 are always fetch instruction.
			when x"0" => CTRL <= CO OR MI;			-- Put program counter into memory address register
			when x"1" => CTRL <= RO OR II OR CE;	-- Put ram data into instruction register and increase program counter
			when others =>
			
				case IST is
				
					--LDA		(Loads next byte from ram into reg A)
					when x"01" =>
				
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR AI OR DN; --Put ram into reg A
							when others => CTRL <= x"0000";
						end case;
					
					--NOP
					when others =>
						CTRL <= x"0000";	
				end case;
		end case;
	end process;	
		
		
	HLq <= CTRL(0);
	MIq <= CTRL(1);
	RIq <= CTRL(2);
	ROq <= CTRL(3);
	IOq <= CTRL(4);
	IIq <= CTRL(5);
	AIq <= CTRL(6);
	AOq <= CTRL(7);
	EOq <= CTRL(8);
	SUq <= CTRL(9);
	BIq <= CTRL(10);
	OIq <= CTRL(11);
	CEq <= CTRL(12);
	COq <= CTRL(13);
	JPq <= CTRL(14);
	
	
end;








