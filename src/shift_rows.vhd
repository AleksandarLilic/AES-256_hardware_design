library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity shift_rows is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end shift_rows;

architecture behavioral of shift_rows is
signal w_DATA_OUT : STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);

begin
    generate_shift: for i in 0 to 15 generate
        w_DATA_OUT(c_BYTE(i)-7 to c_BYTE(i)) <= pi_data(c_SHIFT_ROWS_INDEX(i)-7 to c_SHIFT_ROWS_INDEX(i));
    end generate;
    
    po_data <= w_DATA_OUT;
    
end behavioral;
