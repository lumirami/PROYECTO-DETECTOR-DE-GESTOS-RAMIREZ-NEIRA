library ieee;
use ieee.std_logic_1164.all;

entity registro_sost is
	generic( n: integer := 4);
	port (
		Resetn, clock: in std_logic;
		en	: in std_logic;
		ent: in std_logic_vector(n-1 downTo 0);
		Q : out std_logic_vector(n-1 downTo 0)
	);
end registro_sost;

Architecture sol of registro_sost is
begin
	process (Resetn, clock)
	begin
		if Resetn = '0' then Q <= (others => '0');
		elsif (clock'event and clock = '1') then
			if en = '1' then
				Q <= ent;
			end if;
		end if;
	end process;
end sol;