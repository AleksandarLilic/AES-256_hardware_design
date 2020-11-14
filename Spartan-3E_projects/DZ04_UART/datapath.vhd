library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity datapath is
    Generic(D_BIT : integer;
				SB_TICK : integer);
    Port ( clk : in  STD_LOGIC;
           sin : in  STD_LOGIC;
           enb : in  STD_LOGIC;
           clrs : in  STD_LOGIC;
           ens : in  STD_LOGIC;
           clrn : in  STD_LOGIC;
           enn : in  STD_LOGIC;
           c7 : out  STD_LOGIC;
           c15 : out  STD_LOGIC;
           cSB : out  STD_LOGIC;
           cn : out  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (6 downto 0));
end datapath;

architecture Behavioral of datapath is
  signal b_reg : std_logic_vector(6 downto 0);
  signal s_reg : unsigned(4 downto 0);
  signal n_reg : unsigned(3 downto 0);
begin


-- registar podatka, b
	process(clk)
	begin
	-- Ovde ubaciti kod koji nedostaje --
		if(clk'event and clk='1') then
			if(enb='1') then
				b_reg<=(sin & b_reg(6 downto 1));
			end if;
		end if;
     
	end process;
	
	
	
-- brojac semplova, s
   process(clk)
	begin
	-- Ovde ubaciti kod koji nedostaje --
		if(clk'event and clk='1') then
			if(ens='1') then
				if(clrs='1')then
					s_reg<=(others=>'0');
				else
					s_reg<=s_reg+1;
				end if;
			end if;
		end if;
	  
	end process;


-- konkurentni kod za generisanje signala cSB, C15 i c7
-- ...	

		c7 <= '1' when s_reg = "00111" else
				'0';
	

		c15 <= '1' when s_reg = "01111" else
				 '0';
	

		cSB <= '1' when s_reg = SB_TICK else
				 '0';
	


-- brojac bitova podatka, n
   process(clk)
	begin
	-- Ovde ubaciti kod koji nedostaje --
		if(clk'event and clk='1') then
			if(enn='1') then
				if(clrn='1') then
					n_reg<=(others=>'0');
				else
					n_reg<=n_reg+1;
				end if;
			end if;
		end if;
	  
	end process;
	
-- konkurentni kod za generisanje signala cn i dout
-- ...


		cn<= '1' when n_reg=D_BIT-1 else
			  '0';
		
		dout<=b_reg;
	

end Behavioral;

