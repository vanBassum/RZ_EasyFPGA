library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;



entity VGA_Test is
	port(
--		n_reset		: in std_logic;
		clk			: in std_logic;
--
--		sramData		: inout std_logic_vector(7 downto 0);
--		sramAddress	: out std_logic_vector(15 downto 0);
--		n_sRamWE		: out std_logic;
--		n_sRamCS		: out std_logic;
--		n_sRamOE		: out std_logic;
--		
--		rxd1			: in std_logic;
--		txd1			: out std_logic;
--		rts1			: out std_logic;
--
--		rxd2			: in std_logic;
--		txd2			: out std_logic;
--		rts2			: out std_logic;
--		
--		videoSync	: out std_logic;
--		video			: out std_logic;
--
		videoR		: out std_logic;
		videoG		: out std_logic;
		videoB		: out std_logic;
		hSync			: out std_logic;
		vSync			: out std_logic;
--		
--		Digits		: out std_logic_vector(3 downto 0);
--		Segments		: out std_logic_vector(7 downto 0);
		LED1			: out std_logic;
		LED2			: out std_logic;
		LED3			: out std_logic;
		LED4			: out std_logic;
		KEY1			: in std_logic;
		KEY2			: in std_logic;
		KEY3			: in std_logic;
		KEY4			: in std_logic
	);
end entity;


architecture struct of VGA_Test is
	signal clk_40		: std_LOGIC;
	signal disp_ena	: std_LOGIC;
	signal disp_row	: integer;
	signal disp_col	: integer;
	signal thingy		: std_logic_vector(2 downto 0);
	
	function To_Std_Logic(L: BOOLEAN) return std_ulogic is
	begin
		if L then
			return('1');
		else
			return('0');
		end if;
	end function;
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
			column		=> disp_col,	--horizontal pixel coordinate
			row			=> disp_row		--vertical pixel coordinate
			--n_blank						--direct blacking output to DAC
			--n_sync							--sync-on-green output to DAC
		);
	
	pll_inst : entity work.pll 
	PORT MAP (
		inclk0	=> clk,
		c0	 		=> clk_40
	);
	

	process (clk)
	begin
		
		thingy <= std_logic_vector(to_unsigned(disp_col / 100, thingy'length));

		videoR <= thingy(0) and disp_ena;
		videoG <= thingy(1) and disp_ena;
		videoB <= thingy(2) and disp_ena;	

	
	
	end process;
	


	
end;

















