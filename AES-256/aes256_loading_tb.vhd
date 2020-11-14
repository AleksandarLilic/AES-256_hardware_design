library IEEE;
use IEEE.STD_LOGIC_1164.all;
use IEEE.NUMERIC_STD.all;
use WORK.MATRIX_CONST.all;

entity aes256_loading_tb is
end aes256_loading_tb;

architecture rtl_tb of aes256_loading_tb is 

component aes256_loading
	port(
		-- system
		clk : IN  STD_LOGIC;
		
		---- KEY MANAGEMENT ---
		-- data input
		pi_key_expand_start : IN  STD_LOGIC;
		pi_master_key	    : IN  STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0);
		-- data output
		po_key_ready	    : OUT STD_LOGIC;
		
		---- ENCRYPTION ----
		-- data input
		pi_next_val_req	    : IN  STD_LOGIC;
		pi_data		    : IN  STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0);
		-- data output
		po_next_val_ready   : OUT STD_LOGIC;
		po_data		    : OUT STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0)
	);
end component;    
   
signal clk : STD_LOGIC := '0';

---- KEY MANAGEMENT ---
-- data input
signal reg_key_expand_start : STD_LOGIC := '0';
signal reg_master_key	    : STD_LOGIC_VECTOR(MATRIX_KEY_WIDTH-1 DOWNTO 0) := (others => '0');
-- data output
signal reg_key_ready        : STD_LOGIC := '0';

---- ENCRYPTION ----
-- data input
signal reg_pi_data	     : STD_LOGIC_VECTOR(MATRIX_DATA_WIDTH-1 DOWNTO 0) := (others => '0');
signal reg_pi_next_val_req   : STD_LOGIC := '0';
-- data output
signal reg_po_next_val_ready : STD_LOGIC := '0';
signal reg_po_data	     : STD_LOGIC_VECTOR(BYTE_WIDTH-1 DOWNTO 0) := (others => '0');
   
constant clk_period 	: time 		:= 10 ns;

begin

	uut: aes256_loading port map (
		clk => clk,
		pi_key_expand_start => reg_key_expand_start,
		pi_master_key       => reg_master_key,
		po_key_ready        => reg_key_ready,
		pi_next_val_req     => reg_pi_next_val_req,
		pi_data 	    => reg_pi_data,
		po_next_val_ready   => reg_po_next_val_ready,
		po_data 	    => reg_po_data
        );

	clk_process :process
	begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
  	end process;
  
	stim_proc: process
	begin  
		wait for 5 ns;
		wait for clk_period*10;
		
		reg_key_expand_start <= '0';
		wait for clk_period*5;
		
-- 		reg_master_key <= x"603deb1015ca71be2b73aef0857d77811f352c073b6108d72d9810a30914dff4";
		reg_master_key <= x"000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
		reg_key_expand_start <= '1';
		wait for clk_period*5;
		
		reg_key_expand_start <= '0';
		wait for clk_period*100;
		
		reg_pi_data  <= x"00112233445566778899aabbccddeeff";
		reg_pi_next_val_req <= '1';	
		
		wait for clk_period*65;
-- 		reg_key_expand_start <= '1';
		
		wait for clk_period*5;
		reg_key_expand_start <= '0';
-- 		reg_pi_next_val_req <= '0';
-- 		reg_pi_data  <= x"12345678901234567890123456789012";
		
		wait for clk_period*30;
-- 		reg_master_key <= x"abc102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f";
-- 		reg_key_expand_start <= '1';
-- 		reg_pi_next_val_req <= '0';
		wait for clk_period*5;
		
-- 		reg_key_expand_start <= '0';
		wait for clk_period*60;
		reg_key_expand_start <= '1';
                wait for clk_period*5;
                reg_key_expand_start <= '0';
                wait for clk_period*50;
		
-- 		reg_pi_data  <= x"09876543210987654321098765432109";
-- 		reg_pi_next_val_req <= '1';
		wait for clk_period*60;
		
-- 		reg_pi_data  <= x"a2a2a2a2b3b3b3b3c4c4c4c4d5d5d5d5";
		
		wait for clk_period*60;
-- 		reg_pi_next_val_req <= '1';
		
		wait for clk_period*5;
-- 		reg_pi_next_val_req <= '0';
		wait;
	end process;
end;
