library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_ENCRYPTION_LUT.all;
use WORK.PACKAGE_ENCRYPTION_COMPONENT.all;

entity encryption_top is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		
		-- data input
		pi_data		    : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		pi_round_keys_array : IN  t_ROUND_KEYS;
		pi_next_val_req	    : IN  STD_LOGIC;
		pi_key_ready        : IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_next_val_ready : OUT STD_LOGIC;
		po_data		  : OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
	);
end encryption_top;

architecture behavioral of encryption_top is

-- FSM
signal reg_FSM_NEXT_VAL_READY    : STD_LOGIC := '0';
signal reg_FSM_ENC_DONE          : STD_LOGIC := '0';

signal reg_FSM_ROUND_CNT_EN      : STD_LOGIC := '0';
signal reg_FSM_ROUND_CNT_RST     : STD_LOGIC := '0';

signal reg_FSM_SUB_BYTES_EN      : STD_LOGIC := '0';
signal reg_FSM_SHIFT_ROWS_EN     : STD_LOGIC := '0';
signal reg_FSM_MIX_COLUMNS_EN    : STD_LOGIC := '0';
signal reg_FSM_ADD_ROUND_KEY_EN  : STD_LOGIC := '0';
signal reg_FSM_ADD_ROUND_KEY_MUX : STD_LOGIC_VECTOR(1 DOWNTO 0) := (others => '0');

-- COUNTER
signal reg_CNT_ROUND_NUM      : STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');

-- SUB BYTES
signal reg_SUB_BYTES_DATA     : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_SUB_BYTES_DATA       : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');

-- SHIFT ROWS
signal reg_SHIFT_ROWS_DATA    : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_SHIFT_ROWS_DATA      : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');

-- MIX COLUMNS
signal reg_MIX_COLUMNS_DATA   : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_MIX_COLUMNS_DATA     : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');

-- ADD ROUND KEY
signal reg_ADD_ROUND_KEY_DATA : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_ADD_ROUND_KEY_DATA   : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_ADD_ROUND_KEY_INPUT_MUX  : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');
signal w_ADD_ROUND_KEY_INPUT_KEY  : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0):= (others => '0');

begin
	
	FSM_ENCRYPTION_1: fsm_encryption
		port map
		(clk	=> clk,
		 -- data input
		 pi_next_val_req  => pi_next_val_req,
		 pi_key_ready     => pi_key_ready,
		 pi_round_num	  => reg_CNT_ROUND_NUM,
		 
		 -- OUTPUTS
		 po_next_val_ready    => reg_FSM_NEXT_VAL_READY,
		 po_enc_done          => reg_FSM_ENC_DONE,
		 -- counter
		 po_round_cnt_en      => reg_FSM_ROUND_CNT_EN,
		 po_round_cnt_rst     => reg_FSM_ROUND_CNT_RST,
		 -- sub_bytes
		 po_sub_bytes_en      => reg_FSM_SUB_BYTES_EN,
		 -- shift_rows
		 po_shift_rows_en     => reg_FSM_SHIFT_ROWS_EN,
		 -- mix_columns
		 po_mix_columns_en    => reg_FSM_MIX_COLUMNS_EN,
		 -- add_round_key
		 po_add_round_key_en  => reg_FSM_ADD_ROUND_KEY_EN,
		 po_add_round_key_mux => reg_FSM_ADD_ROUND_KEY_MUX
		);
		
	CNT_16_1: cnt_16
		port map
		(clk	=> clk,
		 rst	=> reg_FSM_ROUND_CNT_RST,
		 pi_enable 	=> reg_FSM_ROUND_CNT_EN,
		 po_data	=> reg_CNT_ROUND_NUM
		);
	
--- SUB BYTES
	SUB_BYTES_1: sub_bytes
		port map
		(pi_data	=> reg_ADD_ROUND_KEY_DATA,
		 po_data	=> w_SUB_BYTES_DATA
		);
	
	sub_bytes_reg_process: process(clk)
	begin
		if(rising_edge(clk))then
			if(reg_FSM_SUB_BYTES_EN = '1') then
				reg_SUB_BYTES_DATA <= w_SUB_BYTES_DATA;
			end if;
		end if;
	end process;
	
--- SHIFT ROWS
	SHIFT_ROWS_1: shift_rows
		port map
		(pi_data	=> reg_SUB_BYTES_DATA,
		 po_data	=> w_SHIFT_ROWS_DATA
		);
	
	shift_rows_reg_process: process(clk)
	begin
		if(rising_edge(clk))then
			if(reg_FSM_SHIFT_ROWS_EN = '1') then
				reg_SHIFT_ROWS_DATA <= w_SHIFT_ROWS_DATA;
			end if;
		end if;
	end process;

--- MIX COLUMNS
	MIX_COLUMNS_1: mix_columns
		port map
		(pi_data	=> reg_SHIFT_ROWS_DATA,
		 po_data	=> w_MIX_COLUMNS_DATA
		);
	
	mix_columns_reg_process: process(clk)
	begin
		if(rising_edge(clk))then
			if(reg_FSM_MIX_COLUMNS_EN = '1') then
				reg_MIX_COLUMNS_DATA <= w_MIX_COLUMNS_DATA;
			end if;
		end if;
	end process;	

--- ADD ROUND KEY
	add_round_key_input_mux_process: process (reg_FSM_ADD_ROUND_KEY_MUX,
				pi_data, reg_SHIFT_ROWS_DATA, reg_MIX_COLUMNS_DATA)
	begin
		case reg_FSM_ADD_ROUND_KEY_MUX is
			when "00"   => w_ADD_ROUND_KEY_INPUT_MUX <= pi_data;
			when "10"   => w_ADD_ROUND_KEY_INPUT_MUX <= reg_SHIFT_ROWS_DATA;
			when others => w_ADD_ROUND_KEY_INPUT_MUX <= reg_MIX_COLUMNS_DATA;
		end case;
	end process;
	
	w_ADD_ROUND_KEY_INPUT_KEY <= pi_round_keys_array(to_integer(UNSIGNED(reg_CNT_ROUND_NUM)));
	
	ADD_ROUND_KEY_1: add_round_key
		port map
		(pi_data	=> w_ADD_ROUND_KEY_INPUT_MUX,
		 pi_round_key   => w_ADD_ROUND_KEY_INPUT_KEY,
		 po_data	=> w_ADD_ROUND_KEY_DATA
		);
	
	add_round_key_reg_process: process(clk)
	begin
		if(rising_edge(clk))then
			if(reg_FSM_ADD_ROUND_KEY_EN = '1') then
				reg_ADD_ROUND_KEY_DATA <= w_ADD_ROUND_KEY_DATA;
			end if;
		end if;
	end process;

--- DATA OUTPUT PROCESS
	data_out_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reg_FSM_ENC_DONE = '1') then
				po_data <= reg_ADD_ROUND_KEY_DATA;
			end if;
		end if;
	end process;
	
	po_next_val_ready <= reg_FSM_NEXT_VAL_READY;
end behavioral;