library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

package package_aes256_loading_component is

component aes256 is
	port(
		-- system
		clk : IN  STD_LOGIC;
		
		---- KEY MANAGEMENT ---
		-- data input
		pi_key_expand_start : IN  STD_LOGIC;
		pi_master_key	    : IN  STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
		-- data output
		po_key_ready	    : OUT STD_LOGIC;
		
		---- ENCRYPTION ----
		-- data input
		pi_next_val_req	    : IN  STD_LOGIC;
		pi_data		    : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		-- data output
		po_next_val_ready   : OUT STD_LOGIC;
		po_data		    : OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
	);
end component;

component data_loading is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		rst : IN  STD_LOGIC;
		
		-- data input
		pi_data		  : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		pi_next_aes_ready : IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_next_val_ready : OUT  STD_LOGIC;
		po_data	: OUT STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0)		
	);
end component;
end package_aes256_loading_component;