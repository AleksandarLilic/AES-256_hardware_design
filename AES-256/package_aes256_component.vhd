library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

package package_aes256_component is

component key_expansion_top is
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
end component;

component encryption_top is
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
end component;
end package_aes256_component;