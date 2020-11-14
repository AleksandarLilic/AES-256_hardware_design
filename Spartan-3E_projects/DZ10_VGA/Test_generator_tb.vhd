LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY Test_generator_tb IS
END Test_generator_tb;
 
ARCHITECTURE behavior OF Test_generator_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT Test_generator
    PORT(
         rst : IN  std_logic;
         clk : IN  std_logic;
         HV : IN  std_logic;
         VGA_HSYNC : OUT  std_logic;
         VGA_VSYNC : OUT  std_logic;
         VGA_RED : OUT  std_logic;
         VGA_GREEN : OUT  std_logic;
         VGA_BLUE : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';
   signal HV : std_logic := '0';

 	--Outputs
   signal VGA_HSYNC : std_logic;
   signal VGA_VSYNC : std_logic;
   signal VGA_RED : std_logic;
   signal VGA_GREEN : std_logic;
   signal VGA_BLUE : std_logic;

   -- Clock period definitions
   constant clk_period : time := 20 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: Test_generator PORT MAP (
          rst => rst,
          clk => clk,
          HV => HV,
          VGA_HSYNC => VGA_HSYNC,
          VGA_VSYNC => VGA_VSYNC,
          VGA_RED => VGA_RED,
          VGA_GREEN => VGA_GREEN,
          VGA_BLUE => VGA_BLUE
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
      -- hold reset state for 100 ns.
      rst<='1';
		wait for 100 ns;	
		rst<='0';

      --wait for clk_period*10;
		
      -- insert stimulus here 
		HV<='1';

      wait;
   end process;

END;
