library ieee;
use ieee.std_logic_1164.all;

entity Conv_7seg is
	Port(
		ent:	in std_logic_vector(3 downto 0);
		en:	in std_logic;
		Sal:	out std_logic_vector(6 downTo 0)
		);
end Conv_7seg;

Architecture sol of Conv_7seg is
	signal temp: std_logic_vector(6 downTo 0);
begin
	with ent select 
		temp <= "1111110" when "0000",
					"0110000" when "0001",
					"1101101" when "0010",
					"1111001" when "0011",
					"0110011" when "0100",
					"1011011" when "0101",
					"1011111" when "0110",
					"1110000" when "0111",
					"1111111" when "1000",
					"1110011" when "1001",
					"0000000" when others;
	sal <= "0000000" when en = '0' else temp;
end sol;