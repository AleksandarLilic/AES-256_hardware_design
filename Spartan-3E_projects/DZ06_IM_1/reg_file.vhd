  LIBRARY IEEE;
  USE IEEE.STD_LOGIC_1164.ALL;
  USE IEEE.NUMERIC_STD.ALL;
 -- registarski fajl 64x8 -------------------------------------------------
 ENTITY reg_file IS                                     
   PORT(clk, rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        w_addr, r_addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        w_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        r_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
 END reg_file;
 --------------------------------------------------------------------------
 ARCHITECTURE arch OF reg_file IS
   TYPE reg_file_type IS ARRAY(0 TO 63) OF STD_LOGIC_VECTOR(7 DOWNTO 0);
   SIGNAL array_reg : reg_file_type;
 BEGIN               
   -- upis
   PROCESS(clk, rst)
   BEGIN
     IF(rst = '1') THEN
       array_reg <= (OTHERS => (OTHERS => '0'));
     ELSIF(clk'event AND clk = '1') THEN        
       IF(we = '1') THEN
         array_reg(TO_INTEGER(UNSIGNED(w_addr))) <= w_data;
       END IF;
     END IF;
   END PROCESS;                                           
   -- port za citanje
   r_data <= array_reg(TO_INTEGER(UNSIGNED(r_addr)));
 END arch;