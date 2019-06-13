library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;

entity SD_Card is
	port(
		clk			: in std_logic;

--		videoR		: out std_logic;
--		videoG		: out std_logic;
--		videoB		: out std_logic;
--		hSync			: out std_logic;
--		vSync			: out std_logic;
--		
		SD_CS   		: out std_logic;
		SD_SCK  		: out std_logic;
		SD_MOSI 		: out std_logic;
		SD_MISO 		: in std_logic;


		Digits		: out std_logic_vector(3 downto 0);
		Segments		: out std_logic_vector(7 downto 0);
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


architecture struct of SD_Card is
	signal sd_rd 				: std_logic;	
	signal sd_rd_multiple 	: std_logic;
	signal sd_dout 			: std_logic_vector(7 downto 0);	
	signal sd_dout_avail 	: std_logic;	
	signal sd_dout_taken 	: std_logic;				
	signal sd_wr 				: std_logic;	
	signal sd_wr_multiple 	: std_logic;
	signal sd_din 				: std_logic_vector(7 downto 0);	
	signal sd_din_valid 		: std_logic;	
	signal sd_din_taken 		: std_logic;				
	signal sd_addr 			: std_logic_vector(31 downto 0);	
	signal sd_erase_count 	: std_logic_vector(7 downto 0);
	signal sd_error 			: std_logic;
	signal sd_busy 			: std_logic;
	signal sd_error_code    : std_logic_vector(2 downto 0);

begin


	pll_inst : entity work.sd_controller 
	generic map(				
		clockRate 			=>	50000000,		-- Incoming clock is 50MHz (can change this to 2000 to test Write Timeout)
		slowClockDivider 	=>	64,				-- Basic clock is 25MHz, slow clock for startup is 25/64 = 390kHz
		R1_TIMEOUT 			=>	10,				-- Number of bytes to wait before giving up on receiving R1 response
		WRITE_TIMEOUT 		=>	500				-- Number of ms to wait before giving up on write completing
	)							
	port map(				
		cs 					=>	sd_CS,			-- To SD card
		mosi 					=>	sd_MOSI,			-- To SD card
		miso 					=>	sd_MISO,			-- From SD card
		sclk 					=>	sd_SCK,			-- To SD card
		card_present 		=>	'1',				-- From socket - can be fixed to '1' if no switch is present
		card_write_prot 	=>	'0',				-- From socket - can be fixed to '0' if no switch is present, or '1' to make a Read-Only interface
		rd 					=>	sd_rd,			-- Trigger single block read
		rd_multiple 		=>	'0',				-- Trigger multiple block read
		dout 					=>	sd_dout,			-- Data from SD card
		dout_avail 			=>	sd_dout_avail,	-- Set when dout is valid
		dout_taken 			=>	sd_dout_taken,	-- Acknowledgement for dout
		wr 					=>	sd_wr,			-- Trigger single block write
		wr_multiple 		=>	'0',				-- Trigger multiple block write
		din 					=>	sd_din,			-- Data to SD card
		din_valid 			=>	sd_din_valid,	-- Set when din is valid
		din_taken 			=>	sd_din_taken,	-- Ackowledgement for din
		addr 					=>	sd_addr,			-- Block address
		erase_count 		=>	"00000000",		-- For wr_multiple only
		sd_error 			=>	sd_error, 		-- '1' if an error occurs, reset on next RD or WR
		sd_busy 				=>	sd_busy, 		-- '0' if a RD or WR can be accepted
		sd_error_code 		=>	sd_error_code,	-- See above, 000=No error
		reset 				=>	'0',				-- System reset
		clk 					=>	clk				-- twice the SPI clk (max 50MHz)
		
--		-- Optional debug outputs
--		sd_type 				: out std_logic_vector(1 downto 0),						-- Card status (see above)
--		sd_fsm 				: out std_logic_vector(7 downto 0) := "11111111" 	-- FSM state (see block at end of file)
	);
	
end;







