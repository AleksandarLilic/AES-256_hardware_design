library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

package package_encryption_component is

component sub_bytes is
	port(	
		-- INPUTS
		-- data input
		pi_data		: IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		-- OUTPUTS
		-- data output
		po_data		: OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
	);
end component;

component shift_rows is
	port(	
		-- INPUTS
		-- data input
		pi_data		: IN  STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
		-- OUTPUTS
		-- data output
		po_data		: OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
	);
end component;

component mix_columns is
	port(	
		-- INPUTS
		-- data input
		pi_data		: IN  STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
		-- OUTPUTS
		-- data output
		po_data		: OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
	);
end component;

component add_round_key is
	port(	
		-- INPUTS
		-- data input
		pi_data		: IN  STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
		pi_round_key	: IN  STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
		-- OUTPUTS
		-- data output
		po_data		: OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
	);
end component;

component fsm_encryption is
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
end component;

component cnt_16 is
	port(	
		-- INPUTS
		-- system
		clk		: IN  STD_LOGIC;
		rst		: IN  STD_LOGIC;
		
		-- data input
		pi_enable	: IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_data		: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
end component;

end package_encryption_component;