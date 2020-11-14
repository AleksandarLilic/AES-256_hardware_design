library IEEE;
use IEEE.STD_LOGIC_1164.all;

package MATRIX_CONST is

	-- Matrix BYTE access
	-- BYTE Width
	constant BYTE_WIDTH : INTEGER := 8;
	-- BYTE ranges
	constant B0  : INTEGER := 7;
	constant B1  : INTEGER := 15;
	constant B2  : INTEGER := 23;
	constant B3  : INTEGER := 31;
	constant B4  : INTEGER := 39;
	constant B5  : INTEGER := 47;
	constant B6  : INTEGER := 55;
	constant B7  : INTEGER := 63;
	constant B8  : INTEGER := 71;
	constant B9  : INTEGER := 79;
	constant B10 : INTEGER := 87;
	constant B11 : INTEGER := 95;
	constant B12 : INTEGER := 103;
	constant B13 : INTEGER := 111;
	constant B14 : INTEGER := 119;
	constant B15 : INTEGER := 127;
	 
	-- Matrix WORD access
	-- WORD Width
	constant WORD_WIDTH : INTEGER := 32;
	-- WORD ranges
	constant W0 : INTEGER := 31;
	constant W1 : INTEGER := 63;
	constant W2 : INTEGER := 95;
	constant W3 : INTEGER := 127;
	constant W4 : INTEGER := 159;
	constant W5 : INTEGER := 191;
	constant W6 : INTEGER := 223;
	constant W7 : INTEGER := 255;
	-- to access a word within a matrix 
	-- foo_00 <= MATRIX_STATE(W0-1 downto 0);
	-- foo_10 <= MATRIX_STATE(W1-1 downto W0);	
	
	-- Matrix Data Length
	constant MATRIX_DATA_WIDTH 	 : INTEGER := 128;
	
	-- Matrix Round Key Length
	constant MATRIX_ROUND_KEY_WIDTH  : INTEGER := 128;
	
	-- Matrix Key Length
	constant MATRIX_KEY_WIDTH 	 : INTEGER := 256;
	
	-- Number of transformation rounds
	-- Initial + 13 Main + Final = 15
	constant N_ROUNDS  : INTEGER := 15;
	
	-- User defined types
	type BYTE_ACCESS		 is array (15 DOWNTO 0) of INTEGER range 0 TO 127;
	constant c_BYTE : BYTE_ACCESS := (B15, B14, B13, B12, B11, B10, B9, B8, 
					   B7,  B6,  B5,  B4,  B3,  B2, B1, B0);
	constant c_SHIFT_ROWS_INDEX : BYTE_ACCESS := (B11,  B6, B1, B12,  B7,  B2, B13, B8, 
						       B3, B14, B9,  B4, B15, B10,  B5, B0);
	type WORD_ACCESS		 is array ( 7 DOWNTO 0) of INTEGER range 0 TO 255;
	constant c_WORD : WORD_ACCESS := (W7, W6, W5, W4, W3, W2, W1, W0);
	
	type t_KEY_WORDS_MASTER is array (0 to  7) of STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
	type t_KEY_WORDS_EXP    is array (8 to 59) of STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
	type t_ROUND_KEYS       is array (0 to 14) of STD_LOGIC_VECTOR(MATRIX_ROUND_KEY_WIDTH-1 DOWNTO 0);
	
end MATRIX_CONST;

