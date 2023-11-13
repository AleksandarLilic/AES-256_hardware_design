library IEEE;
use IEEE.STD_LOGIC_1164.all;

entity lut_sbox is
	port(	pi_address	: IN 	STD_LOGIC_VECTOR(7 DOWNTO 0); -- 8bit address input
		po_data		: OUT	STD_LOGIC_VECTOR(7 DOWNTO 0)  -- 8bit data output
	);
end lut_sbox;

architecture behavioral of lut_sbox is
begin
	lookup_proc: process(pi_address)
	begin
		case pi_address is
			 when x"00" =>	
	 			 po_data <= x"63"; 
			 when x"01" =>	
	 			 po_data <= x"7c"; 
			 when x"02" =>	
	 			 po_data <= x"77"; 
			 when x"03" =>	
	 			 po_data <= x"7b"; 
			 when x"04" =>	
	 			 po_data <= x"f2"; 
			 when x"05" =>	
	 			 po_data <= x"6b"; 
			 when x"06" =>	
	 			 po_data <= x"6f"; 
			 when x"07" =>	
	 			 po_data <= x"c5"; 
			 when x"08" =>	
	 			 po_data <= x"30"; 
			 when x"09" =>	
	 			 po_data <= x"01"; 
			 when x"0a" =>	
	 			 po_data <= x"67"; 
			 when x"0b" =>	
	 			 po_data <= x"2b"; 
			 when x"0c" =>	
	 			 po_data <= x"fe"; 
			 when x"0d" =>	
	 			 po_data <= x"d7"; 
			 when x"0e" =>	
	 			 po_data <= x"ab"; 
			 when x"0f" =>	
	 			 po_data <= x"76";
			 when x"10" =>	
	 			 po_data <= x"ca"; 
			 when x"11" =>	
	 			 po_data <= x"82"; 
			 when x"12" =>	
	 			 po_data <= x"c9"; 
			 when x"13" =>	
	 			 po_data <= x"7d"; 
			 when x"14" =>	
	 			 po_data <= x"fa"; 
			 when x"15" =>	
	 			 po_data <= x"59"; 
			 when x"16" =>	
	 			 po_data <= x"47"; 
			 when x"17" =>	
	 			 po_data <= x"f0"; 
			 when x"18" =>	
	 			 po_data <= x"ad"; 
			 when x"19" =>	
	 			 po_data <= x"d4"; 
			 when x"1a" =>	
	 			 po_data <= x"a2"; 
			 when x"1b" =>	
	 			 po_data <= x"af"; 
			 when x"1c" =>	
	 			 po_data <= x"9c"; 
			 when x"1d" =>	
	 			 po_data <= x"a4"; 
			 when x"1e" =>	
	 			 po_data <= x"72"; 
			 when x"1f" =>	
	 			 po_data <= x"c0";
			 when x"20" =>	
	 			 po_data <= x"b7"; 
			 when x"21" =>	
	 			 po_data <= x"fd"; 
			 when x"22" =>	
	 			 po_data <= x"93"; 
			 when x"23" =>	
	 			 po_data <= x"26"; 
			 when x"24" =>	
	 			 po_data <= x"36"; 
			 when x"25" =>	
	 			 po_data <= x"3f"; 
			 when x"26" =>	
	 			 po_data <= x"f7"; 
			 when x"27" =>	
	 			 po_data <= x"cc"; 
			 when x"28" =>	
	 			 po_data <= x"34"; 
			 when x"29" =>	
	 			 po_data <= x"a5"; 
			 when x"2a" =>	
	 			 po_data <= x"e5"; 
			 when x"2b" =>	
	 			 po_data <= x"f1"; 
			 when x"2c" =>	
	 			 po_data <= x"71"; 
			 when x"2d" =>	
	 			 po_data <= x"d8"; 
			 when x"2e" =>	
	 			 po_data <= x"31"; 
			 when x"2f" =>	
	 			 po_data <= x"15";
			 when x"30" =>	
	 			 po_data <= x"04"; 
			 when x"31" =>	
	 			 po_data <= x"c7"; 
			 when x"32" =>	
	 			 po_data <= x"23"; 
			 when x"33" =>	
	 			 po_data <= x"c3"; 
			 when x"34" =>	
	 			 po_data <= x"18"; 
			 when x"35" =>	
	 			 po_data <= x"96"; 
			 when x"36" =>	
	 			 po_data <= x"05"; 
			 when x"37" =>	
	 			 po_data <= x"9a"; 
			 when x"38" =>	
	 			 po_data <= x"07"; 
			 when x"39" =>	
	 			 po_data <= x"12"; 
			 when x"3a" =>	
	 			 po_data <= x"80"; 
			 when x"3b" =>	
	 			 po_data <= x"e2"; 
			 when x"3c" =>	
	 			 po_data <= x"eb"; 
			 when x"3d" =>	
	 			 po_data <= x"27"; 
			 when x"3e" =>	
	 			 po_data <= x"b2"; 
			 when x"3f" =>	
	 			 po_data <= x"75";
			 when x"40" =>	
	 			 po_data <= x"09"; 
			 when x"41" =>	
	 			 po_data <= x"83"; 
			 when x"42" =>	
	 			 po_data <= x"2c"; 
			 when x"43" =>	
	 			 po_data <= x"1a"; 
			 when x"44" =>	
	 			 po_data <= x"1b"; 
			 when x"45" =>	
	 			 po_data <= x"6e"; 
			 when x"46" =>	
	 			 po_data <= x"5a"; 
			 when x"47" =>	
	 			 po_data <= x"a0"; 
			 when x"48" =>	
	 			 po_data <= x"52"; 
			 when x"49" =>	
	 			 po_data <= x"3b"; 
			 when x"4a" =>	
	 			 po_data <= x"d6"; 
			 when x"4b" =>	
	 			 po_data <= x"b3"; 
			 when x"4c" =>	
	 			 po_data <= x"29"; 
			 when x"4d" =>	
	 			 po_data <= x"e3"; 
			 when x"4e" =>	
	 			 po_data <= x"2f"; 
			 when x"4f" =>	
	 			 po_data <= x"84";
			 when x"50" =>	
	 			 po_data <= x"53"; 
			 when x"51" =>	
	 			 po_data <= x"d1"; 
			 when x"52" =>	
	 			 po_data <= x"00"; 
			 when x"53" =>	
	 			 po_data <= x"ed"; 
			 when x"54" =>	
	 			 po_data <= x"20"; 
			 when x"55" =>	
	 			 po_data <= x"fc"; 
			 when x"56" =>	
	 			 po_data <= x"b1"; 
			 when x"57" =>	
	 			 po_data <= x"5b"; 
			 when x"58" =>	
	 			 po_data <= x"6a"; 
			 when x"59" =>	
	 			 po_data <= x"cb"; 
			 when x"5a" =>	
	 			 po_data <= x"be"; 
			 when x"5b" =>	
	 			 po_data <= x"39"; 
			 when x"5c" =>	
	 			 po_data <= x"4a"; 
			 when x"5d" =>	
	 			 po_data <= x"4c"; 
			 when x"5e" =>	
	 			 po_data <= x"58"; 
			 when x"5f" =>	
	 			 po_data <= x"cf";
			 when x"60" =>	
	 			 po_data <= x"d0"; 
			 when x"61" =>	
	 			 po_data <= x"ef"; 
			 when x"62" =>	
	 			 po_data <= x"aa"; 
			 when x"63" =>	
	 			 po_data <= x"fb"; 
			 when x"64" =>	
	 			 po_data <= x"43"; 
			 when x"65" =>	
	 			 po_data <= x"4d"; 
			 when x"66" =>	
	 			 po_data <= x"33"; 
			 when x"67" =>	
	 			 po_data <= x"85"; 
			 when x"68" =>	
	 			 po_data <= x"45"; 
			 when x"69" =>	
	 			 po_data <= x"f9"; 
			 when x"6a" =>	
	 			 po_data <= x"02"; 
			 when x"6b" =>	
	 			 po_data <= x"7f"; 
			 when x"6c" =>	
	 			 po_data <= x"50"; 
			 when x"6d" =>	
	 			 po_data <= x"3c"; 
			 when x"6e" =>	
	 			 po_data <= x"9f"; 
			 when x"6f" =>	
	 			 po_data <= x"a8";
			 when x"70" =>	
	 			 po_data <= x"51"; 
			 when x"71" =>	
	 			 po_data <= x"a3"; 
			 when x"72" =>	
	 			 po_data <= x"40"; 
			 when x"73" =>	
	 			 po_data <= x"8f"; 
			 when x"74" =>	
	 			 po_data <= x"92"; 
			 when x"75" =>	
	 			 po_data <= x"9d"; 
			 when x"76" =>	
	 			 po_data <= x"38"; 
			 when x"77" =>	
	 			 po_data <= x"f5"; 
			 when x"78" =>	
	 			 po_data <= x"bc"; 
			 when x"79" =>	
	 			 po_data <= x"b6"; 
			 when x"7a" =>	
	 			 po_data <= x"da"; 
			 when x"7b" =>	
	 			 po_data <= x"21"; 
			 when x"7c" =>	
	 			 po_data <= x"10"; 
			 when x"7d" =>	
	 			 po_data <= x"ff"; 
			 when x"7e" =>	
	 			 po_data <= x"f3"; 
			 when x"7f" =>	
	 			 po_data <= x"d2";
			 when x"80" =>	
	 			 po_data <= x"cd"; 
			 when x"81" =>	
	 			 po_data <= x"0c"; 
			 when x"82" =>	
	 			 po_data <= x"13"; 
			 when x"83" =>	
	 			 po_data <= x"ec"; 
			 when x"84" =>	
	 			 po_data <= x"5f"; 
			 when x"85" =>	
	 			 po_data <= x"97"; 
			 when x"86" =>	
	 			 po_data <= x"44"; 
			 when x"87" =>	
	 			 po_data <= x"17"; 
			 when x"88" =>	
	 			 po_data <= x"c4"; 
			 when x"89" =>	
	 			 po_data <= x"a7"; 
			 when x"8a" =>	
	 			 po_data <= x"7e"; 
			 when x"8b" =>	
	 			 po_data <= x"3d"; 
			 when x"8c" =>	
	 			 po_data <= x"64"; 
			 when x"8d" =>	
	 			 po_data <= x"5d"; 
			 when x"8e" =>	
	 			 po_data <= x"19"; 
			 when x"8f" =>	
	 			 po_data <= x"73";
			 when x"90" =>	
	 			 po_data <= x"60"; 
			 when x"91" =>	
	 			 po_data <= x"81"; 
			 when x"92" =>	
	 			 po_data <= x"4f"; 
			 when x"93" =>	
	 			 po_data <= x"dc"; 
			 when x"94" =>	
	 			 po_data <= x"22"; 
			 when x"95" =>	
	 			 po_data <= x"2a"; 
			 when x"96" =>	
	 			 po_data <= x"90"; 
			 when x"97" =>	
	 			 po_data <= x"88"; 
			 when x"98" =>	
	 			 po_data <= x"46"; 
			 when x"99" =>	
	 			 po_data <= x"ee"; 
			 when x"9a" =>	
	 			 po_data <= x"b8"; 
			 when x"9b" =>	
	 			 po_data <= x"14"; 
			 when x"9c" =>	
	 			 po_data <= x"de"; 
			 when x"9d" =>	
	 			 po_data <= x"5e"; 
			 when x"9e" =>	
	 			 po_data <= x"0b"; 
			 when x"9f" =>	
	 			 po_data <= x"db";
			 when x"a0" =>	
	 			 po_data <= x"e0"; 
			 when x"a1" =>	
	 			 po_data <= x"32"; 
			 when x"a2" =>	
	 			 po_data <= x"3a"; 
			 when x"a3" =>	
	 			 po_data <= x"0a"; 
			 when x"a4" =>	
	 			 po_data <= x"49"; 
			 when x"a5" =>	
	 			 po_data <= x"06"; 
			 when x"a6" =>	
	 			 po_data <= x"24"; 
			 when x"a7" =>	
	 			 po_data <= x"5c"; 
			 when x"a8" =>	
	 			 po_data <= x"c2"; 
			 when x"a9" =>	
	 			 po_data <= x"d3"; 
			 when x"aa" =>	
	 			 po_data <= x"ac"; 
			 when x"ab" =>	
	 			 po_data <= x"62"; 
			 when x"ac" =>	
	 			 po_data <= x"91"; 
			 when x"ad" =>	
	 			 po_data <= x"95"; 
			 when x"ae" =>	
	 			 po_data <= x"e4"; 
			 when x"af" =>	
	 			 po_data <= x"79";
			 when x"b0" =>	
	 			 po_data <= x"e7"; 
			 when x"b1" =>	
	 			 po_data <= x"c8"; 
			 when x"b2" =>	
	 			 po_data <= x"37"; 
			 when x"b3" =>	
	 			 po_data <= x"6d"; 
			 when x"b4" =>	
	 			 po_data <= x"8d"; 
			 when x"b5" =>	
	 			 po_data <= x"d5"; 
			 when x"b6" =>	
	 			 po_data <= x"4e"; 
			 when x"b7" =>	
	 			 po_data <= x"a9"; 
			 when x"b8" =>	
	 			 po_data <= x"6c"; 
			 when x"b9" =>	
	 			 po_data <= x"56"; 
			 when x"ba" =>	
	 			 po_data <= x"f4"; 
			 when x"bb" =>	
	 			 po_data <= x"ea"; 
			 when x"bc" =>	
	 			 po_data <= x"65"; 
			 when x"bd" =>	
	 			 po_data <= x"7a"; 
			 when x"be" =>	
	 			 po_data <= x"ae"; 
			 when x"bf" =>	
	 			 po_data <= x"08";
			 when x"c0" =>	
	 			 po_data <= x"ba"; 
			 when x"c1" =>	
	 			 po_data <= x"78"; 
			 when x"c2" =>	
	 			 po_data <= x"25"; 
			 when x"c3" =>	
	 			 po_data <= x"2e"; 
			 when x"c4" =>	
	 			 po_data <= x"1c"; 
			 when x"c5" =>	
	 			 po_data <= x"a6"; 
			 when x"c6" =>	
	 			 po_data <= x"b4"; 
			 when x"c7" =>	
	 			 po_data <= x"c6"; 
			 when x"c8" =>	
	 			 po_data <= x"e8"; 
			 when x"c9" =>	
	 			 po_data <= x"dd"; 
			 when x"ca" =>	
	 			 po_data <= x"74"; 
			 when x"cb" =>	
	 			 po_data <= x"1f"; 
			 when x"cc" =>	
	 			 po_data <= x"4b"; 
			 when x"cd" =>	
	 			 po_data <= x"bd"; 
			 when x"ce" =>	
	 			 po_data <= x"8b"; 
			 when x"cf" =>	
	 			 po_data <= x"8a";
			 when x"d0" =>	
	 			 po_data <= x"70"; 
			 when x"d1" =>	
	 			 po_data <= x"3e"; 
			 when x"d2" =>	
	 			 po_data <= x"b5"; 
			 when x"d3" =>	
	 			 po_data <= x"66"; 
			 when x"d4" =>	
	 			 po_data <= x"48"; 
			 when x"d5" =>	
	 			 po_data <= x"03"; 
			 when x"d6" =>	
	 			 po_data <= x"f6"; 
			 when x"d7" =>	
	 			 po_data <= x"0e"; 
			 when x"d8" =>	
	 			 po_data <= x"61"; 
			 when x"d9" =>	
	 			 po_data <= x"35"; 
			 when x"da" =>	
	 			 po_data <= x"57"; 
			 when x"db" =>	
	 			 po_data <= x"b9"; 
			 when x"dc" =>	
	 			 po_data <= x"86"; 
			 when x"dd" =>	
	 			 po_data <= x"c1"; 
			 when x"de" =>	
	 			 po_data <= x"1d"; 
			 when x"df" =>	
	 			 po_data <= x"9e";
			 when x"e0" =>	
	 			 po_data <= x"e1"; 
			 when x"e1" =>	
	 			 po_data <= x"f8"; 
			 when x"e2" =>	
	 			 po_data <= x"98"; 
			 when x"e3" =>	
	 			 po_data <= x"11"; 
			 when x"e4" =>	
	 			 po_data <= x"69"; 
			 when x"e5" =>	
	 			 po_data <= x"d9"; 
			 when x"e6" =>	
	 			 po_data <= x"8e"; 
			 when x"e7" =>	
	 			 po_data <= x"94"; 
			 when x"e8" =>	
	 			 po_data <= x"9b"; 
			 when x"e9" =>	
	 			 po_data <= x"1e"; 
			 when x"ea" =>	
	 			 po_data <= x"87"; 
			 when x"eb" =>	
	 			 po_data <= x"e9"; 
			 when x"ec" =>	
	 			 po_data <= x"ce"; 
			 when x"ed" =>	
	 			 po_data <= x"55"; 
			 when x"ee" =>	
	 			 po_data <= x"28"; 
			 when x"ef" =>	
	 			 po_data <= x"df";
			 when x"f0" =>	
	 			 po_data <= x"8c"; 
			 when x"f1" =>	
	 			 po_data <= x"a1"; 
			 when x"f2" =>	
	 			 po_data <= x"89"; 
			 when x"f3" =>	
	 			 po_data <= x"0d"; 
			 when x"f4" =>	
	 			 po_data <= x"bf"; 
			 when x"f5" =>	
	 			 po_data <= x"e6"; 
			 when x"f6" =>	
	 			 po_data <= x"42"; 
			 when x"f7" =>	
	 			 po_data <= x"68"; 
			 when x"f8" =>	
	 			 po_data <= x"41"; 
			 when x"f9" =>	
	 			 po_data <= x"99"; 
			 when x"fa" =>	
	 			 po_data <= x"2d"; 
			 when x"fb" =>	
	 			 po_data <= x"0f"; 
			 when x"fc" =>	
	 			 po_data <= x"b0"; 
			 when x"fd" =>	
	 			 po_data <= x"54"; 
			 when x"fe" =>	
	 			 po_data <= x"bb"; 
			 when others =>	
	 			 po_data <= x"16";			
		end case;
	end process;
end behavioral;	