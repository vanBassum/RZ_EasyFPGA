library ieee;
use ieee.std_logic_1164.all;
use  IEEE.STD_LOGIC_ARITH.all;
use  IEEE.STD_LOGIC_UNSIGNED.all;


entity Control is
	port(	
		CLK	: in std_logic;							--Clock
		IST	: in std_logic_vector(7 downto 0);	--Instruction
		
		
		HL   	: out std_logic;  -- Halt clock
		MI   	: out std_logic;  -- Memory address register in
		RI   	: out std_logic;  -- RAM data in
		RO   	: out std_logic;  -- RAM data out
		IO   	: out std_logic;  -- Instruction register out
		II   	: out std_logic;  -- Instruction register in
		AI   	: out std_logic;  -- A register in
		AO   	: out std_logic;  -- A register out
		EO   	: out std_logic;  -- ALU out
		SU   	: out std_logic;  -- ALU subtract
		CY   	: out std_logic;  -- ALU cary out
		BI   	: out std_logic;  -- B register in
		OI   	: out std_logic;  -- Output register in
		CE   	: out std_logic;  -- Program counter enable
		CO   	: out std_logic;  -- Program counter out
		JP   	: out std_logic;  -- Jump (program counter in)
		FI   	: out std_logic);	-- Flags in
	
end entity;



architecture struct of Control is 
		signal MIST			: std_logic_vector(3 downto 0);		--Micro instrucion counter
		signal CTRL			: std_logic_vector(15 downto 0);		--Control word
begin


	process(CLK)
	begin
		MIST <= MIST + 1;
	end process;

	
	process(MIST)
	begin	
		case MIST is
		---START
		
		
when x"0" =>        --NOP
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"1" =>        --LDA
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000010010";
      when x"3" => CTRL <= "0000000001001000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"2" =>        --ADD
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000010010";
      when x"3" => CTRL <= "0000010000001000";
      when x"4" => CTRL <= "1000000101000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"3" =>        --SUB
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000010010";
      when x"3" => CTRL <= "0000010000001000";
      when x"4" => CTRL <= "1000001101000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"4" =>        --STA
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000010010";
      when x"3" => CTRL <= "0000000010000100";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"5" =>        --LDI
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000001010000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"6" =>        --JMP
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0100000000010000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"7" =>        --JC
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"8" =>        --JZ
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"9" =>        --NA1
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"a" =>        --NA2
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"b" =>        --NA3
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"c" =>        --NA4
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"d" =>        --NA5
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"e" =>        --OUT
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000100010000000";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
when x"f" =>        --HLT
  case MIST is
      when x"0" => CTRL <= "0010000000000010";
      when x"1" => CTRL <= "0001000000101000";
      when x"2" => CTRL <= "0000000000000001";
      when x"3" => CTRL <= "0000000000000000";
      when x"4" => CTRL <= "0000000000000000";
      when x"5" => CTRL <= "0000000000000000";
      when x"6" => CTRL <= "0000000000000000";
      when x"7" => CTRL <= "0000000000000000";
      when others => CTRL <= "0000000000000000";
  end case;
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		---END
		end case;
	end process;


	HL <= CTRL(0);
	MI <= CTRL(1);
	RI <= CTRL(2);
	RO <= CTRL(3);
	IO <= CTRL(4);
	II <= CTRL(5);
	AI <= CTRL(6);
	AO <= CTRL(7);
	EO <= CTRL(8);
	SU <= CTRL(9);
	BI <= CTRL(10);
	OI <= CTRL(11);
	CE <= CTRL(12);
	CO <= CTRL(13);
	JP <= CTRL(14);
	
	
end;








