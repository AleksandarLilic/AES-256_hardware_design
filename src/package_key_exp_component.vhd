library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

package package_key_exp_component is

component key_parser is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		rst : IN  STD_LOGIC;
		
		-- data input
		pi_master_key		  : IN  STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
		pi_new_key_word		  : IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
		pi_word_num	 	  : IN  STD_LOGIC_VECTOR(5 DOWNTO 0); -- word counter
		pi_previous_key_word_ctrl : IN  STD_LOGIC;
		pi_new_key_word_we 	  : IN  STD_LOGIC;
		pi_enable		  : IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_current_key_word	: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1	  	DOWNTO 0);
		po_previous_key_word	: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1	  	DOWNTO 0);
		po_round_keys_array	: OUT t_ROUND_KEYS
	);
end component;

component rot_word is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		rst : IN  STD_LOGIC;
		
		-- data input
		pi_data		 : IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);	-- word to be rotated
		pi_enable	 : IN  STD_LOGIC;			-- signal to start rotation
		
		-- OUTPUTS
		-- data output
		po_rot_word_data : OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) 	-- rotated word
	);
end component;

component sub_word is
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
end component;

component rcon is
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
end component;

component xor_sync is
	port(	
		-- INPUTS
		-- system
		clk		: IN  STD_LOGIC;
		rst		: IN  STD_LOGIC;
		
		-- data input
		pi_data_1	: IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
		pi_data_2	: IN  STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
		pi_enable	: IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_xor_data	: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0)
		
	);
end component;

component fsm_key_expansion is
	port(	
		-- INPUTS
		-- system
		clk			: IN  STD_LOGIC;
		--rst			: IN  STD_LOGIC;
		
		-- data input
		pi_key_expand_start	: IN  STD_LOGIC;
		pi_word_num	 	: IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		-- OUTPUTS
		po_modules_rst		: OUT STD_LOGIC;
		po_key_ready	 	: OUT STD_LOGIC;
		po_word_cnt_en	 	: OUT STD_LOGIC;
		po_word_cnt_rst	 	: OUT STD_LOGIC;
		-- to key_parser
		po_previous_key_word_ctrl	: OUT STD_LOGIC;
		po_new_key_word_we	: OUT STD_LOGIC;
		po_key_parser_enable	: OUT STD_LOGIC;
		-- to rot_word
		po_rot_word_enable	: OUT STD_LOGIC;
		-- to sub_word
		po_sub_word_enable	: OUT STD_LOGIC;
		po_sub_word_mux		: OUT STD_LOGIC;
		-- to rcon
		po_rcon_enable		: OUT STD_LOGIC;
		-- to xor
		po_xor_enable		: OUT STD_LOGIC;
		po_xor_mux		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
		);
end component;

component cnt_8_60 is
	port(	
		-- INPUTS
		-- system
		clk		: IN  STD_LOGIC;
		rst		: IN  STD_LOGIC;
		
		-- data input
		pi_enable	: IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_data 	: OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
		
	);
end component;

end package_key_exp_component;