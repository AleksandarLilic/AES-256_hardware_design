--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   00:33:32 02/16/2014
-- Design Name:   
-- Module Name:   C:/Users/Goran/Documents/Courses/MA/2014/Vezbe/UART/receiver_tb.vhd
-- Project Name:  UART
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: receiver
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY receiver_tb IS
END receiver_tb;
 
ARCHITECTURE behavior OF receiver_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT receiver
	 GENERIC(D_BIT : integer;
			   SB_TICK : integer);
    PORT(
         clk : IN  std_logic;
         rst : IN  std_logic;
         rx : IN  std_logic;
         s_tick : IN  std_logic;
         dout : OUT  std_logic_vector(6 downto 0);
         rx_done : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal rst : std_logic := '0';
   signal rx : std_logic := '0';
   signal s_tick : std_logic := '0';

 	--Outputs
   signal dout : std_logic_vector(6 downto 0);
   signal rx_done : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
	constant data : std_logic_vector(6 downto 0) := "1011001";
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: receiver 
	    GENERIC MAP(
		   D_BIT => 7,
			SB_TICK => 16
		 )
	    PORT MAP (
          clk => clk,
          rst => rst,
          rx => rx,
          s_tick => s_tick,
          dout => dout,
          rx_done => rx_done
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      rst <= '1';
		rx <= '1';
		s_tick <= '1';
		wait for clk_period*2;
		rst <= '0';
		
      wait for clk_period*10;
		wait until (clk'event and clk ='1');
		
		-- start bit
		rx <= '0';
		wait for clk_period*16;
		
		-- data bits
		for i in 0 to 6 loop
		  rx <= data(i);
		  wait for clk_period*16;
		end loop;

      rx <= '1';

      wait;
   end process;

END;
