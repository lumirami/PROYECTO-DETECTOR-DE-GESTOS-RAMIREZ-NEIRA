library ieee;
use ieee.std_logic_1164.all;

entity Mux2a1 is
	generic(n: integer:=4);
	port( sel  : in std_logic;
			ent0, ent1 : in std_logic_vector(n-1 downTo 0);
			s : out std_logic_vector(n-1 downTo 0));
end Mux2a1;

Architecture sol of Mux2a1 is

Begin
	with sel select
		s <= ent0 when '0',
				ent1 when others;
end sol;