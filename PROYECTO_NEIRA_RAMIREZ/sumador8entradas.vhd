library ieee; 
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
entity sumador8entradas is 
	generic( n: integer :=4);
	port( 
			a,b, c, d, e, f, g, h: in std_logic_vector(n-1 downto 0);
			s: out std_logic_vector(n+2 downto 0)
			);
			
end sumador8entradas;
architecture comp of sumador8entradas is 
	signal int1,int2,int3,int4, int5, int6, int7, int8: std_logic_vector(n+2 downto 0);
	begin 
		int1(n+2 downto n)<="000"; int1(n-1 downto 0)<=a;
		int2(n+2 downto n)<="000"; int2(n-1 downto 0)<=b;
		int3(n+2 downto n)<="000"; int3(n-1 downto 0)<=c;
		int4(n+2 downto n)<="000"; int4(n-1 downto 0)<=d;
		int5(n+2 downto n)<="000"; int5(n-1 downto 0)<=e;
		int6(n+2 downto n)<="000"; int6(n-1 downto 0)<=f;
		int7(n+2 downto n)<="000"; int7(n-1 downto 0)<=g;
		int8(n+2 downto n)<="000"; int8(n-1 downto 0)<=h;
		s <= int1+int2+int3+int4+int5+int6+int7+int8;
   end comp;		
		