library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;
use WORK.PACKAGE_ENCRYPTION_LUT.all;

entity mix_columns is
    port(
        pi_data : IN STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
        po_data : OUT STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1)
    );
end mix_columns;

architecture behavioral of mix_columns is

signal w_DATA_MUL2: STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
signal w_DATA_MUL3: STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);
signal w_DATA_OUT: STD_LOGIC_VECTOR(0 TO MATRIX_DATA_WIDTH-1);

begin
    generate_luts_mul2: for i in 0 to 15 generate
        MUL2_i: lut_mul2
             port map(
                pi_address => pi_data(c_BYTE(i)-7 TO c_BYTE(i)),
                po_data => w_DATA_MUL2(c_BYTE(i)-7 TO c_BYTE(i))
             );
    end generate;
    
    generate_luts_mul3: for i in 0 to 15 generate
        MUL2_i: lut_mul3
             port map(
                pi_address => pi_data(c_BYTE(i)-7 TO c_BYTE(i)),
                po_data => w_DATA_MUL3(c_BYTE(i)-7 TO c_BYTE(i))
             );
    end generate;
    
    generate_outputs: for i in 0 to 3 generate
        w_DATA_OUT(c_BYTE(i*4)-7 TO c_BYTE(i*4)) <= w_DATA_MUL2(c_BYTE(i*4)-7 TO c_BYTE(i*4)) xor
                                                    w_DATA_MUL3(c_BYTE(i*4+1)-7 TO c_BYTE(i*4+1)) xor
                                                    pi_data(c_BYTE(i*4+2)-7 TO c_BYTE(i*4+2)) xor
                                                    pi_data(c_BYTE(i*4+3)-7 TO c_BYTE(i*4+3));
            
        w_DATA_OUT(c_BYTE(i*4+1)-7 TO c_BYTE(i*4+1)) <= pi_data(c_BYTE(i*4)-7 TO c_BYTE(i*4)) xor
                                                        w_DATA_MUL2(c_BYTE(i*4+1)-7 TO c_BYTE(i*4+1)) xor
                                                        w_DATA_MUL3(c_BYTE(i*4+2)-7 TO c_BYTE(i*4+2)) xor
                                                        pi_data(c_BYTE(i*4+3)-7 TO c_BYTE(i*4+3));
            
        w_DATA_OUT(c_BYTE(i*4+2)-7 TO c_BYTE(i*4+2)) <= pi_data(c_BYTE(i*4)-7 TO c_BYTE(i*4)) xor
                                                        pi_data(c_BYTE(i*4+1)-7 TO c_BYTE(i*4+1)) xor
                                                        w_DATA_MUL2(c_BYTE(i*4+2)-7 TO c_BYTE(i*4+2)) xor
                                                        w_DATA_MUL3(c_BYTE(i*4+3)-7 TO c_BYTE(i*4+3));
            
        w_DATA_OUT(c_BYTE(i*4+3)-7 TO c_BYTE(i*4+3)) <= w_DATA_MUL3(c_BYTE(i*4)-7 TO c_BYTE(i*4)) xor
                                                        pi_data(c_BYTE(i*4+1)-7 TO c_BYTE(i*4+1)) xor
                                                        pi_data(c_BYTE(i*4+2)-7 TO c_BYTE(i*4+2)) xor
                                                        w_DATA_MUL2(c_BYTE(i*4+3)-7 TO c_BYTE(i*4+3));
    end generate;
    
    po_data <= w_DATA_OUT;
    
end behavioral;
