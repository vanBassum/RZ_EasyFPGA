
LIBRARY ieee;
USE ieee.numeric_std.all;
use ieee.std_logic_1164.all;





entity hw_image_generator is
	generic(
		res_x :  INTEGER := 800;
		res_y :  INTEGER := 600
	);
	port(
		clk		:  IN   STD_LOGIC;
		disp_ena :  IN   STD_LOGIC;  --display enable ('1' = display time, '0' = blanking time)
		px      	:  IN   INTEGER;    --row pixel coordinate
		py   		:  IN   INTEGER;    --column pixel coordinate
		red      :  OUT  STD_LOGIC;  --red magnitude output to DAC
		green    :  OUT  STD_LOGIC;  --green magnitude output to DAC
		blue     :  OUT  STD_LOGIC  --blue magnitude output to DAC
	);
end entity;



ARCHITECTURE behavior OF hw_image_generator IS
	signal div			: STD_LOGIC_VECTOR(2 downto 0);
	signal col			: INTEGER;
	signal row 			: INTEGER;
	signal char_addr	: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal char_val	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal rom_addr	: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal rom_q		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal rom_shf		: STD_LOGIC_VECTOR (7 DOWNTO 0);
BEGIN

	txtram : entity work.txtram
	port map(
		address_a	=> "0000000000",
		clock_a		=> '0',
		data_a		=> "00000000",
		wren_a		=> '0',
		--q_a				
		
		address_b 	=> char_addr,
		clock_b	 	=> clk,
		data_b		=> "00000000",
		wren_b    	=> '0',			
		q_b		 	=> char_val
	);
	
	
	
	fontrom : entity work.fontrom 
	port map(	
		address_a	=> "0000000000",
		clock_a		=> '0',
		data_a		=> "00000000",
		wren_a		=> '0',
		--q_a				
		
		address_b 	=> rom_addr,
		clock_b	 	=> clk,
		data_b		=> "00000000",
		wren_b    	=> '0',			
		q_b		 	=> rom_q
	);
	

	PROCESS(disp_ena, clk)
	BEGIN

		col <= px / 8;
		row <= py / 8;
		
		
		char_addr <= std_logic_vector(to_unsigned(col + row * 64, char_addr'length));
		rom_addr <= std_logic_vector(to_unsigned((TO_INTEGER(unsigned(char_val)) * 8) + (py mod 8), rom_addr'length));
		rom_shf <= std_logic_vector(shift_right(unsigned(rom_q), px mod 8));


		IF(disp_ena = '1') THEN

			red 	<= std_logic_vector(to_unsigned(px / 80, 1))(0);
			green <= rom_shf(0);
			blue 	<= '1';
			
		else
			red 	<= '0';
			green <= '0';
			blue 	<= '0';
		end if;
		

	END PROCESS;
END behavior;


