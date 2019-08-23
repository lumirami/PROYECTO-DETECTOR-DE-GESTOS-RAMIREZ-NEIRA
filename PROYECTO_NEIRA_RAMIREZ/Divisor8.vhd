library ieee;
use ieee.std_logic_1164.all;

entity Divisor8 is
	Port(
		ent: in std_logic_vector(18 downTo 0);
		sal: out std_logic_vector(15 downTo 0)
	);
end Divisor8;

Architecture sol of Divisor8 is

Begin
	sal <= ent(18 downTo 3);
end sol;