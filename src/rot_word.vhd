library IEEE;
use IEEE.STD_LOGIC_1164.all;
use WORK.MATRIX_CONST.all;

entity rot_word is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_mod_rst : IN STD_LOGIC; -- reset signal for the module
        pi_data : IN STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0); -- word to be rotated
        pi_enable : IN STD_LOGIC; -- signal to start rotation
        po_rot_word_data : OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0) -- rotated word
    );
end rot_word;

architecture behavioral of rot_word is
signal reg_ROT_WORD : STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0); -- stores rotated word in rot_word_process
begin
    rot_word_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_ROT_WORD <= (others => '0');
            elsif (pi_mod_rst = '1') then
                reg_ROT_WORD <= (others => '0');
            elsif (pi_enable = '1') then
                reg_ROT_WORD <= pi_data (23 DOWNTO 0) & pi_data (31 DOWNTO 24);
            end if;
        end if;
    end process;
    
    -- data assignment to the output ports
    po_rot_word_data <= reg_ROT_WORD;

end behavioral;
