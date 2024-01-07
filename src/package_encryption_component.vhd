library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

package package_encryption_component is

component sub_bytes is
    port(
        pi_data : IN STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
        po_data : OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
    );
end component;

component shift_rows is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end component;

component mix_columns is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end component;

component add_round_key is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        pi_round_key : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end component;

component fsm_encryption is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_next_val_req : IN STD_LOGIC;
        pi_key_ready : IN STD_LOGIC;
        pi_round_num : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        po_next_val_ready : OUT STD_LOGIC;
        po_enc_done : OUT STD_LOGIC;
        po_round_cnt_en : OUT STD_LOGIC;
        po_round_cnt_rst : OUT STD_LOGIC;
        po_sub_bytes_en : OUT STD_LOGIC;
        po_shift_rows_en : OUT STD_LOGIC;
        po_mix_columns_en : OUT STD_LOGIC;
        po_add_round_key_en : OUT STD_LOGIC;
        po_add_round_key_mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0)
    );
end component;

component cnt_16 is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_mod_rst : IN STD_LOGIC;
        pi_enable : IN STD_LOGIC;
        po_data : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end component;

end package_encryption_component;
