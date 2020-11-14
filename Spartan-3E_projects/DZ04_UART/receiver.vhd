----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:30:58 02/15/2014 
-- Design Name: 
-- Module Name:    receiver - Behavioral 
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

entity receiver is
    Generic(D_BIT : integer;
				SB_TICK : integer);
    Port ( clk : in  STD_LOGIC;
	        rst : in  STD_LOGIC;
	        rx : in  STD_LOGIC;
           s_tick : in  STD_LOGIC;
           dout : out  STD_LOGIC_VECTOR (6 downto 0);
           rx_done : out  STD_LOGIC);
end receiver;

architecture Behavioral of receiver is
	COMPONENT datapath
	Generic(D_BIT : integer;
				SB_TICK : integer);
	PORT(
		clk : IN std_logic;
		sin : IN std_logic;
		enb : IN std_logic;
		clrs : IN std_logic;
		ens : IN std_logic;
		clrn : IN std_logic;
		enn : IN std_logic;          
		c7 : OUT std_logic;
		c15 : OUT std_logic;
		cSB : OUT std_logic;
		cn : OUT std_logic;
		dout : out  STD_LOGIC_VECTOR(6 downto 0)
		);
	END COMPONENT;
	
	COMPONENT control
	PORT(
		clk : IN std_logic;
		rst : IN std_logic;
		s_tick : IN std_logic;
		rx : IN std_logic;
		c7 : IN std_logic;
		c15 : IN std_logic;
		cSB : IN std_logic;
		cn : IN std_logic;          
		enb : OUT std_logic;
		clrs : OUT std_logic;
		ens : OUT std_logic;
		clrn : OUT std_logic;
		enn : OUT std_logic;
		rx_done : OUT std_logic
		);
	END COMPONENT;
   signal enb, clrs, ens, c7, c15, cSB, clrn, enn, cn : std_logic;
begin

DPTH: datapath 
   GENERIC MAP(
	   D_BIT => D_BIT,
		SB_TICK => SB_TICK
	)
   PORT MAP(
		clk => clk,
		sin => rx,
		enb => enb,
		clrs => clrs,
		ens => ens,
		clrn => clrn,
		enn => enn,
		c7 => c7,
		c15 => c15,
		cSB => cSB,
		cn => cn,
		dout => dout
	);

CTRL: control PORT MAP(
		clk => clk,
		rst => rst,
		s_tick => s_tick,
		rx => rx,
		c7 => c7,
		c15 => c15,
		cSB => cSB,
		cn => cn,
		enb => enb,
		clrs => clrs,
		ens => ens,
		clrn => clrn,
		enn => enn,
		rx_done => rx_done 
	);
end Behavioral;

