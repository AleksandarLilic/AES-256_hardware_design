library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity fsm_encryption is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		
		-- data input
		pi_next_val_req	    : IN  STD_LOGIC;
		pi_key_ready        : IN  STD_LOGIC;
		pi_round_num	    : IN  STD_LOGIC_VECTOR(3 DOWNTO 0);
		
		-- OUTPUTS
		po_next_val_ready    : OUT STD_LOGIC;
		po_enc_done          : OUT STD_LOGIC;
		-- counter
		po_round_cnt_en      : OUT STD_LOGIC;
		po_round_cnt_rst     : OUT STD_LOGIC;
		-- sub_bytes
		po_sub_bytes_en      : OUT STD_LOGIC;
		-- shift_rows
		po_shift_rows_en     : OUT STD_LOGIC;
		-- mix_columns
		po_mix_columns_en    : OUT STD_LOGIC;
		-- add_round_key
		po_add_round_key_en  : OUT STD_LOGIC;
		po_add_round_key_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
	);
end fsm_encryption;

architecture behavioral of fsm_encryption is
-- Custom Types
type state is (idle, sub_bytes, shift_rows, mix_columns, add_round_key);
-- Signals
signal 	pr_state: state := idle;
signal 	nx_state: state := idle;

signal reg_NX_NEXT_VAL_READY       : STD_LOGIC:= '0';
signal reg_PR_NEXT_VAL_READY       : STD_LOGIC:= '0';
signal reg_PR_NEXT_VAL_READY_DEL_1 : STD_LOGIC:= '0';
signal reg_ENC_DONE          : STD_LOGIC:= '0';
signal reg_ENC_DONE_DEL_1    : STD_LOGIC:= '0';
signal reg_ROUND_CNT_EN      : STD_LOGIC:= '0';
signal reg_ROUND_CNT_RST     : STD_LOGIC:= '0';
signal reg_SUB_BYTES_EN      : STD_LOGIC:= '0';
signal reg_SHIFT_ROWS_EN     : STD_LOGIC:= '0';
signal reg_MIX_COLUMNS_EN    : STD_LOGIC:= '0';
signal reg_ADD_ROUND_KEY_EN  : STD_LOGIC:= '0';
signal reg_ADD_ROUND_KEY_MUX : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');

begin
	fsm_process: process(clk)
	begin 
		if(rising_edge(clk)) then
			pr_state <= nx_state;
		end if;
	end process;
	
	fsm_state_process: process(pr_state, pi_round_num, pi_next_val_req, pi_key_ready)
	begin
		nx_state <= pr_state;
		case(pr_state) is
			when idle =>
				if(pi_next_val_req = '1') then
					nx_state <= add_round_key;
				else
					nx_state <= idle;
				end if;
				
			when add_round_key =>
				if(pi_round_num < "1110") then
					nx_state <= sub_bytes;
				else
					nx_state <= idle;
				end if;
				
			when sub_bytes =>
				nx_state <= shift_rows;
				
			when shift_rows =>
				if(pi_round_num = "1110") then
					nx_state <= add_round_key;
				else
					nx_state <= mix_columns;
				end if;
				
			when mix_columns =>
				nx_state <= add_round_key;
				
			when others => NULL;
		end case;
			
		-- Unconditional reset
		if(pi_key_ready = '0') then
			nx_state <= idle;
		end if;
			
	end process;	
	
	fsm_output_process: process(pr_state, pi_round_num, pi_next_val_req, pi_key_ready)
	begin
		-- Default Values:
		reg_ROUND_CNT_EN      <= '0';
		reg_ROUND_CNT_RST     <= '0';
		reg_SUB_BYTES_EN      <= '0';
		reg_SHIFT_ROWS_EN     <= '0';
		reg_MIX_COLUMNS_EN    <= '0';
		reg_ADD_ROUND_KEY_EN  <= '0';
		reg_ENC_DONE          <= '0';
		reg_NX_NEXT_VAL_READY <= '0';
		
		case(pr_state) is
			when idle =>
				reg_ROUND_CNT_EN      <= '0';
				reg_ROUND_CNT_RST     <= '0';
				reg_SUB_BYTES_EN      <= '0';
				reg_SHIFT_ROWS_EN     <= '0';
				reg_MIX_COLUMNS_EN    <= '0';
				reg_ADD_ROUND_KEY_EN  <= '0';
				reg_ENC_DONE          <= '0';
				reg_NX_NEXT_VAL_READY <= '0';
				if(pi_next_val_req = '1') then
					reg_ROUND_CNT_RST     <= '1';
				end if;
				
			when add_round_key =>
				reg_ADD_ROUND_KEY_EN  <= '1';
				if(pi_round_num < "1110") then
					reg_ROUND_CNT_EN   <= '1';
					reg_ENC_DONE       <= '0';
					reg_ROUND_CNT_RST  <= '0';
					reg_NX_NEXT_VAL_READY <= reg_PR_NEXT_VAL_READY;
				else
					reg_ROUND_CNT_EN   <= '0';
					reg_ENC_DONE       <= '1';
					reg_ROUND_CNT_RST  <= '1';
					reg_NX_NEXT_VAL_READY <= '1';
				end if;
				
			when sub_bytes =>
				reg_SUB_BYTES_EN      <= '1';
				
			when shift_rows =>
				reg_SHIFT_ROWS_EN     <= '1';
				
			when mix_columns =>
				reg_MIX_COLUMNS_EN    <= '1';
				
			when others => NULL;
			
		end case;
	end process;
	
	add_round_key_mux_process: process (pi_round_num)
	begin
		case pi_round_num is
			when "0000" => reg_ADD_ROUND_KEY_MUX <= "00";
			when "1110" => reg_ADD_ROUND_KEY_MUX <= "10";
			when others => reg_ADD_ROUND_KEY_MUX <= "01";
		end case;
	end process;
	
	out_reg: process(clk)
	begin
		if(rising_edge(clk)) then
			reg_ENC_DONE_DEL_1 <= reg_ENC_DONE;
			reg_PR_NEXT_VAL_READY <= reg_NX_NEXT_VAL_READY;
			reg_PR_NEXT_VAL_READY_DEL_1 <= reg_PR_NEXT_VAL_READY;
		end if;
	end process;
	
	-- Output assignments
	po_next_val_ready    <= reg_PR_NEXT_VAL_READY_DEL_1;
	po_enc_done          <= reg_ENC_DONE_DEL_1;
	-- counter
	po_round_cnt_en      <= reg_ROUND_CNT_EN;
	po_round_cnt_rst     <= reg_ROUND_CNT_RST;
	-- sub_bytes
	po_sub_bytes_en      <= reg_SUB_BYTES_EN;
	-- shift_rows
	po_shift_rows_en     <= reg_SHIFT_ROWS_EN;
	-- mix_columns
	po_mix_columns_en    <= reg_MIX_COLUMNS_EN;
	-- add_round_key
	po_add_round_key_en  <= reg_ADD_ROUND_KEY_EN;
	po_add_round_key_mux <= reg_ADD_ROUND_KEY_MUX;

end behavioral;
