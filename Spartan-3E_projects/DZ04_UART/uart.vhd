----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:56:34 02/16/2014 
-- Design Name: 
-- Module Name:    uart - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart is
    Generic(D_BIT : integer := 7;
				SB_TICK : integer := 16);
    Port ( clk : in  STD_LOGIC;
           rst : in  STD_LOGIC;
           rx : in  STD_LOGIC;
           rx_data : out  STD_LOGIC_VECTOR (6 downto 0);
           rx_rdy : out  STD_LOGIC;
           rd_uart : in  STD_LOGIC);
end uart;

architecture Behavioral of uart is
   COMPONENT receiver
	GENERIC(D_BIT : integer;
			  SB_TICK : integer);
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		rx : IN std_logic;
		s_tick : IN std_logic;          
		dout : OUT std_logic_vector(6 downto 0);
		rx_done : OUT std_logic
		);
	END COMPONENT;
  signal div_counter : unsigned(7 downto 0);
  signal dout : std_logic_vector(6 downto 0);
  signal rx_done, sclk : std_logic;
begin

REC: receiver 
    GENERIC MAP(
	   D_BIT => D_BIT,
		SB_TICK => SB_TICK
	 )
    PORT MAP(
		clk => clk,
		rst => rst,
		rx => rx,
		s_tick => sclk,
		dout => dout,
		rx_done => rx_done
	);
-- generator takta za semplovanje
   process(clk)
	begin
	  if(clk'event and clk = '1') then
	    if(sclk = '1') then
		   div_counter <= (others => '0');
		 else
		   div_counter <= div_counter + 1;
		 end if;
	  end if;
	end process;
	sclk <= '1' when div_counter = 163 else
	        '0';

-- interfejs
  process(clk)
  begin
    if(clk'event and clk = '1') then
	   if(rx_done='1') then
		  rx_data <= dout;
		  rx_rdy <= '1';
		elsif(rd_uart = '1') then
		  rx_rdy <= '0';
		end if;
	 end if;
  end process;
  
end Behavioral;

