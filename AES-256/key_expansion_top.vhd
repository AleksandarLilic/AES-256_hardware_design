library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_KEY_EXP_COMPONENT.all;

entity key_expansion_top is
	port(	
		-- INPUTS
		-- system
		clk			: IN  STD_LOGIC;
		
		-- data input
		pi_key_expand_start 	: IN  STD_LOGIC;
		pi_master_key		: IN  STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
		
		-- OUTPUTS
		-- data output
		po_round_keys_array	: OUT t_ROUND_KEYS;
		po_key_ready		: OUT STD_LOGIC
		);
end key_expansion_top;

architecture behavioral of key_expansion_top is

-- FSM
signal reg_FSM_KEY_READY 	: STD_LOGIC := '0';
signal reg_FSM_CNT_ENABLE	: STD_LOGIC := '0';
signal reg_FSM_CNT_RST		: STD_LOGIC := '0';
signal reg_FSM_MODULES_RST	: STD_LOGIC := '0';

signal reg_FSM_KEY_PARSER_PREVIOUS_KEY_WORD_CTRL : STD_LOGIC := '0';
signal reg_FSM_KEY_PARSER_NEW_KEY_WORD_WE	 : STD_LOGIC := '0';
signal reg_FSM_KEY_PARSER_EN	: STD_LOGIC := '0';

signal reg_FSM_ROT_WORD_EN	: STD_LOGIC := '0';
signal reg_FSM_SUB_WORD_EN	: STD_LOGIC := '0';
signal reg_FSM_SUB_WORD_MUX	: STD_LOGIC := '0';
signal reg_FSM_RCON_EN		: STD_LOGIC := '0';
signal reg_FSM_XOR_EN		: STD_LOGIC := '0';
signal reg_FSM_XOR_MUX		: STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');

-- COUNTER
signal reg_CNT_WORD_NUM		: STD_LOGIC_VECTOR(5 DOWNTO 0) := (others => '0');

-- KEY PARSER
signal w_KEY_PARSER_ROUND_KEY 		: t_ROUND_KEYS := (others => (others => '0'));
signal reg_KEY_PARSER_CURRENT_KEY_WORD	: STD_LOGIC_VECTOR(		  WORD_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_KEY_PARSER_PREVIOUS_KEY_WORD	: STD_LOGIC_VECTOR(		  WORD_WIDTH-1 DOWNTO 0) := (others => '0');

-- ROT WORD
signal reg_ROT_WORD_DATA 	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');

-- SUB WORD
signal reg_SUB_WORD_INPUT_WORD 	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_SUB_WORD_DATA 	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');

-- RCON
signal reg_RCON_DATA 		: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_ROT_WORD_INPUT_WORD  : STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');

-- XOR_WE
signal reg_XOR_INPUT_WORD 	: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_XOR_DATA 		: STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) := (others => '0');

