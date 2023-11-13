library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity fsm_key_expansion is
	port(	
		-- INPUTS
		-- system
		clk			: IN  STD_LOGIC;
		
		-- data input
		pi_key_expand_start	: IN  STD_LOGIC;
		pi_word_num	 	: IN  STD_LOGIC_VECTOR(5 DOWNTO 0);
		
		-- OUTPUTS
		po_modules_rst		: OUT STD_LOGIC;
		po_key_ready	 	: OUT STD_LOGIC;
		po_word_cnt_en	 	: OUT STD_LOGIC;
		po_word_cnt_rst	 	: OUT STD_LOGIC;
		-- to key_parser
		po_previous_key_word_ctrl : OUT STD_LOGIC;
		po_new_key_word_we	  : OUT STD_LOGIC;
		po_key_parser_enable	  : OUT STD_LOGIC;
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
end fsm_key_expansion;

architecture behavioral of fsm_key_expansion is
-- Custom Types
type state is (idle, key_parser, rot_word, sub_word, rcon, xor_we);
-- Signals
signal pr_state: state := idle;
signal nx_state: state := idle;

signal w_KEY_EXPAND_START_SQ	 : STD_LOGIC:= '0';
signal reg_SEQ			 : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');

signal reg_KEY_READY		 : STD_LOGIC:= '0';
signal reg_KEY_READY_DEL_1	 : STD_LOGIC:= '0';
signal reg_WORD_CNT_EN		 : STD_LOGIC:= '0';
signal reg_WORD_CNT_RST		 : STD_LOGIC:= '0';
signal reg_PREVIOUS_KEY_WORD_CTRL: STD_LOGIC:= '0';
signal reg_KEY_PARSER_WE	 : STD_LOGIC:= '0';
signal reg_KEY_PARSER_WE_DEL_1	 : STD_LOGIC:= '0';
signal reg_KEY_PARSER_ENABLE	 : STD_LOGIC:= '0';
signal reg_ROT_WORD_ENABLE	 : STD_LOGIC:= '0';
signal reg_SUB_WORD_ENABLE	 : STD_LOGIC:= '0';
signal reg_SUB_WORD_MUX		 : STD_LOGIC:= '0';
signal reg_RCON_ENABLE		 : STD_LOGIC:= '0';
signal reg_XOR_ENABLE		 : STD_LOGIC:= '0';
signal reg_XOR_MUX		 : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');
signal reg_MODULES_RST  	 : STD_LOGIC:= '0';

begin
	fsm_process: process(clk)
	begin 
		if(rising_edge(clk)) then
			pr_state <= nx_state;
		end if;
	end process;
	
	fsm_state_process: process(pr_state, pi_word_num, 
                                   w_KEY_EXPAND_START_SQ, pi_key_expand_start)
	begin
		nx_state <= pr_state;
		case(pr_state) is
			when idle =>
				if(w_KEY_EXPAND_START_SQ = '1') then
					nx_state <= key_parser;
				else
					nx_state <= idle;
				end if;
				
			when key_parser =>
				nx_state <= rot_word;
				 
			when rot_word =>
				nx_state <= sub_word;
				 
			when sub_word =>
				if   (pi_word_num(2 DOWNTO 0) = "000") then
					nx_state <= rcon;
				else
					nx_state <= xor_we;
				end if;
			
			when rcon =>
				nx_state <= xor_we;
			
			when xor_we =>
				if   (pi_word_num = "111100") then
					nx_state <= idle;
				elsif(STD_LOGIC_VECTOR(UNSIGNED(pi_word_num(2 DOWNTO 0))+1) = "000") then
					nx_state <= rot_word;
				elsif(STD_LOGIC_VECTOR(UNSIGNED(pi_word_num(2 DOWNTO 0))+1) = "100") then
					nx_state <= sub_word;
				else
					nx_state <= xor_we;
				end if;
				
			when others => NULL;
				
		end case;
		
		-- Unconditional reset
		if(pi_key_expand_start = '1') then
                        nx_state <= idle;
                end if;
	end process;
	
	fsm_output_process: process(pr_state, pi_word_num, 
				    w_KEY_EXPAND_START_SQ, pi_key_expand_start)
	begin
		-- Default Values:
		reg_WORD_CNT_EN  <= '0';
		reg_WORD_CNT_RST <= '0';
		reg_PREVIOUS_KEY_WORD_CTRL <= '0';
		reg_KEY_PARSER_WE	   <= '0';
		reg_KEY_PARSER_ENABLE      <= '0';
		reg_ROT_WORD_ENABLE 	<= '0';
		reg_SUB_WORD_ENABLE 	<= '0';
		reg_SUB_WORD_MUX	<= '0';
		reg_RCON_ENABLE		<= '0';
		reg_XOR_ENABLE		<= '0';
		reg_KEY_READY 		<= '0';
		reg_XOR_MUX		<= "00";
		reg_MODULES_RST 	<= '0';
		
		case(pr_state) is
			when idle =>
				if(w_KEY_EXPAND_START_SQ = '1') then
					reg_WORD_CNT_RST <= '1';
					reg_KEY_PARSER_ENABLE 	<= '1';
					reg_MODULES_RST <= '1';
				else
					if   (pi_word_num = "111100") then
						reg_KEY_READY 	<= '1';
					end if;
				end if;
			
			when key_parser =>
				reg_KEY_PARSER_ENABLE 	<= '1';
			
			when rot_word =>
				reg_ROT_WORD_ENABLE 	<= '1';
				reg_KEY_PARSER_ENABLE 	<= '1';
			
			when sub_word =>
				reg_SUB_WORD_ENABLE      <= '1';
				reg_KEY_PARSER_ENABLE    <= '1';
				if(pi_word_num(2 DOWNTO 0) = "000") then
					reg_SUB_WORD_MUX <= '0';
				else
					reg_SUB_WORD_MUX <= '1';
				end if;
			
			when rcon =>
                                reg_RCON_ENABLE	<= '1';
				reg_KEY_PARSER_ENABLE 	<= '1';
			
			when xor_we =>
				reg_KEY_PARSER_ENABLE 	   <= '1';
				reg_WORD_CNT_EN 	   <= '1';
				reg_PREVIOUS_KEY_WORD_CTRL <= '1';
				reg_KEY_PARSER_WE	   <= '1';
				if(pi_word_num < "111100") then
					reg_XOR_ENABLE		<= '1';
					if   (pi_word_num(2 DOWNTO 0) = "000") then
						reg_XOR_MUX	<= "00";
					elsif(pi_word_num(2 DOWNTO 0) = "100") then
						reg_XOR_MUX	<= "01";
					else
						reg_XOR_MUX	<= "10";
					end if;
				end if;
				
			when others => NULL;
				
		end case;
	end process;
	
	key_ready_sequence_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reg_MODULES_RST = '1') then
				reg_SEQ <= (others => '0');
			else
				reg_SEQ <= reg_SEQ(0) & pi_key_expand_start;
			end if;
		end if;
	end process;
	
	-- sequence detection
	w_KEY_EXPAND_START_SQ <=  '1' when reg_SEQ = "10" else
				  '0';
	
	new_key_word_we_del_1_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reg_MODULES_RST = '1') then
				reg_KEY_PARSER_WE_DEL_1 <= '0';
			else
				reg_KEY_PARSER_WE_DEL_1 <= reg_KEY_PARSER_WE;
			end if;
		end if;
	end process;
	
	
	key_ready_del_1_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reg_MODULES_RST = '1') then
				reg_KEY_READY_DEL_1 <= '0';
			else
				reg_KEY_READY_DEL_1 <= reg_KEY_READY;
			end if;
		end if;
	end process;
	
	-- Output assignments
	po_modules_rst 		<= reg_MODULES_RST;
	po_word_cnt_en 		<= reg_WORD_CNT_EN;
	po_word_cnt_rst		<= reg_WORD_CNT_RST;
	po_key_ready		<= reg_KEY_READY_DEL_1;
	-- to key_parser
	po_previous_key_word_ctrl<= reg_PREVIOUS_KEY_WORD_CTRL;
	po_new_key_word_we	<= reg_KEY_PARSER_WE_DEL_1;
	po_key_parser_enable	<= reg_KEY_PARSER_ENABLE;
	-- to rot_word
	po_rot_word_enable	<= reg_ROT_WORD_ENABLE;
	-- to sub_word
	po_sub_word_enable	<= reg_SUB_WORD_ENABLE;
	po_sub_word_mux		<= reg_SUB_WORD_MUX;
	-- to rcon
	po_rcon_enable		<= reg_RCON_ENABLE;
	-- to xor
	po_xor_enable		<= reg_XOR_ENABLE;
	po_xor_mux		<= reg_XOR_MUX;
	
end behavioral;