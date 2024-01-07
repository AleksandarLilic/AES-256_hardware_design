library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity cnt_8_60 is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_cnt_rst : IN STD_LOGIC;
        pi_enable : IN STD_LOGIC;
        po_data : OUT STD_LOGIC_VECTOR(5 DOWNTO 0)
    );
end cnt_8_60;

architecture behavioral of cnt_8_60 is
signal reg_COUNTER : STD_LOGIC_VECTOR(5 DOWNTO 0);
signal w_OF : STD_LOGIC;
signal w_CNT_CHECK: STD_LOGIC;

begin
    cnt_8_60_process: process(clk)
    begin
        if(rising_edge(clk)) then
            if (rst = '1') then
                reg_COUNTER <= "001000"; -- equals to d'8
            elsif (pi_cnt_rst = '1') then
                reg_COUNTER <= "001000";
            elsif (w_CNT_CHECK = '1') then
                reg_COUNTER <= STD_LOGIC_VECTOR(UNSIGNED(reg_COUNTER)+1);
            end if;
        end if;
    end process;
    
    -- counter overflow
    w_OF <= '1' when reg_COUNTER = "111100" else
            '0';
    -- counter local enable
    w_CNT_CHECK <= not w_OF and pi_enable;
    
    -- output
    po_data <= reg_COUNTER;

end behavioral;
