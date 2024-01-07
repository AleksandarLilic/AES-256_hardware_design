library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity xor_sync is
    port(
        clk: IN STD_LOGIC;
        rst: IN STD_LOGIC;
        pi_mod_rst: IN STD_LOGIC;
        pi_data_1: IN STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
        pi_data_2: IN STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
        pi_enable: IN STD_LOGIC;
        po_xor_data: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0)
    );
end xor_sync;

architecture behavioral of xor_sync is
signal reg_DATA_1 : STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);

begin
    xor_sync_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                po_xor_data<= (others => '0');
            elsif (pi_mod_rst = '1') then
                po_xor_data <= (others => '0');
            elsif (pi_enable = '1') then
                po_xor_data <= reg_DATA_1;
            end if;
        end if;
    end process;
    
    reg_DATA_1 <= pi_data_1 xor pi_data_2;

end behavioral;
