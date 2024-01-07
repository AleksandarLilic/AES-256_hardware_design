library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity add_round_key is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        pi_round_key : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end add_round_key;

architecture behavioral of add_round_key is

signal w_DATA_OUT : STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
begin
    generate_key_xor: for i in 0 to 15 generate
        w_DATA_OUT (c_BYTE(i)-7 to c_BYTE(i)) <= pi_data(c_BYTE(i)-7 to c_BYTE(i)) xor
                                                 pi_round_key(c_BYTE(i)-7 to c_BYTE(i));
    end generate;
    
    po_data <= w_DATA_OUT;
    
end behavioral;
