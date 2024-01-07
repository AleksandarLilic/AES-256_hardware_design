library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_AES256_COMPONENT.all;

entity aes256 is
    port(
        -- system
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        -- data input
        pi_key_expand_start : IN STD_LOGIC;
        pi_master_key : IN STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
        -- data output
        po_key_ready : OUT STD_LOGIC;
        -- data input
        pi_next_val_req : IN STD_LOGIC;
        pi_data : IN STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
        -- data output
        po_next_val_ready : OUT STD_LOGIC;
        po_data : OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
    );
end aes256;

architecture behavioral of aes256 is

signal w_KEY_EXP_ROUND_KEYS_ARRAY : t_ROUND_KEYS;
signal reg_KEY_EXP_KEY_READY : STD_LOGIC;

signal reg_DATA_ENC_NEXT_VAL_READY : STD_LOGIC;
signal reg_DATA_ENC_DATA : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);

begin
    KEY_EXPANSION_TOP_1: key_expansion_top
        port map(
            clk => clk,
            rst => rst,
            pi_key_expand_start => pi_key_expand_start,
            pi_master_key => pi_master_key,
            po_round_keys_array => w_KEY_EXP_ROUND_KEYS_ARRAY,
            po_key_ready => reg_KEY_EXP_KEY_READY
        );
    
    ENCRYPTION_TOP_1: encryption_top
        port map(
            clk => clk,
            rst => rst,
            pi_data => pi_data,
            pi_round_keys_array => w_KEY_EXP_ROUND_KEYS_ARRAY,
            pi_next_val_req => pi_next_val_req,
            pi_key_ready => reg_KEY_EXP_KEY_READY,
            po_next_val_ready => reg_DATA_ENC_NEXT_VAL_READY,
            po_data => reg_DATA_ENC_DATA
        );

    po_key_ready <= reg_KEY_EXP_KEY_READY;
    po_next_val_ready <= reg_DATA_ENC_NEXT_VAL_READY;
    po_data <= reg_DATA_ENC_DATA;
    
end behavioral;
