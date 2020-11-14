LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
 
ENTITY IM_tb IS
END IM_tb;
 
ARCHITECTURE behavior OF IM_tb IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT IM
    PORT(
         r_addr : IN  std_logic_vector(5 downto 0);
         we : IN  std_logic;
         D : IN  std_logic_vector(7 downto 0);
         start : IN  std_logic;
         rst : IN  std_logic;
         clk : IN  std_logic;
         r_data : OUT  std_logic_vector(7 downto 0);
         status : OUT  std_logic;
         full : OUT  std_logic
        );
    END COMPONENT;
    

   --Inputs
   signal r_addr : std_logic_vector(5 downto 0) := (others => '0');
   signal we : std_logic := '0';
   signal D : std_logic_vector(7 downto 0) := (others => '0');
   signal start : std_logic := '0';
   signal rst : std_logic := '0';
   signal clk : std_logic := '0';

 	--Outputs
   signal r_data : std_logic_vector(7 downto 0);
   signal status : std_logic;
   signal full : std_logic;

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: IM PORT MAP (
          r_addr => r_addr,
          we => we,
          D => D,
          start => start,
          rst => rst,
          clk => clk,
          r_data => r_data,
          status => status,
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
	
--	-- procedura za upis inicijalnog sadrzaja u RF
--	  procedure write_rf is
--
--		-- A - niz koji treba upisati u RF
--		type int_array is array(0 to 13) of integer;
--		variable A : int_array := (2,11,19,22,53,68,101,242,250,311,372,409,498,582);
--
--	  begin
--	     we <= '1';
--	     for i in 0 to A'Length-1 loop
--		    w_addr <= std_logic_vector(to_unsigned(i,6));
--	       w_data <= std_logic_vector(to_unsigned(A(i),8));	
--		    wait for clk_period;		  
--		  end loop;
--		  we <= '0';
--	  end ;
	
   begin		
      -- hold reset state for 100 ns.
--      wait for 100 ns;	
--
--      wait for clk_period*10;

      -- insert stimulus here 
		
		-- pocetne vrednosti upravljackih signala
	  we <= '0';
	  start <= '0';
	  
	  wait until clk'event and clk = '0';
	  --clr <= '1';
	  rst <= '1';
	  wait for clk_period;
	  rst <= '0';
	  --clr <= '0';
	  wait for 2*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(31,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(50,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(40,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(40,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(10,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  
	  D<=std_logic_vector(to_unsigned(55,8));
	  we<='1';
	 	  
	  start <= '1';
	  wait for clk_period;
	  start <= '0';
	  we<='0';
	  
	  wait for 5*clk_period;
	  wait for 2*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(0,6));
	  
	  wait for 4*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(1,6));
	  
	  wait for 4*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(2,6));
	  
	  wait for 4*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(3,6));
	  
	  wait for 4*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(4,6));
	  
	  wait for 4*clk_period;
	  
	  r_addr<=std_logic_vector(to_unsigned(5,6));
	  

      wait;
   end process;

END;
