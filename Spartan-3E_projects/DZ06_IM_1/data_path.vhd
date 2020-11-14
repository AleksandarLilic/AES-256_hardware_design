library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity data_path is
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
end data_path;

architecture Behavioral of data_path is

signal regi, regj, regp, co1, decj : unsigned(5 downto 0);

begin

	--register i
	
	process(clk)
	begin
		if(clk'event and clk = '1') then
			if(rsti = '1') then
				regi <= (others => '0');
			elsif(eni = '1') then
				regi <= regi + 1;
			end if;
		end if;
	end process;
	
	--register j
	
	process(clk)
	begin
		if(clk'event and clk = '1') then
		if(rst='1') then
			regj<=(others => '0');
		else
			if(enj = '1') then
				regj <= regj - 1;
			elsif(ldj = '1') then
				regj <= regp;
			end if;
		end if;
		end if;
	end process;
	
	--register p
	
	process(clk)
	begin
		if(clk'event and clk='1') then
		if(rst='1') then
			regp<=(others => '0');
		else
			if(enp = '1') then
				regp <= regp + 1;
			end if;
		end if;
		end if;
	end process;
	
	
	co1 <= regp when s0='0' else
			 regj;
			 
	decj <= regj-1;
			 
	cmp1 <= '1' when regi < co1 else
			  '0';
			  
	cmp2 <= '1' when unsigned(r_data) < unsigned(D) else
			  '0';
			  
	cmp3 <= '1' when unsigned(r_data) = unsigned(D) else
			  '0';
	
	full <= '1' when regp = "111111" else
			  '0';
	
	
	r_addr <= std_logic_vector (regi) when s1 = '0' else
				 std_logic_vector (decj);
				 
	w_addr <= std_logic_vector (regj) when s2 = '0' else
				 std_logic_vector (regi);
				 
	w_data <= r_data when s3 = '0' else
				 std_logic_vector (D);


end Behavioral;

