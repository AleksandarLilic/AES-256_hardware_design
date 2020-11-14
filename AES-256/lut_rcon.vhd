library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity lut_rcon is
	port(	pi_address	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0); -- 8bit address input
		po_data		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)  -- 8bit data output
	);
end lut_rcon;

architecture behavioral of lut_rcon is
begin
	lookup_proc: process(pi_address)
	begin
		case pi_address is
			 when x"08" =>	
	 			 po_data <= x"01000000";
			 when x"10" =>	
	 			 po_data <= x"02000000";
			 when x"18" =>	
	 			 po_data <= x"04000000";
			 when x"20" =>	
	 			 po_data <= x"08000000";
			 when x"28" =>	
	 			 po_data <= x"10000000";
			 when x"30" =>	
	 			 po_data <= x"20000000";
			 when x"38" =>	
	 			 po_data <= x"40000000";
			 when others =>	
	 			 po_data <= x"00000000"; 
		end case;
	end process;
end behavioral;