begin
		 
	FSM_KEY_EXPANSION_1: fsm_key_expansion
		 port map
		 (clk	=> clk,
		  --rst	=> rst,
		  -- DATA INPUTS
		  pi_key_expand_start	 => pi_key_expand_start,
		  pi_word_num		 => reg_CNT_WORD_NUM,
		  -- DATA OUTPUS
		  po_modules_rst	 => reg_FSM_MODULES_RST,
		  po_key_ready		 => reg_FSM_KEY_READY,
		  po_word_cnt_en	 => reg_FSM_CNT_ENABLE,
		  po_word_cnt_rst	 => reg_FSM_CNT_RST,
		  -- to key_parser
		  po_previous_key_word_ctrl => reg_FSM_KEY_PARSER_PREVIOUS_KEY_WORD_CTRL,
		  po_new_key_word_we	    => reg_FSM_KEY_PARSER_NEW_KEY_WORD_WE,
		  po_key_parser_enable	    => reg_FSM_KEY_PARSER_EN,
		  -- to rot_word
		  po_rot_word_enable	 => reg_FSM_ROT_WORD_EN,
		  -- to sub_word
		  po_sub_word_enable	 => reg_FSM_SUB_WORD_EN,
		  po_sub_word_mux	 => reg_FSM_SUB_WORD_MUX,
		  -- to rcon
		  po_rcon_enable	 => reg_FSM_RCON_EN,
		  -- to xor
		  po_xor_enable		 => reg_FSM_XOR_EN,
		  po_xor_mux		 => reg_FSM_XOR_MUX
		 );
	
	CNT_8_60_1: cnt_8_60
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_CNT_RST,
		 pi_enable 	=> reg_FSM_CNT_ENABLE,
		 po_data	=> reg_CNT_WORD_NUM
		);
		
	KEY_PARSER_1: key_parser
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_MODULES_RST,
		 -- DATA INPUTS
		 pi_master_key		   => pi_master_key,
		 pi_new_key_word	   => reg_XOR_DATA,
		 pi_word_num	 	   => reg_CNT_WORD_NUM,
		 pi_previous_key_word_ctrl => reg_FSM_KEY_PARSER_PREVIOUS_KEY_WORD_CTRL,
		 pi_new_key_word_we	   => reg_FSM_KEY_PARSER_NEW_KEY_WORD_WE,
		 pi_enable		   => reg_FSM_KEY_PARSER_EN,
		 -- OUTPUTS
		 -- data output
		 po_current_key_word	   => reg_KEY_PARSER_CURRENT_KEY_WORD,
		 po_previous_key_word	   => reg_KEY_PARSER_PREVIOUS_KEY_WORD,
		 po_round_keys_array	   => w_KEY_PARSER_ROUND_KEY
		);

	
	ROT_WORD_1: rot_word
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_MODULES_RST,
		 -- DATA INPUTS
		 pi_data 	  => reg_ROT_WORD_INPUT_WORD,
		 pi_enable	  => reg_FSM_ROT_WORD_EN,
		 -- OUTPUTS
		 -- data output
		 po_rot_word_data => reg_ROT_WORD_DATA
		);	
	
	-- ROT WORD input mux
	reg_ROT_WORD_INPUT_WORD <= reg_KEY_PARSER_CURRENT_KEY_WORD when reg_CNT_WORD_NUM = "001000" else
				   reg_XOR_DATA;
	
	SUB_WORD_1: sub_word
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_MODULES_RST,
		 -- DATA INPUTS
		 pi_data 	  => reg_SUB_WORD_INPUT_WORD,
		 pi_enable	  => reg_FSM_SUB_WORD_EN,
		 -- OUTPUTS
		 -- data output
		 po_sub_word_data => reg_SUB_WORD_DATA
		);
	
	-- SUB WORD input mux
	reg_SUB_WORD_INPUT_WORD <= reg_ROT_WORD_DATA when reg_FSM_SUB_WORD_MUX = '0' else
				   reg_XOR_DATA;
				   
	RCON_1: rcon
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_MODULES_RST,
		 -- DATA INPUTS
		 pi_word_num	  => reg_CNT_WORD_NUM,
		 pi_data 	  => reg_SUB_WORD_DATA,
		 pi_enable	  => reg_FSM_RCON_EN,
		 -- OUTPUTS
		 -- data output
		 po_rcon_data	  => reg_RCON_DATA
		);
		
	XOR_1: xor_sync
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_MODULES_RST,
		 -- DATA INPUTS
		 pi_data_1	  => reg_XOR_INPUT_WORD,
		 pi_data_2	  => reg_KEY_PARSER_PREVIOUS_KEY_WORD,
		 pi_enable	  => reg_FSM_XOR_EN,
		 -- OUTPUTS
		 -- data output
		 po_xor_data	  => reg_XOR_DATA
		);
	
	-- XOR input mux
	reg_XOR_INPUT_WORD <= 	reg_RCON_DATA 	   when reg_FSM_XOR_MUX = "00" else
				reg_SUB_WORD_DATA  when reg_FSM_XOR_MUX = "01" else
				reg_XOR_DATA;
	
	-- Output assignments
	po_round_keys_array <= w_KEY_PARSER_ROUND_KEY;
	po_key_ready <= reg_FSM_KEY_READY;

end behavioral;