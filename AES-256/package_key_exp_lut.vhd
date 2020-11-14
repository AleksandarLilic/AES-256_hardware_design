library IEEE;
use IEEE.STD_LOGIC_1164.all;

package package_key_exp_lut is

component lut_sbox is
	port(	pi_address	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0); -- 8bit address input
		po_data		: OUT	STD_LOGIC_VECTOR( 7 DOWNTO 0)  -- 8bit data output
	);
end component;

component lut_rcon is
	port(	pi_address	: IN 	STD_LOGIC_VECTOR( 7 DOWNTO 0); -- 8bit address input
		po_data		: OUT	STD_LOGIC_VECTOR(31 DOWNTO 0)  -- 8bit data output
	);
end component;

end package_key_exp_lut;