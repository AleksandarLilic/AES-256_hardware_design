library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity IM is
    Port ( r_addr : in  STD_LOGIC_VECTOR (5 downto 0);
           we : in  STD_LOGIC;
           D : in  STD_LOGIC_VECTOR (7 downto 0);
           start : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           r_data : out  STD_LOGIC_VECTOR (7 downto 0);
           status : out  STD_LOGIC;
           full : out  STD_LOGIC);
end IM;

architecture Behavioral of IM is

component im_block port(
			D : in  STD_LOGIC_VECTOR (7 downto 0);
         we_in : in  STD_LOGIC;
         start : in  STD_LOGIC;
         rst : in  STD_LOGIC;
         clk : in  STD_LOGIC;
         rdy : out  STD_LOGIC;
         status : out  STD_LOGIC;
         full : out  STD_LOGIC;
         w_data : out  STD_LOGIC_VECTOR (7 downto 0);
         w_addr : out  STD_LOGIC_VECTOR (5 downto 0);
         r_addr : out  STD_LOGIC_VECTOR (5 downto 0);
         we_out : out  STD_LOGIC;
         r_data : in  STD_LOGIC_VECTOR (7 downto 0));
end component;

component reg_file port(
		  clk, rst : IN STD_LOGIC;
        we : IN STD_LOGIC;
        w_addr, r_addr : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
        w_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        r_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end component;		

signal b_rdy, b_we_out, rf_we : std_logic;
signal b_w_addr, b_r_addr, rf_w_addr, rf_r_addr : std_logic_vector(5 downto 0);
signal b_w_data, b_r_data, rf_w_data : std_logic_vector(7 downto 0);

begin

	im_b: im_block port map(
			D=>D,
			we_in=>we,
			start=>start,
			rst=>rst,
			clk=>clk,
			r_data=>b_r_data,
			rdy=>b_rdy,
			we_out=>b_we_out,
			status=>status,
			full=>full,
			w_addr=>b_w_addr,
			w_data=>b_w_data,
			r_addr=>b_r_addr);
			
	rf: reg_file port map(
			clk=>clk,
			rst=>rst,
			we=>rf_we,
			w_addr=>rf_w_addr,
			r_addr=>rf_r_addr,
			w_data=>rf_w_data,
			r_data=>b_r_data);
			
	r_data <= b_r_data;
 			
	rf_w_addr <= b_w_addr when b_rdy='0' else
					(others => '0');
	
	rf_w_data <= b_w_data when b_rdy='0' else
					(others => '0');
	
	rf_we <= b_we_out when b_rdy='0' else
					'0';

	rf_r_addr <= b_r_addr when b_rdy='0' else
					 r_addr;
	
	
			


end Behavioral;

