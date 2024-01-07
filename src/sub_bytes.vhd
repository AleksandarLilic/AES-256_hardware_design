library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_ENCRYPTION_LUT.all;

entity sub_bytes is
    port(
        pi_data : IN STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
        po_data : OUT STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0)
    );
end sub_bytes;

architecture behavioral of sub_bytes is

signal w_DATA_OUT : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
begin
    generate_luts: for i in 0 to 15 generate
        SBOX_i: lut_sbox
             port map(
                pi_address => pi_data(c_BYTE(i) downto c_BYTE(i)-7),
                po_data=> w_DATA_OUT(c_BYTE(i) downto c_BYTE(i)-7)
             );
    end generate;
    
    po_data <= w_DATA_OUT;
    
end behavioral;
