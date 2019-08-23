library ieee;
use ieee.std_logic_1164.all;

entity Mux16a1 is
	generic(n: integer:=4);
	port( sel  : in std_logic_vector(3 downTo 0);
			ent0, ent1, ent2, ent3, ent4, ent5, ent6, ent7, ent8 : in std_logic_vector(n-1 downTo 0);
			ent9, enti10, enti11, enti12, enti13, enti14, enti15 : in std_logic_vector(n-1 downTo 0);
			s : out std_logic_vector(n-1 downTo 0));
end Mux16a1;

Architecture sol of Mux16a1 is

Begin
	with sel select
		s <= ent0 when "0000",
				ent1 when "0001",
				ent2 when "0010",
				ent3 when "0011",
				ent4 when "0100",
				ent5 when "0101",
				ent6 when "0110",
				ent7 when "0111",
				ent8 when "1000",
				ent9 when "1001",
				enti10 when "1010",
				enti11 when "1011",
				enti12 when "1100",
				enti13 when "1101",
				enti14 when "1110",
				enti15 when others;
end sol;