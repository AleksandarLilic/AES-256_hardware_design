library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

--use IEEE.NUMERIC_STD.ALL;

entity control_unit is
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
end control_unit;

architecture Behavioral of control_unit is
	type state is (idle, st0, st1);
	signal pr_state, nx_state : state;

begin

	--registar
	process (clk, rst)
	begin
		if (rst = '1') then
			pr_state <= idle;
		elsif (clk'event and clk='1') then
			pr_state <= nx_state;
		end if;
	end process;
	
	-- logika sledeceg stanja i izlaza
	process (pr_state, start, cmp1, cmp2, cmp3)
	begin
	
	eni<='0'; rsti<='0'; ldj<='0'; enj<='0'; enp<='0'; rdy<='0'; status<='0'; s0<='0'; s1<='0'; s2<='0'; s3<='0'; we_out<='0';
	nx_state<=pr_state;
	
	case pr_state is
		when idle => 
			rdy<='1';
			if(start='1') then
				if(we_in='1') then
					rsti<='1';
					nx_state<=st0;
				end if;
			end if;
		
		when st0 => 
			if(cmp1='1' and cmp2='1') then
				eni<='1';
			elsif(cmp1='1' and cmp3='1') then
				nx_state<=idle;
			else
				ldj<='1';
				--s0<='1';
				nx_state<=st1;
			end if;
			
		when st1 =>
				s0<='1';
			if(cmp1='1') then
				s1<='1';
				we_out<='1';
				enj<='1';
			else
				s2<='1';
				s3<='1';
				we_out<='1';
				enp<='1';
				status<='1';
				nx_state<=idle;
			end if;
			
	end case;
	end process;
	
end Behavioral;

