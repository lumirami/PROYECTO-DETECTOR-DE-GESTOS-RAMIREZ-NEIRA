library ieee;
use ieee.std_logic_1164.all;

Entity comparador is
	Generic(n: integer:=4);
	Port(A, B : in std_logic_vector(n-1 downTo 0);
			men, igu, may : out std_logic);
end comparador;

Architecture sol of comparador is

Begin
	men <= '1' when A < B else '0';
	igu <= '1' when A = B else '0';
	may <= '1' when A > B else '0';
end sol;