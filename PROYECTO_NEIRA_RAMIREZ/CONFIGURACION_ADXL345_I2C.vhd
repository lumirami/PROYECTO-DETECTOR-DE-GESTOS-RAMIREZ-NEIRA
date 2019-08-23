LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY CONFIGURACION_ADXL345_I2C is
	PORT(
		CLOCK_50:	IN	STD_LOGIC;
		KEY:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		I2C_SDAT: INOUT	STD_LOGIC;
		I2C_SCLK: OUT STD_LOGIC;
		LED: OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
	);
END CONFIGURACION_ADXL345_I2C;

ARCHITECTURE SOLUCION OF CONFIGURACION_ADXL345_I2C IS
SIGNAL resetn, GO, SDI, SCLK: STD_LOGIC;
SIGNAL SD_COUNTER: INTEGER  RANGE 0 TO 127;
SIGNAL COUNT: STD_LOGIC_VECTOR(9 downto 0);
BEGIN
	RESETN <= KEY(0);
	Process(CLOCK_50)
	BEGIN
		IF(RISING_EDGE(CLOCK_50)) THEN COUNT<=COUNT+1;
		END IF;
	END PROCESS;
	
	Process(COUNT(9), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			GO<='0';
		ELSIF(FALLING_EDGE(KEY(1))) THEN
			GO<='1';
		END IF;
	END PROCESS;
	
	PROCESS(COUNT(9), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			SD_COUNTER<=0;
		ELSIF(RISING_EDGE(COUNT(9))) THEN
			IF(GO/='1') THEN
				SD_COUNTER<=0;
			ELSIF(SD_COUNTER<67) THEN
				SD_COUNTER<=SD_COUNTER+1;
			END IF;
		END IF;
	END PROCESS;

--i2C OPERATION
	PROCESS(COUNT(9), RESETN)
	BEGIN
		IF(RESETN/='1') THEN
			SCLK<='1';
			SDI<='1';
		ELSIF(RISING_EDGE(COUNT(9))) THEN
			CASE(SD_COUNTER) IS

--*********************************REGISTRO POWER_CTL(0X2D)************************************************************			
			--START
				WHEN 0	=>	SDI<='1'; SCLK<='1';
				WHEN 1	=>	SDI<='0';
				WHEN 2	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 3	=>	SDI<='0';
				WHEN 4	=>	SDI<='0';--************************************************
				WHEN 5	=>	SDI<='1';
				WHEN 6	=>	SDI<='1';
				WHEN 7	=>	SDI<='1';
				WHEN 8	=>	SDI<='0';
				WHEN 9	=>	SDI<='1';
				WHEN 10	=>	SDI<='0';
				WHEN 11	=>	SDI<='Z';--Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A ESCRIBIR)
				WHEN 12	=>	SDI<='0';
				WHEN 13	=>	SDI<='0';
				WHEN 14	=>	SDI<='1';
				WHEN 15	=>	SDI<='0';
				WHEN 16	=>	SDI<='1';
				WHEN 17	=>	SDI<='1';
				WHEN 18	=>	SDI<='0';
				WHEN 19	=>	SDI<='1';--POWER_CTL(0X2D)
				WHEN 20	=>	SDI<='Z';--Slave ACK
				
			--DATA
				WHEN 21	=>	SDI<='0';
				WHEN 22	=>	SDI<='0';
				WHEN 23	=>	SDI<='0';
				WHEN 24	=>	SDI<='0';
				WHEN 25	=>	SDI<='1';
				WHEN 26	=>	SDI<='0';
				WHEN 27	=>	SDI<='0';
				WHEN 28	=>	SDI<='0';--HABILITAR MEASURE(0X08)
				WHEN 29	=>	SDI<='Z';--Slave ACK

			--STOP
				WHEN 30	=>	SDI<='0';--****************************************
				WHEN 31	=>	SCLK<='1';
				WHEN 32	=>	SDI <= '1';
				
				
--************************************REGISTRO DATA_FORMAT(0X31)*********************************************************			
			--START
				WHEN 34	=>	SDI<='1'; SCLK<='1';
				WHEN 35	=>	SDI<='0';
				WHEN 36	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 37	=>	SDI<='0';
				WHEN 38	=>	SDI<='0';--************************************************
				WHEN 39	=>	SDI<='1';
				WHEN 40	=>	SDI<='1';
				WHEN 41	=>	SDI<='1';
				WHEN 42	=>	SDI<='0';
				WHEN 43	=>	SDI<='1';
				WHEN 44	=>	SDI<='0';
				WHEN 45	=>	SDI<='Z';--Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A ESCRIBIR)
				WHEN 46	=>	SDI<='0';
				WHEN 47	=>	SDI<='0';
				WHEN 48	=>	SDI<='1';
				WHEN 49	=>	SDI<='1';
				WHEN 50	=>	SDI<='0';
				WHEN 51	=>	SDI<='0';
				WHEN 52	=>	SDI<='0';
				WHEN 53	=>	SDI<='1';--DATA_FORMAT(0X31)
				WHEN 54	=>	SDI<='Z';--Slave ACK
				
			--DATA
				WHEN 55	=>	SDI<='0';
				WHEN 56	=>	SDI<='0';
				WHEN 57	=>	SDI<='0';
				WHEN 58	=>	SDI<='0';
				WHEN 59	=>	SDI<='1';
				WHEN 60	=>	SDI<='0';
				WHEN 61	=>	SDI<='1';
				WHEN 62	=>	SDI<='1';--HABILITAR FULL_RES, RANGE 11 (0X0B)-- +-16G
				WHEN 63	=>	SDI<='Z';--Slave ACK

			--STOP
				WHEN 64	=>	SDI<='0';--****************************************
				WHEN 65	=>	SCLK<='1';
				WHEN 66	=>	SDI <= '1';
				
				WHEN OTHERS =>	SDI<='1'; SCLK<='1';
			END CASE;
		END IF;
	END PROCESS;
	
	I2C_SCLK<= NOT(COUNT(9)) WHEN (((SD_COUNTER >= 4) AND (SD_COUNTER <= 30)) OR ((SD_COUNTER >= 38) AND (SD_COUNTER <= 64)) ) ELSE SCLK;
	I2C_SDAT<= SDI;
END SOLUCION;	