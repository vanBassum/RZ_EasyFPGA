
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
	signal char_addr	: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal char_val	: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal rom_addr	: STD_LOGIC_VECTOR (9 DOWNTO 0);
	signal rom_q		: STD_LOGIC_VECTOR (7 DOWNTO 0);
	signal pixel 		: STD_LOGIC;
	signal chval		: INTEGER;
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
		char_addr <= std_logic_vector(to_unsigned(px / 8 + (py / 8) * (res_x/8), char_addr'length));
				
		rom_addr(2 downto 0) <= std_logic_vector(to_unsigned(py, 4))(2 downto 0);
		rom_addr(9 downto 3) <= char_val(6 downto 0);
		pixel <= rom_q(px mod 8);
		

		IF(disp_ena = '1') THEN

			red 	<= std_logic_vector(to_unsigned(px / 8, 1))(0);
			green <= pixel;
			blue 	<= '1';
			
		else
			red 	<= '0';
			green <= '0';
			blue 	<= '0';
		end if;
		

	END PROCESS;
END behavior;


