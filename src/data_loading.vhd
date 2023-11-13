library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity data_loading is
	port(	
		-- INPUTS
		-- system
		clk : IN  STD_LOGIC;
		rst : IN  STD_LOGIC;		
		
		-- data input
		pi_data		  : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		pi_next_aes_ready : IN  STD_LOGIC;
		
		-- OUTPUTS
		-- data output
		po_next_val_ready : OUT  STD_LOGIC;
		po_data	: OUT STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0)		
	);
end data_loading;

architecture behavioral of data_loading is
-- Custom Types
type 	state is (idle, loading);
-- Signals
signal pr_state: state := idle;
signal nx_state: state := idle;

signal reg_COUNTER 	: STD_LOGIC_VECTOR(3 DOWNTO 0) 	:= (others => '0');
signal reg_INPUT_KEY 	: STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0) := (others => '0');

signal w_LOADING_DATA   : STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0);

signal reg_CNT_RST : STD_LOGIC := '0';
signal reg_CNT_EN  : STD_LOGIC := '0';

signal reg_NEXT_VAL_READY : STD_LOGIC := '0';
signal reg_NEXT_VAL_READY_DEL_1 : STD_LOGIC := '0';

signal reg_OUTPUT_CTRL  : STD_LOGIC := '0';
begin

	fsm_process: process(clk)
	begin 
		if(rising_edge(clk)) then
			if(rst = '1') then
				pr_state <= idle;
			else
				pr_state <= nx_state;
			end if;
		end if;
	end process;
	
	fsm_state_process: process(pr_state, pi_next_aes_ready, reg_COUNTER)
	begin
		nx_state <= pr_state;
		case(pr_state) is
			when idle =>
				if(pi_next_aes_ready = '1') then
					nx_state <= loading;
				else
					nx_state <= idle;
				end if;
			
			when loading =>
				if(reg_COUNTER = x"F") then
					nx_state <= idle;
				else
					nx_state <= loading;
				end if;
				
			when others => NULL;
				
		end case;
	end process;
	
	fsm_output_process: process(pr_state, pi_next_aes_ready, reg_COUNTER)
	begin
		 -- Default Values:
		reg_CNT_RST <= '0';
		reg_CNT_EN  <= '0';
		reg_OUTPUT_CTRL  <= '0';
		reg_NEXT_VAL_READY <= '0';
		
		case(pr_state) is
			when idle =>
				reg_OUTPUT_CTRL  <= '0';
				if(pi_next_aes_ready = '0') then
					reg_CNT_EN <= '0';
				end if;
			
			when loading =>
				reg_OUTPUT_CTRL  <= '1';
				if(reg_COUNTER = x"F") then
					reg_CNT_EN <= '0';
					reg_CNT_RST <= '1';
					reg_NEXT_VAL_READY <= '1';
				else
					reg_CNT_EN <= '1';
					reg_NEXT_VAL_READY <= '1';
				end if;
				
			when others => NULL;
				
		end case;
	end process;
	
	input_reg_process: process(clk)
	begin
		if(rising_edge(clk)) then
			 if(pi_next_aes_ready = '1') then
				reg_INPUT_KEY <= pi_data;
			end if;
		end if;
	end process;
	
	cnt_16_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(reg_CNT_RST = '1' or rst = '1') then
				reg_COUNTER <= "0000";
			else
				if(reg_CNT_EN = '1') then
					reg_COUNTER <= STD_LOGIC_VECTOR(UNSIGNED(reg_COUNTER)+1);
				end if;
			end if;
		end if;
	end process;
	
	-- Output assignement
	w_LOADING_DATA <= reg_INPUT_KEY(c_BYTE(15-to_integer(UNSIGNED(reg_COUNTER))) DOWNTO c_BYTE(15-to_integer(UNSIGNED(reg_COUNTER)))-7);
	
	output_process: process(clk)
	begin
		if(rising_edge(clk)) then
			if(rst = '1') then 
				po_data <= (others => '0');
			else
				if(reg_OUTPUT_CTRL = '1') then
					po_data <= w_LOADING_DATA;
				end if;
			end if;
		end if;
	end process;
	
	next_val_del_1_process: process(clk)
	begin
		if(rising_edge(clk)) then
			reg_NEXT_VAL_READY_DEL_1 <= reg_NEXT_VAL_READY;
		end if;
	end process;
	
	po_next_val_ready <= reg_NEXT_VAL_READY_DEL_1;

end behavioral;