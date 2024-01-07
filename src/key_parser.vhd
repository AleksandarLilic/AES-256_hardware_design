library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity key_parser is
    port(
        clk : IN STD_LOGIC;
        rst : IN STD_LOGIC;
        pi_mod_rst : IN STD_LOGIC;
        pi_master_key : IN STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
        pi_new_key_word : IN STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
        pi_word_num : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        pi_previous_key_word_ctrl : IN STD_LOGIC;
        pi_new_key_word_we : IN STD_LOGIC;
        pi_enable : IN STD_LOGIC;
        po_current_key_word: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
        po_previous_key_word: OUT STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
        po_round_keys_array: OUT t_ROUND_KEYS
    );
end key_parser;

architecture behavioral of key_parser is
-- Signals
signal reg_KEY_WORDS_MASTER_ARRAY : t_KEY_WORDS_MASTER; -- array for 8 words
signal reg_KEY_WORDS_EXP_ARRAY : t_KEY_WORDS_EXP; -- array for 52 words
signal w_ROUND_KEYS_ARRAY : t_ROUND_KEYS; -- array for 15 keys
signal reg_PREVIOUS_KEY_WORD : STD_LOGIC_VECTOR(WORD_WIDTH-1 DOWNTO 0);
signal reg_KEY_PARSED: STD_LOGIC;
signal reg_KEY_PARSED_DEL_1: STD_LOGIC;

begin
    parsing_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_KEY_PARSED <= '0';
                for i in 0 to 7 loop
                    reg_KEY_WORDS_MASTER_ARRAY(i) <= (others => '0');
                end loop;
            elsif (pi_mod_rst = '1') then
                reg_KEY_PARSED <= '0';
                for i in 0 to 7 loop
                    reg_KEY_WORDS_MASTER_ARRAY(i) <= (others => '0');
                end loop;
            elsif (pi_enable = '1' and reg_KEY_PARSED_DEL_1 = '0') then
                reg_KEY_PARSED <= '1';
                for i in 0 to 7 loop
                    reg_KEY_WORDS_MASTER_ARRAY(i) <= pi_master_key(c_WORD(7-i) DOWNTO c_WORD(7-i)-(WORD_WIDTH-1));
                end loop;
            end if;
        end if;
    end process;
    
    reg_key_parsed_del_1_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_KEY_PARSED_DEL_1 <= '0';
            elsif (pi_mod_rst = '1') then
                reg_KEY_PARSED_DEL_1 <= '0';
            else
                reg_KEY_PARSED_DEL_1 <= reg_KEY_PARSED;
            end if;
        end if;
    end process;

    writing_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_KEY_WORDS_EXP_ARRAY <= (others => (others => '0'));
            elsif (pi_enable = '1' and pi_new_key_word_we = '1') then -- move logic to FSM
                reg_KEY_WORDS_EXP_ARRAY(to_integer(UNSIGNED(pi_word_num)-1)) <= pi_new_key_word;
            end if;
        end if;
    end process;
    
    previous_key_word_process: process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                reg_PREVIOUS_KEY_WORD <= (others => '0');
            elsif (pi_mod_rst = '1') then
                reg_PREVIOUS_KEY_WORD <= (others => '0');
            elsif (pi_enable = '1' and reg_KEY_PARSED = '1') then
                if (pi_previous_key_word_ctrl = '1') then
                    if (pi_word_num <= "001110") then -- <= 14
                        reg_PREVIOUS_KEY_WORD <= STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(to_integer(UNSIGNED(pi_word_num))-7));
                    else
                        reg_PREVIOUS_KEY_WORD <= STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(to_integer(UNSIGNED(pi_word_num))-7));
                    end if;
                else
                    if (pi_word_num <= "001110") then -- <= 14
                        reg_PREVIOUS_KEY_WORD <= STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(to_integer(UNSIGNED(pi_word_num))-8));
                    else
                        reg_PREVIOUS_KEY_WORD <= STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(to_integer(UNSIGNED(pi_word_num))-8));
                    end if;
                end if;
            end if;
        end if;
    end process;
    
    assignment_loop_master: for i in 0 to 1 generate
        w_ROUND_KEYS_ARRAY(i) <= STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(i*4)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(i*4+1)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(i*4+2)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_MASTER_ARRAY(i*4+3));
    end generate;
    
    assignment_loop_expanded: for i in 2 to 14 generate
        w_ROUND_KEYS_ARRAY(i) <= STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(i*4)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(i*4+1)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(i*4+2)) &
                                 STD_LOGIC_VECTOR(reg_KEY_WORDS_EXP_ARRAY(i*4+3));
    end generate;
    
    -- data assignment to the output ports
    po_current_key_word  <= reg_KEY_WORDS_MASTER_ARRAY(7);
    po_previous_key_word <= reg_PREVIOUS_KEY_WORD;
    po_round_keys_array <= w_ROUND_KEYS_ARRAY;

end behavioral;
