library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity sumador is 
	generic( n: integer :=4);
	port( ci: in std_logic;
			a,b: in std_logic_vector(n-1 downto 0);
			s: out std_logic_vector(n-1 downto 0);
			co : out std_logic);
			
end sumador;
architecture comp of sumador is 
	signal int1,int2,int3,int4 : std_logic_vector(n downto 0);
	begin 
		int1(n)<='0'; int1(n-1 downto 0)<=a;
		int2(n)<='0'; int2(n-1 downto 0)<=b;
		int3<=int1+int2+ci;
		co<=int3(n);
		s <= int3(n-1 downto 0);
   end comp;		
		