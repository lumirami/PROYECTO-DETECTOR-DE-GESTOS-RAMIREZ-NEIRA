library ieee;
use ieee.std_logic_1164.all;

entity asm is
	Port(
		Resetn, clock: in std_logic;
		start, izq, der, delante, atras, stop, fin500, fin2s, finsec, secuencia: in std_logic;
		En500, Ld500, selx, sely, en2s, ld2s, enMost, enc, ldc, selD, enGuard, selMost: out std_logic;
		SelSalida: out std_logic_vector(3 downTo 0);
		est: out std_logic_vector(4 downTo 0);
		goConf: out std_logic
	);
end asm;

Architecture sol of asm is
	type estado is (s0, s1, s2, s3, s4, s5, s6, s7, s8, s9, s10, s11, s12, s13, s14, s15, s16, s17,s18); --s19
	signal y: estado;
Begin
	-- transiciones
	Process(Resetn, clock)
	begin
		if Resetn = '0' then y <= s0; 
		elsif clock'event and clock = '1' then
			case y is
				when s0 => if start = '1' then y <= s1; end if;
				when s1 => if start = '0' then y <= s2; end if;
				when s2 => if izq = '1' then y <= s3;
								elsif der = '1' then y <= s6; 
								elsif atras = '1' then y <= s9;
								elsif delante = '1' then y <= s13;
								elsif stop = '1' then y <= s14;
								else y <= s2; end if;
				when s3 => if Atras = '1' then y <= s5;
								elsif fin500 = '1' then y <= s4;
								else y <= s3; end if;
				when s4 => if FIn2s = '1' then y <= s2; end if;
				when s5 => if fin2s = '1' then y <= s2; end if;
				when s6 => if Atras = '1' then y <= s7; 
								elsif Fin500 = '1' then y <= s8;
								else y <= s6; end if;
				when s7 => if fin2s = '1' then y <= s2; end if;
				when s8 => if fin2s = '1' then y <= s2; end if;
				when s9 => if izq = '1' then y <= s10;
								elsif Der = '1' then y <= s11;
								elsif Fin500 = '1' then y <= s12;
								else y <= s9; end if;
				when s10 => if fin2s = '1' then y <= s2; end if;
				when s11 => if fin2s = '1' then y <= s2; end if;
				when s12 => if fin2s = '1' then y <= s2; end if;
				when s13 => if fin2s = '1' then y <= s2; end if;
				when s14 => if stop = '0' then y <= s15; end if;
				when s15 => if stop = '1' then y <= s16; 
								elsif secuencia = '1' then y <= s17;
								else y <= s15; end if;
				when s16 => if stop = '0' then y <= s2; end if;
				when s17 => if secuencia = '0' then y <= s18; end if;
				when s18 => if Finsec = '1' then y <= s15; 
								else y <= s18; end if;
			end case;
		end if;
	end process;
	--salidas
	Process(Resetn, clock, fin2s)
	begin
		En500 <= '0'; Ld500 <= '0'; selx <= '0'; sely <= '0'; en2s <= '0'; ld2s <= '0'; enMost <= '0'; enc <= '0'; ldc <= '0'; selD <= '0';
		SelSalida <= "0000"; est <= "00000"; enGuard <= '0'; goConf <= '0';
		case y is
			when s0 => en500 <= '1'; ld500 <= '1'; en2s <= '1'; ld2s <= '1'; selD <= '1'; enGuard <= '1';
							selx <= '1'; sely <= '1'; est <= "00000";
			when s1 => est <= "00001"; goConf <= '1';
			when s2 => en2s <= '1'; ld2s <= '1'; est <= "00010";
			when s3 => En500 <= '1'; est <= "00011";
			when s4 => En500 <= '1'; ld500 <= '1'; EnMost <= '1'; selSalida(1) <= '1'; en2s <= '1'; est <= "00100";
							if fin2s <= '1' then EnGuard <= '1'; end if;
			when s5 => En500 <= '1'; Ld500 <= '1'; EnMost <= '1'; SelSalida(2) <= '1'; en2s <= '1'; est <= "00101";
							if fin2s <= '1' then Enguard <= '1'; end if;
			when s6 => en500 <= '1'; est <= "00110";
			when s7 => En500 <= '1'; ld500 <= '1'; enmost <= '1'; En2s <= '1'; selSalida(2) <= '1'; selSalida(0) <= '1'; est <= "00111";
							if fin2s <= '1' then ENGuard <= '1'; end if;
			when s8 => En500 <= '1'; ld500 <= '1'; EnMost <= '1'; selSalida(0) <= '1'; En2s <= '1'; selsalida(1) <= '1'; est <= "01000";
							if fin2s <= '1' then EnGuard <= '1'; end if;
			when s9 => en500 <= '1'; est <= "01001";
			when s10 => selSalida(2) <= '1'; En2s <= '1'; SelSalida(1) <= '1'; en500 <= '1'; ld500 <= '1'; enMost <= '1'; est <= "01010";
							if fin2s <= '1' then enguard <= '1'; end if;
			when s11 => selSalida(2) <= '1'; selSalida(1) <= '1'; selSalida(0) <= '1'; enMost <= '1'; en2s <= '1'; en500 <= '1'; ld500 <= '1'; est <= "01011";
							if fin2s <= '1' then enGuard <= '1'; end if;
			when s12 => en500 <= '1'; ld500 <= '1'; enMost <= '1'; selSalida(0) <= '1'; en2s <= '1'; est <= "01100";
							if fin2s <= '1' then enGuard <= '1'; end if;
			when s13 => EnMost <= '1'; En2s <= '1'; est <= "01101";
							if fin2s <= '1' then enguard <= '1'; end if;
			when s14 => est <= "01110";
			when s15 => est <= "01111";
			when s16 => est <= "10000";
			when s17 => est <= "10001";
			when s18 => enMost <= '1'; selMost <= '1'; en2s <= '1'; est <= "10010";
							if finsec = '0' and fin2s = '1' then En2s <= '1'; ld2s <= '1'; enC <= '1'; end if;
		end case;
	end process;
end sol;