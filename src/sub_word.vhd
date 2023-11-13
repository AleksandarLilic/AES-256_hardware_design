library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_KEY_EXP_LUT.all;

entity sub_word is
	port(	
		-- INPUTS
		-- system
		clk			: IN  STD_LOGIC;
		rst			: IN  STD_LOGIC;
		
		-- data input
		pi_data			: IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);	-- word to be substituted
		pi_enable	 	: IN  STD_LOGIC;			-- signal to start substitution
		
		-- OUTPUTS
		-- data output
		po_sub_word_data	: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) 	-- substituted word
	);
end sub_word;

architecture behavioral of sub_word is

signal reg_SUB_WORD 	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');	-- stores substituted word in sub_word_process

-- address and data lines divided into bytes for SBOX manipulation
signal reg_SBOX_ADDRESS_0	: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_DATA_0		: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_ADDRESS_1	: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_DATA_1		: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_ADDRESS_2	: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_DATA_2		: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_ADDRESS_3	: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SBOX_DATA_3		: STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');

begin
	reg_SBOX_ADDRESS_0 <= pi_data(7  DOWNTO 0);
	reg_SBOX_ADDRESS_1 <= pi_data(15 DOWNTO 8);
	reg_SBOX_ADDRESS_2 <= pi_data(23 DOWNTO 16);
	reg_SBOX_ADDRESS_3 <= pi_data(31 DOWNTO 24);
	
	SBOX0: lut_sbox 
		port map
		(pi_address 	=> reg_SBOX_ADDRESS_0,
		 po_data	=> reg_SBOX_DATA_0
		);
	SBOX1: lut_sbox 
		port map
		(pi_address 	=> reg_SBOX_ADDRESS_1,
		 po_data	=> reg_SBOX_DATA_1
		);
	SBOX2: lut_sbox 
		port map
		(pi_address 	=> reg_SBOX_ADDRESS_2,
		 po_data	=> reg_SBOX_DATA_2
		);
	SBOX3: lut_sbox 
		port map
		(pi_address 	=> reg_SBOX_ADDRESS_3,
		 po_data	=> reg_SBOX_DATA_3
		);	
	
	sub_word_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then
				reg_SUB_WORD 	<= (others => '0');
			elsif(pi_enable = '1') then
				reg_SUB_WORD 	<= reg_SBOX_DATA_3 & reg_SBOX_DATA_2 
						 & reg_SBOX_DATA_1 & reg_SBOX_DATA_0;			
			end if;
		end if;
	end process;
	
	-- data assignment to the output ports
	po_sub_word_data <= reg_SUB_WORD;

end behavioral;