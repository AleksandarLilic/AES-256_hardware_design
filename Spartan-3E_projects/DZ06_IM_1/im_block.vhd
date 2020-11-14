library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity im_block is
    Port ( D : in  STD_LOGIC_VECTOR (7 downto 0);
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
end im_block;

architecture Behavioral of im_block is
	component data_path
    Port ( eni  : in  STD_LOGIC;
           rsti : in  STD_LOGIC;
           ldj  : in  STD_LOGIC;
           enj  : in  STD_LOGIC;
           enp  : in  STD_LOGIC;
           r_data : in   STD_LOGIC_VECTOR (7 downto 0);
           w_data : out  STD_LOGIC_VECTOR (7 downto 0);
           D      : in   STD_LOGIC_VECTOR (7 downto 0);
           r_addr : out  STD_LOGIC_VECTOR (5 downto 0);
           w_addr : out  STD_LOGIC_VECTOR (5 downto 0);
           cmp1 : out  STD_LOGIC;
           cmp2 : out  STD_LOGIC;
           cmp3 : out  STD_LOGIC;
           s0 : in  STD_LOGIC;
           s1 : in  STD_LOGIC;
           s2 : in  STD_LOGIC;
           s3 : in  STD_LOGIC;
			  clk : in std_logic;
			  full : out std_logic;
			  rst : in std_logic
			 );
	end component;

	component control_unit
    Port ( cmp1 : in  STD_LOGIC;
           cmp2 : in  STD_LOGIC;
           cmp3 : in  STD_LOGIC;
           we_in : in  STD_LOGIC;
           start : in  STD_LOGIC;
			  we_out : out std_logic;
           eni  : out  STD_LOGIC;
           rsti : out  STD_LOGIC;
           ldj : out  STD_LOGIC;
           enj : out  STD_LOGIC;
           enp : out  STD_LOGIC;
			  s0 : out  STD_LOGIC;
           s1 : out  STD_LOGIC;
           s2 : out  STD_LOGIC;
           s3 : out  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           rdy : out  STD_LOGIC;
           status : out  STD_LOGIC);
	end component;

signal eni, rsti, ldj, enj, enp, cmp1, cmp2, cmp3, s0, s1, s2, s3 : std_logic;
--signal : std_logic;

begin
	dptr: data_path port map(
		eni=>eni,
		rsti=>rsti,
		ldj=>ldj,
		enj=>enj,
		enp=>enp,
		cmp1=>cmp1,
		cmp2=>cmp2,
		cmp3=>cmp3,
		s0=>s0,
		s1=>s1,
		s2=>s2,
		s3=>s3,
		clk=>clk,
		full=>full,
		rst=>rst,
		r_data=>r_data,
		D=>D,
		w_data=>w_data,
		w_addr=>w_addr,
		r_addr=>r_addr);
		
	cu: control_unit port map(
		we_in=>we_in,
		start=>start,
		clk=>clk,
		rdy=>rdy,
		rst=>rst,
		we_out=>we_out,
		status=>status,
		eni=>eni,
		rsti=>rsti,
		ldj=>ldj,
		enj=>enj,
		enp=>enp,
		cmp1=>cmp1,
		cmp2=>cmp2,
		cmp3=>cmp3,
		s0=>s0,
		s1=>s1,
		s2=>s2,
		s3=>s3);
		


end Behavioral;

