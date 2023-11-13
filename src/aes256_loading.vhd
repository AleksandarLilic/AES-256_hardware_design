library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_AES256_LOADING_COMPONENT.all;

entity aes256_loading is
        port(
                -- SYSTEM
                clk : IN  STD_LOGIC;
                -- KEY MANAGEMENT
                pi_key_expand_start : IN  STD_LOGIC;    -- External request for key expansion start
                pi_master_key       : IN  STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0); -- Data line for 256bit master key
                po_key_ready        : OUT STD_LOGIC;    -- Control signal, low during expansion, high when expansion is completed
                -- INPUT DATA
                pi_data : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);    -- Data line for 128bit plaintext input 
                -- ENCRYPTION DATA
                pi_next_val_req   : IN  STD_LOGIC;      -- External request for next encrypted value
                po_next_val_ready : OUT STD_LOGIC;      -- Next enxrypted value is ready, high for each new 8bit value on output
                po_data		  : OUT STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0)  -- Data line for 8bit packets of 128bit ciphertext
        );
end aes256_loading;

architecture behavioral of aes256_loading is

signal reg_AES256_DATA    : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_NEXT_AES_READY : STD_LOGIC := '0';

begin

	AES256_1: aes256
		port map
		(clk => clk,
		 -- KEY MANAGEMENT
		 pi_key_expand_start  => pi_key_expand_start,
		 pi_master_key	      => pi_master_key,
		 po_key_ready         => po_key_ready,
		 -- INPUT DATA
		 pi_data => pi_data,
		 -- ENCRYPTED DATA
		 pi_next_val_req    => pi_next_val_req,
		 po_next_val_ready  => reg_NEXT_AES_READY,
		 po_data            => reg_AES256_DATA
		);
	
	DATA_LOADING_1: data_loading
		port map
		(clk => clk,
		 rst => pi_key_expand_start,
		 -- data input		 
		 pi_data => reg_AES256_DATA,
		 pi_next_aes_ready => reg_NEXT_AES_READY,
		 -- OUTPUTS
		 po_next_val_ready => po_next_val_ready,
		 po_data           => po_data
		);
	
-- 	po_next_val_ready <= reg_NEXT_AES_READY;
	
end behavioral;