library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity STACK is
    Port ( Din : in  STD_LOGIC_VECTOR (7 downto 0);
           Dout : out  STD_LOGIC_VECTOR (7 downto 0);
           push_pop : in  STD_LOGIC;
           en : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           empty : out  STD_LOGIC;
           full : out  STD_LOGIC);
end STACK;

architecture Behavioral of STACK is
COMPONENT RAM
  PORT (
    a : IN STD_LOGIC_VECTOR(5 DOWNTO 0);
    d : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    clk : IN STD_LOGIC;
    we : IN STD_LOGIC;
    spo : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
  );
END COMPONENT;

signal TOP, TOPm1: UNSIGNED(5 downto 0);
signal addr: std_logic_vector(5 downto 0);
signal Rwe: std_logic;

begin

	--brojac TOP
	process(clk, rst)
	begin
		if(rst='1') then
			TOP<=(others=>'0');
		elsif(clk'event and clk='1') then
			if(en='1') then
				if(push_pop='0') then
					TOP<=TOP+1;
				else
					TOP<=TOP-1;
				end if;
			end if;
		end if;
	end process;
	
	--brojac TOPm1
	process(clk, rst)
	begin
		if(rst='1') then
			TOPm1<=(others=>'1');
		elsif(clk'event and clk='1') then
			if(en='1') then
				if(push_pop='0') then
					TOPm1<=TOPm1+1;
				else
					TOPm1<=TOPm1-1;
				end if;
			end if;
		end if;
	end process;
	
--	addr <= std_logic_vector(TOP) when (en='1' and push_pop='0') else
--			  std_logic_vector(TOPm1) when (en='1' and push_pop='1');
			  
	addr <= std_logic_vector(TOP) when (push_pop='0') else
			  std_logic_vector(TOPm1) when (push_pop='1');
			  
	Rwe <= '1' when (en='1' and push_pop='0') else
			 '0';
			 
	empty <= '1' when (TOP=0) else
				'0';
				
	full <= '1' when (TOP=63) else
			  '0';
			 
	ram_64b : RAM
		PORT MAP (
			a => addr,
			d => Din,
			clk => clk,
			we => Rwe,
			spo => Dout
		);
			
end Behavioral;

