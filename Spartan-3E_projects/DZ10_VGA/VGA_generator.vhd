library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity VGA_generator is
    Port ( Rin : in  STD_LOGIC;
           Gin : in  STD_LOGIC;
           Bin : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           PxROW : out  STD_LOGIC_VECTOR (9 downto 0);
           PxCOL : out  STD_LOGIC_VECTOR (9 downto 0);
           PxDISP : out  STD_LOGIC;
           PxCLK : out  STD_LOGIC;
           LnCLK : out  STD_LOGIC;
           VGA_HSYNC : out  STD_LOGIC;
           VGA_VSYNC : out  STD_LOGIC;
           VGA_R : out  STD_LOGIC;
           VGA_G : out  STD_LOGIC;
           VGA_B : out  STD_LOGIC);
end VGA_generator;

architecture Behavioral of VGA_generator is

signal hcount, vcount: std_logic_vector (10 downto 0);
signal HsyncS: std_logic;

begin

-- horizontal sync counter
process(clk)
begin
	if(clk'event and clk='1') then
		if(rst='1' or unsigned(hcount)=1599) then
			hcount<=(others=>'0');
		else
			hcount<=std_logic_vector(unsigned(hcount)+1);
		end if;
	end if;
end process;

-- vertical sync counter
process(clk)
begin
	if(clk'event and clk='1') then
		if(rst='1' or unsigned(vcount)=521) then 
			vcount<=(others=>'0');
		elsif (unsigned(hcount)=1503) then
			vcount<=std_logic_vector(unsigned(vcount)+1);
		end if;
	end if;
end process;


--PxCol & PxDISP counter
process(clk)
begin
	if(clk'event and clk='1')then
	if(rst='1') then
		PxDISP<='0';
	else
		if(unsigned(hcount)<1280) then
			PxCOL<=hcount(10 downto 1); -- hcount div 2, gives pixel number for given row
			PxDISP<='1';
		else
			PxDISP<='0';
		end if;
	end if;
	end if;
end process;


--PxRow
process(clk)
begin
	if(clk'event and clk='1')then
		if(unsigned(vcount)<960) then
			PxROW<=vcount(10 downto 1); -- vcount div 2, gives pixel number for given column
		end if;
	end if;
end process;

--PxClk
process(clk)
begin
	--PxCLK<='0';
	if(clk'event and clk='1') then
		if(unsigned(hcount)<1280) then
			PxCLK<=hcount(0);
		else
			PxCLK<='0';
		end if;
	end if;
end process;


--LnClk
process(clk)
begin
	--LnClk<='0';
	if(clk'event and clk='1') then
		if(unsigned(hcount)=1312) then
			LnCLK<='1';
		else
			LnCLK<='0';
		end if;
	end if;
end process;



HsyncS<='0' when (unsigned(hcount)>=1312 and unsigned(hcount)<=1503) else
		  '1';
				
VGA_HSYNC<=HsyncS;
				
VGA_VSYNC<='0' when (unsigned(vcount)>=490 and unsigned(vcount)<=491) else
				'1';
VGA_R<=Rin when (unsigned(hcount)>=0 and unsigned(hcount)<=1279 and 
						unsigned(vcount)>=0 and unsigned(vcount)<=479) else
			'0';

VGA_G<=Gin when (unsigned(hcount)>=0 and unsigned(hcount)<=1279 and 
						unsigned(vcount)>=0 and unsigned(vcount)<=479) else
			'0';
			
VGA_B<=Bin when (unsigned(hcount)>=0 and unsigned(hcount)<=1279 
						and unsigned(vcount)>=0 and unsigned(vcount)<=479) else
			'0';



end Behavioral;

