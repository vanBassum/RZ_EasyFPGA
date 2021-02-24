library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;
use IEEE.STD_LOGIC_UNSIGNED.all;



entity VGA_Test is
	port(
		clk			: in std_logic;
		videoR		: out std_logic;
		videoG		: out std_logic;
		videoB		: out std_logic;
		hSync			: out std_logic;
		vSync			: out std_logic;
		LED1			: out std_logic;
		LED2			: out std_logic;
		LED3			: out std_logic;
		LED4			: out std_logic;
		KEY1			: in std_logic;
		KEY2			: in std_logic;
		KEY3			: in std_logic;
		KEY4			: in std_logic);
end entity;



architecture struct of VGA_Test is
	constant objects : integer := 24;

	signal clk_40		: std_LOGIC;
	signal disp_ena	: std_LOGIC;
	signal disp_x		: integer;
	signal disp_y		: integer;
	signal qd				: std_logic_vector(objects downto 0);
	signal dp			: std_logic;
	signal mvCLK			: std_logic;
	signal clkdiv  		: std_logic_vector(31 downto 0);
	--signal x				: std_logic_vector(15 downto 0);
	--signal y				: std_logic_vector(15 downto 0);
	

begin

	vga : entity work.vga_controller
		generic map(
		h_pixels			=> 800,			--horiztonal display width in pixels
		h_fp	 			=> 40,			--horiztonal front porch width in pixels
		h_pulse 			=> 128,    		--horiztonal sync pulse width in pixels
		h_bp	 			=> 88,			--horiztonal back porch width in pixels
		h_pol				=>'1',			--horizontal sync pulse polarity (1 = positive, 0 = negative)
			
		v_pixels			=> 600,			--vertical display width in rows
		v_fp	 			=> 1,				--vertical front porch width in rows
		v_pulse 			=> 4,				--vertical sync pulse width in rows
		v_bp	 			=> 23,			--vertical back porch width in rows
		v_pol				=>'1'				--vertical sync pulse polarity (1 = positive, 0 = negative)
		)	
		port map(	
			pixel_clk	=> clk_40,		--pixel clock at frequency of VGA mode being used
			reset_n		=> '1',			--active low asycnchronous reset
			h_sync		=> hSync,		--horiztonal sync pulse
			v_sync		=> vSync,		--vertical sync pulse
			disp_ena		=> disp_ena,	--display enable ('1' = display time, '0' = blanking time)
			column		=> disp_x,		--horizontal pixel coordinate
			row			=> disp_y		--vertical pixel coordinate
			--n_blank						--direct blacking output to DAC
			--n_sync							--sync-on-green output to DAC
		);
	
	pll_inst : entity work.pll 
	PORT MAP (
		inclk0	=> clk,
		c0	 		=> clk_40
	);
	
	
	
	
	REGGEN:
	for I in 0 to objects generate
		movx : entity work.Mover
		generic map(
			speed => 16,
			x => I * 32,
			y => 10
		)
		port map (
			clk	 => mvCLK,
			disp_x => disp_x,
			disp_y => disp_y,
			q		 => qd(I)	
		);
		
	
	end generate REGGEN;
	
	mvCLK <= clkdiv(16) AND KEY1;
	

	process (clk)
	begin
	
		if rising_edge(clk) then
			clkdiv <= clkdiv + 1;
		end if;
		
		if qd > 0 then
			dp <= '1';
		else
			dp <= '0';
		end if;
		
		videoR <= dp and disp_ena;
		videoG <= dp and disp_ena;
		videoB <= dp and disp_ena;	
	end process;
	


	
end;

















