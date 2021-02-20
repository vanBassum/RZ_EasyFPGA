library ieee;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.all;
use ieee.numeric_std.all;

entity HDMI is
	port(
		clk			: in std_logic;
--		HDMI_CLK		: out std_logic;
		difpin			: out std_logic
--		HDMI_D1		: out std_logic;
--		HDMI_D2		: out std_logic
	);
end entity;


architecture struct of HDMI is


begin

	difpin <= clk;

	
--	CTRL_Inst : entity work.CTRL
--	port map(
--		clk_25 	=> clk,
--		D0 		=> HDMI_D0,
--		D1 		=> HDMI_D1,
--		D2 		=> HDMI_D2,
--		CLK		=> HDMI_CLK
--	);
		
end;







