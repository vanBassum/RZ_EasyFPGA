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
	signal dp_r			: std_logic;
	signal dp_g			: std_logic;
	signal dp_b			: std_logic;
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
			px				=> disp_x,		--horizontal pixel coordinate
			py				=> disp_y		--vertical pixel coordinate
			--n_blank						--direct blacking output to DAC
			--n_sync							--sync-on-green output to DAC
		);
	
	pll_inst : entity work.pll 
	PORT MAP (
		inclk0	=> clk,
		c0	 		=> clk_40
	);
	
	image : entity work.hw_image_generator
	PORT MAP(
		clk		=> clk_40,
		disp_ena => disp_ena,
		py      	=> disp_y,
		px   		=> disp_x,
		red      => videoR,
		green    => videoG,
		blue     => videoB
	);
end;

















