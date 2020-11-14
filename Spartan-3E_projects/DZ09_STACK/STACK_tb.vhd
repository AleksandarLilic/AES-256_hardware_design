LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--USE ieee.numeric_std.ALL;
 
ENTITY STACK_tb IS
END STACK_tb;
 
ARCHITECTURE behavior OF STACK_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT STACK
    PORT(
         Din : IN  std_logic_vector(7 downto 0);
         Dout : OUT  std_logic_vector(7 downto 0);
         push_pop : IN  std_logic;
         en : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         empty : OUT  std_logic;
         full : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal Din : std_logic_vector(7 downto 0) := (others => '0');
   signal push_pop : std_logic := '0';
   signal en : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal Dout : std_logic_vector(7 downto 0);
   signal empty : std_logic;
   signal full : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: STACK PORT MAP (
          Din => Din,
          Dout => Dout,
          push_pop => push_pop,
          en => en,
          rst => rst,
          clk => clk,
          empty => empty,
          full => full
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

      wait for clk_period*10;

      -- insert stimulus here 
		
		--push 15
		en<='1';
		push_pop<='0';
		Din<="00001111"; 
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--push 16
		en<='1';
		push_pop<='0';
		Din<="00010000";
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--push 17
		en<='1';
		push_pop<='0';
		Din<="00010001";
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--push 18
		en<='1';
		push_pop<='0';
		Din<="00010010";
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--pop 18
		en<='1';
		push_pop<='1';
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--pop 17
		en<='1';
		push_pop<='1';
		
		wait for clk_period;
		en<='0';
		
--		wait for 2*clk_period;
		
		
		wait for 2*clk_period;
		
		en<='1';
		Din<="00010111";		
		push_pop<='0';
		
		wait for clk_period;
		en<='0';
		
		wait for 2*clk_period;
		
		--pop 23
		en<='1';
		push_pop<='1';
		
		wait for clk_period;
		en<='0';
		

      wait;
   end process;

END;
