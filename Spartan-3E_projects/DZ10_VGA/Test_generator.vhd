library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Test_generator is
    Port ( rst : in  STD_LOGIC;
           clk : in  STD_LOGIC;
           HV : in  STD_LOGIC;
           VGA_HSYNC : out  STD_LOGIC;
           VGA_VSYNC : out  STD_LOGIC;
           VGA_RED : out  STD_LOGIC;
           VGA_GREEN : out  STD_LOGIC;
           VGA_BLUE : out  STD_LOGIC);
end Test_generator;

architecture Behavioral of Test_generator is
	COMPONENT VGA_generator
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
	END COMPONENT;

signal RinS, GinS, BinS, PxCLKs, LnCLKs, ens, cout: std_logic;
signal cnt6080: std_logic_vector(6 downto 0);
signal cnt8: std_logic_vector(1 downto 0);



begin

vga_gen: VGA_generator
	PORT MAP(
		clk=>clk,
		rst=>rst,
		VGA_HSYNC=>VGA_HSYNC,
		VGA_VSYNC=>VGA_VSYNC,
		VGA_R=>VGA_RED,
		VGA_G=>VGA_GREEN,
		VGA_B=>VGA_BLUE,
		Rin=>RinS,
		Gin=>GinS,
		Bin=>BinS,
		PxCLK=>PxCLKs,
		LnCLK=>LnCLKs);
		

ens<= PxCLKs when HV='0' else
		LnCLKs;
--ens<='1';

--cnt8<=RinS & GinS & BinS;

--RinS<=cnt8(2);
GinS<=cnt8(1);
BinS<=cnt8(0);

-- cnt6080
process(clk)
begin
	if(clk'event and clk='1') then
	if(rst='1') then
		cnt6080<=(others=>'0');
		cout<='0';
	else
	cout<='0';
		if(ens='1') then
			cnt6080<=std_logic_vector(unsigned(cnt6080)+1);
			--cout<='0';
			if(HV='1') then
				if(unsigned(cnt6080)=59)then --59
					cnt6080<=(others=>'0');
					cout<='1';
				end if;
			else --HV='0'
				if(unsigned(cnt6080)=79)then
					cnt6080<=(others=>'0');
					cout<='1';
				end if;
			end if;
		end if;
	end if;
	end if;
end process;
			
-- cnt8

process(clk)
begin
	if(clk'event and clk='1') then
		if(rst='1') then
			cnt8<=(others=>'0'); -- black
			--col<="000"
		else
			if(cout='1') then
				cnt8<=std_logic_vector(unsigned(cnt8)+1);
			end if;
		end if;
	end if;
end process;


		
end Behavioral;

