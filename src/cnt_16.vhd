library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;

entity cnt_16 is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_mod_rst : IN STD_LOGIC;
        pi_enable : IN STD_LOGIC;
        po_data : OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
end cnt_16;

architecture behavioral of cnt_16 is
signal reg_COUNTER : STD_LOGIC_VECTOR(3 DOWNTO 0);

begin
    cnt_16_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_COUNTER <= "0000";
            elsif (pi_mod_rst = '1') then
                reg_COUNTER <= "0000";
            elsif (pi_enable = '1') then
                reg_COUNTER <= STD_LOGIC_VECTOR(UNSIGNED(reg_COUNTER)+1);
            end if;
        end if;
    end process;

    po_data <= reg_COUNTER;

end behavioral;
