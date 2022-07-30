library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity Control is
	port(	
		CLK	: in std_logic;							--Clock
		RST	: in std_logic;							
		IST	: in std_logic_vector(7 downto 0);	--Instruction
		FLG	: in std_logic_vector(7 downto 0);	--Flags
		
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
		JPq  	: out std_logic;  -- Jump (program counter in)
		FIq	: out std_logic	-- Flags register in
		);
	
end entity;



architecture struct of Control is 
		signal MIST			: std_logic_vector(3 downto 0);		--Micro instrucion counter
		signal CTRL			: std_logic_vector(19 downto 0);		--Control word
		
		
		constant HL : std_logic_vector(19 downto 0) := x"00001";  --00 Halt clock								
		constant MI : std_logic_vector(19 downto 0) := x"00002";  --01 Memory address register in		
		constant RI : std_logic_vector(19 downto 0) := x"00004";  --02 RAM data in							
		constant RO : std_logic_vector(19 downto 0) := x"00008";  --03 RAM data out							
		constant IO : std_logic_vector(19 downto 0) := x"00010";  --04 Instruction register out			
		constant II : std_logic_vector(19 downto 0) := x"00020";  --05 Instruction register in			
		constant AI : std_logic_vector(19 downto 0) := x"00040";  --06 A register in							
		constant AO : std_logic_vector(19 downto 0) := x"00080";  --07 A register out						
		constant EO : std_logic_vector(19 downto 0) := x"00100";  --08 ALU out
		constant SU : std_logic_vector(19 downto 0) := x"00200";  --09 ALU subtract
		constant BI : std_logic_vector(19 downto 0) := x"00400";  --10 B register in
		constant OI : std_logic_vector(19 downto 0) := x"00800";  --11 Output register in
		constant CE : std_logic_vector(19 downto 0) := x"01000";  --12 Program counter enable
		constant CO : std_logic_vector(19 downto 0) := x"02000";  --13 Program counter out
		constant JP : std_logic_vector(19 downto 0) := x"04000";  --14 Jump (program counter in)
		constant DN	: std_logic_vector(19 downto 0) := x"08000";  --15 Reset microinstruction counter
		constant FI	: std_logic_vector(19 downto 0) := x"10000";  --16 Flags register in
		
		constant CY : std_logic_vector(7 downto 0) := x"01"; --Carry flag
		constant ZF : std_logic_vector(7 downto 0) := x"02"; --Zero flag
		
begin


	MISTq <= MIST;

	process(CLK, RST)
	begin
		if RST = '1' then
			MIST <=X"0";
		elsif rising_edge(clk) then
			if (DN and CTRL) = DN then
				MIST <=X"0";
			elsif (HL and CTRL) = HL then
				
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
				
					--LDI, Sets reg A to value, with value in next byte
					when x"01" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR AI OR DN; --Put ram into reg A
							when others => CTRL <= x"00000";
						end case;
					
					--LDA, loads ram to regA,  with address in next byte
					when x"02" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into MAR
							when x"3"	=> CTRL <= RO OR MI; 		--Put RAM into MAR
							when x"4"	=> CTRL <= RO OR AI OR DN;	--Put RAM into REGA
							when others => CTRL <= x"00000";
						end case;
					
					--STA, Stores REGA to RAM, with address in next byte
					when x"03" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into MAR
							when x"3"	=> CTRL <= RO OR MI; 		--Put RAM into MAR
							when x"4"	=> CTRL <= AO OR RI OR DN; --Put REGA into RAM
							when others => CTRL <= x"00000";
						end case;
					
					--OUT, Outputs REGA to output register
					when x"04" =>
						case MIST is
							when x"2" 	=> CTRL <= AO OR OI OR DN;	--Put program counter into MAR
							when others => CTRL <= x"00000";
						end case;
					
					--ADI, Adds reg A to value, with value in next byte
					when x"05" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;				--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR BI; 					--Put ram into reg B
							when x"4"	=> CTRL <= EO OR AI OR FI OR DN; 	--ALU to REGA
							when others => CTRL <= x"00000";
						end case;
					
					--ADD, Adds reg A to whatever is in ram at address x, with x in next byte
					when x"06" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;				--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR MI; 					--Put RAM into MAR
							when x"4"	=> CTRL <= RO OR BI; 					--Put RAM into reg B
							when x"5"	=> CTRL <= EO OR AI OR FI OR DN; 	--ALU to REGA
							when others => CTRL <= x"00000";
						end case;
					
					--JP, Jump to address in next byte
					when x"07" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR JP OR DN; --Put RAM into PC
							when others => CTRL <= x"00000";
						end case;
					
					--JNZ, Jump when zeroflag is not set
					when x"08" =>
						if (FLG AND ZF) > "00" then --Not zero, so continue execution.
							case MIST is
								when x"2" 	=> CTRL <= CE OR DN;	
								when others => CTRL <= x"00000";
							end case;
						else
							case MIST is
								when x"2" 	=> CTRL <= CO OR MI;			--Put program counter into memory address register
								when x"3"	=> CTRL <= RO OR JP OR DN; --Put RAM into PC
								when others => CTRL <= x"00000";
							end case;
						end if;
						
					--SUI, Substracts value from REGA, with value in next byte
					when x"09" =>
						case MIST is
							when x"2" 	=> CTRL <= CO OR MI OR CE;					--Put program counter into memory address register
							when x"3"	=> CTRL <= RO OR BI; 						--Put ram into reg B
							when x"4"	=> CTRL <= SU OR EO OR AI OR FI OR DN; --ALU to REGA
							when others => CTRL <= x"00000";
						end case;
					
					--ADD, Adds reg A to whatever is in ram at address x, with x in next byte
					--when x"06" =>
					--	case MIST is
					--		when x"2" 	=> CTRL <= CO OR MI OR CE;	--Put program counter into memory address register
					--		when x"3"	=> CTRL <= RO OR MI; 		--Put RAM into MAR
					--		when x"4"	=> CTRL <= RO OR BI; 		--Put RAM into reg B
					--		when x"5"	=> CTRL <= EO OR AI OR DN; --ALU to REGA
					--		when others => CTRL <= x"00000";
					--	end case;
						
						
					
					--HLT, Stops clock
					when x"FF" =>
						case MIST is
							when x"2" 	=> CTRL <= HL;
							when others => CTRL <= x"00000";
						end case;
					
					
					
--blue1		 => mist,
--blue2		 => pcd,

--red1		 => databus,
--red2		 => MARD,
--red3		 => IRD,
--red4		 => drega,
--red5		 => dregb
					
					
					--NOP
					when others =>
						CTRL <= x"00000";	
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
	FIq <= CTRL(16);
	
end;








