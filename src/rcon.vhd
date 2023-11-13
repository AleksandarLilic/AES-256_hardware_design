library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_KEY_EXP_LUT.all;

entity rcon is
	port(	
		-- INPUTS
		-- system
		clk		 : IN  STD_LOGIC;
		rst		 : IN  STD_LOGIC;
		
		-- data input
		pi_word_num	 : IN  STD_LOGIC_VECTOR(	   5 DOWNTO 0); -- word counter
		pi_data		 : IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0); -- word for XOR with rcon
		pi_enable	 : IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_rcon_data 	 : OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) 	-- rcon output word
	);
end rcon;

architecture behavioral of rcon is

signal reg_XOR_WORD 		: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0):= (others => '0');

-- address and data lines for RCON manipulation
signal reg_WORD_NUM_0		: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_PI_DATA_0		: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_RCON_LUT_DATA_0	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');

begin

	reg_WORD_NUM_0 <= "00" & pi_word_num;
	reg_PI_DATA_0  <= pi_data;
	
	RCON0: lut_rcon 
		port map
		(pi_address 	=> reg_WORD_NUM_0,
		 po_data	=> reg_RCON_LUT_DATA_0
		);
		
	rcon_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				reg_XOR_WORD 	<= (others => '0');
			elsif(pi_enable = '1') then
				reg_XOR_WORD <= reg_PI_DATA_0 XOR reg_RCON_LUT_DATA_0;			
			end if;
		end if;
	end process;

-- 	 reg_XOR_WORD 	<= (others => '0') when rst = '1' else
-- 			   reg_PI_DATA_0 XOR reg_RCON_LUT_DATA_0;
	
	-- data assignment to the output ports
	po_rcon_data <= reg_XOR_WORD;

end behavioral;