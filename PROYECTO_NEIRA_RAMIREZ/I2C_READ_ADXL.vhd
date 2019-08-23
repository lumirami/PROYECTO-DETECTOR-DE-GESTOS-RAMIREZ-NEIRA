LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_UNSIGNED.ALL;


ENTITY I2C_READ_ADXL is
	PORT(
		CLOCK_50:	IN	STD_LOGIC;
		KEY:	IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		I2C_SDAT: INOUT	STD_LOGIC;
		I2C_SCLK: OUT STD_LOGIC;
		CS: OUT	STD_LOGIC;
		LED_X: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		LED_Y: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);
		LED_Z: OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
	);
END I2C_READ_ADXL;

ARCHITECTURE SOLUCION OF I2C_READ_ADXL IS
SIGNAL resetn, GO, SDI, SCLK: STD_LOGIC;
SIGNAL SD_COUNTER: INTEGER  RANGE 0 TO 300;
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
			ELSIF(SD_COUNTER<286) THEN
				SD_COUNTER<=SD_COUNTER+1;
			ELSE
				SD_COUNTER<=0;
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
			
--****************************************X0*****************************************************			
			--START
				WHEN 0	=>	SDI<='1'; SCLK<='1';
				WHEN 1	=>	SDI<='0';
				WHEN 2	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 3	=>	SDI<='0';
				WHEN 4	=>	SDI<='0';---******************************
				WHEN 5	=>	SDI<='1';
				WHEN 6	=>	SDI<='1';
				WHEN 7	=>	SDI<='1';
				WHEN 8	=>	SDI<='0';
				WHEN 9	=>	SDI<='1';
				WHEN 10	=>	SDI<='0';
				WHEN 11	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 12	=>	SDI<='0';
				WHEN 13	=>	SDI<='0';
				WHEN 14	=>	SDI<='1';
				WHEN 15	=>	SDI<='1';
				WHEN 16	=>	SDI<='0';
				WHEN 17	=>	SDI<='0';
				WHEN 18	=>	SDI<='1';
				WHEN 19	=>	SDI<='0';
				WHEN 20	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 21	=>
				
			--START
				WHEN 22	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 23	=>	SDI<='0';
				WHEN 24	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 25	=>	SDI<='0';
				WHEN 26	=>	SDI<='0';---*****************************
				WHEN 27	=>	SDI<='1';
				WHEN 28	=>	SDI<='1';
				WHEN 29	=>	SDI<='1';
				WHEN 30	=>	SDI<='0';
				WHEN 31	=>	SDI<='1';
				WHEN 32	=>	SDI<='1';
				WHEN 33	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 34	=>
				WHEN 35	=>	LED_X(7)<=I2C_SDAT;
				WHEN 36	=>	LED_X(6)<=I2C_SDAT;
				WHEN 37	=>	LED_X(5)<=I2C_SDAT;
				WHEN 38	=>	LED_X(4)<=I2C_SDAT;
				WHEN 39	=>	LED_X(3)<=I2C_SDAT;
				WHEN 40	=>	LED_X(2)<=I2C_SDAT;
				WHEN 41	=>	LED_X(1)<=I2C_SDAT;
				WHEN 42	=>	LED_X(0)<=I2C_SDAT;
				WHEN 43	=> SDI<='0';--TO Slave ACK		
				
			--STOP
				WHEN 44	=>	SDI<='0'; ---*********************************
				WHEN 45	=>	SCLK<='1';
				WHEN 46	=>	SDI <= '1';
				
				
--*****************************************X1************************************************************				
			--START
				WHEN 48	=>	SDI<='1'; SCLK<='1';
				WHEN 49	=>	SDI<='0';
				WHEN 50	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 51	=>	SDI<='0';
				WHEN 52	=>	SDI<='0';---******************************
				WHEN 53	=>	SDI<='1';
				WHEN 54	=>	SDI<='1';
				WHEN 55	=>	SDI<='1';
				WHEN 56	=>	SDI<='0';
				WHEN 57	=>	SDI<='1';
				WHEN 58	=>	SDI<='0';
				WHEN 59	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 60	=>	SDI<='0';
				WHEN 61	=>	SDI<='0';
				WHEN 62	=>	SDI<='1';
				WHEN 63	=>	SDI<='1';
				WHEN 64	=>	SDI<='0';
				WHEN 65	=>	SDI<='0';
				WHEN 66	=>	SDI<='1';
				WHEN 67	=>	SDI<='1';
				WHEN 68	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 69	=>
				
			--START
				WHEN 70	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 71	=>	SDI<='0';
				WHEN 72	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 73	=>	SDI<='0';
				WHEN 74	=>	SDI<='0';---*****************************
				WHEN 75	=>	SDI<='1';
				WHEN 76	=>	SDI<='1';
				WHEN 77	=>	SDI<='1';
				WHEN 78	=>	SDI<='0';
				WHEN 79	=>	SDI<='1';
				WHEN 80	=>	SDI<='1';
				WHEN 81	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 82	=>
				WHEN 83	=>	LED_X(15)<=I2C_SDAT;
				WHEN 84	=>	LED_X(14)<=I2C_SDAT;
				WHEN 85	=>	LED_X(13)<=I2C_SDAT;
				WHEN 86	=>	LED_X(12)<=I2C_SDAT;
				WHEN 87	=>	LED_X(11)<=I2C_SDAT;
				WHEN 88	=>	LED_X(10)<=I2C_SDAT;
				WHEN 89	=>	LED_X(9)<=I2C_SDAT;
				WHEN 90	=>	LED_X(8)<=I2C_SDAT;
				WHEN 91	=> SDI<='1';--TO Slave ACK		
				
			--STOP
				WHEN 92	=>	SDI<='0'; ---*********************************
				WHEN 93	=>	SCLK<='1';
				WHEN 94	=>	SDI <= '1';				
				
--***************************************Y0***********************************************

			--START
				WHEN 96	=>	SDI<='1'; SCLK<='1';
				WHEN 97	=>	SDI<='0';
				WHEN 98	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 99	=>	SDI<='0';
				WHEN 100	=>	SDI<='0';---******************************
				WHEN 101	=>	SDI<='1';
				WHEN 102	=>	SDI<='1';
				WHEN 103	=>	SDI<='1';
				WHEN 104	=>	SDI<='0';
				WHEN 105	=>	SDI<='1';
				WHEN 106	=>	SDI<='0';
				WHEN 107	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 108	=>	SDI<='0';
				WHEN 109	=>	SDI<='0';
				WHEN 110	=>	SDI<='1';
				WHEN 111	=>	SDI<='1';
				WHEN 112	=>	SDI<='0';
				WHEN 113	=>	SDI<='1';
				WHEN 114	=>	SDI<='0';
				WHEN 115	=>	SDI<='0';
				WHEN 116	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 117	=>
				
			--START
				WHEN 118	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 119	=>	SDI<='0';
				WHEN 120	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 121	=>	SDI<='0';
				WHEN 122	=>	SDI<='0';---*****************************
				WHEN 123	=>	SDI<='1';
				WHEN 124	=>	SDI<='1';
				WHEN 125	=>	SDI<='1';
				WHEN 126	=>	SDI<='0';
				WHEN 127	=>	SDI<='1';
				WHEN 128	=>	SDI<='1';
				WHEN 129	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 130	=>
				WHEN 131	=>	LED_Y(7)<=I2C_SDAT;
				WHEN 132	=>	LED_Y(6)<=I2C_SDAT;
				WHEN 133	=>	LED_Y(5)<=I2C_SDAT;
				WHEN 134	=>	LED_Y(4)<=I2C_SDAT;
				WHEN 135	=>	LED_Y(3)<=I2C_SDAT;
				WHEN 136	=>	LED_Y(2)<=I2C_SDAT;
				WHEN 137	=>	LED_Y(1)<=I2C_SDAT;
				WHEN 138	=>	LED_Y(0)<=I2C_SDAT;
				WHEN 139	=> SDI<='1';--TO Slave ACK		
				
			--STOP
				WHEN 140	=>	SDI<='0'; ---*********************************
				WHEN 141	=>	SCLK<='1';
				WHEN 142	=>	SDI <= '1';				
				

--**************************************Y1**********************************************
			
			--START
				WHEN 144	=>	SDI<='1'; SCLK<='1';
				WHEN 145	=>	SDI<='0';
				WHEN 146	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 147	=>	SDI<='0';
				WHEN 148	=>	SDI<='0';---******************************
				WHEN 149	=>	SDI<='1';
				WHEN 150	=>	SDI<='1';
				WHEN 151	=>	SDI<='1';
				WHEN 152	=>	SDI<='0';
				WHEN 153	=>	SDI<='1';
				WHEN 154	=>	SDI<='0';
				WHEN 155	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 156	=>	SDI<='0';
				WHEN 157	=>	SDI<='0';
				WHEN 158	=>	SDI<='1';
				WHEN 159	=>	SDI<='1';
				WHEN 160	=>	SDI<='0';
				WHEN 161	=>	SDI<='1';
				WHEN 162	=>	SDI<='0';
				WHEN 163	=>	SDI<='1';
				WHEN 164	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 165	=>
				
			--START
				WHEN 166	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 167	=>	SDI<='0';
				WHEN 168	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 169	=>	SDI<='0';
				WHEN 170	=>	SDI<='0';---*****************************
				WHEN 171	=>	SDI<='1';
				WHEN 172	=>	SDI<='1';
				WHEN 173	=>	SDI<='1';
				WHEN 174	=>	SDI<='0';
				WHEN 175	=>	SDI<='1';
				WHEN 176	=>	SDI<='1';
				WHEN 177	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 178	=>
				WHEN 179	=>	LED_Y(15)<=I2C_SDAT;
				WHEN 180	=>	LED_Y(14)<=I2C_SDAT;
				WHEN 181	=>	LED_Y(13)<=I2C_SDAT;
				WHEN 182	=>	LED_Y(12)<=I2C_SDAT;
				WHEN 183	=>	LED_Y(11)<=I2C_SDAT;
				WHEN 184	=>	LED_Y(10)<=I2C_SDAT;
				WHEN 185	=>	LED_Y(9)<=I2C_SDAT;
				WHEN 186	=>	LED_Y(8)<=I2C_SDAT;
				WHEN 187	=> SDI<='1';--TO Slave ACK		
				
			--STOP
				WHEN 188	=>	SDI<='0'; ---*********************************
				WHEN 189	=>	SCLK<='1';
				WHEN 190	=>	SDI <= '1';
	

--***************************************Z0***********************************************

			--START
				WHEN 192	=>	SDI<='1'; SCLK<='1';
				WHEN 193	=>	SDI<='0';
				WHEN 194	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 195	=>	SDI<='0';
				WHEN 196	=>	SDI<='0';---******************************
				WHEN 197	=>	SDI<='1';
				WHEN 198	=>	SDI<='1';
				WHEN 199	=>	SDI<='1';
				WHEN 200	=>	SDI<='0';
				WHEN 201	=>	SDI<='1';
				WHEN 202	=>	SDI<='0';
				WHEN 203	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 204	=>	SDI<='0';
				WHEN 205	=>	SDI<='0';
				WHEN 206	=>	SDI<='1';
				WHEN 207	=>	SDI<='1';
				WHEN 208	=>	SDI<='0';
				WHEN 209	=>	SDI<='1';
				WHEN 210	=>	SDI<='1';
				WHEN 211	=>	SDI<='0';
				WHEN 212	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 213	=>
				
			--START
				WHEN 214	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 215	=>	SDI<='0';
				WHEN 216	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 217	=>	SDI<='0';
				WHEN 218	=>	SDI<='0';---*****************************
				WHEN 219	=>	SDI<='1';
				WHEN 220	=>	SDI<='1';
				WHEN 221	=>	SDI<='1';
				WHEN 222	=>	SDI<='0';
				WHEN 223	=>	SDI<='1';
				WHEN 224	=>	SDI<='1';
				WHEN 225	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 226	=>
				WHEN 227	=>	LED_Z(7)<=I2C_SDAT;
				WHEN 228	=>	LED_Z(6)<=I2C_SDAT;
				WHEN 229	=>	LED_Z(5)<=I2C_SDAT;
				WHEN 230	=>	LED_Z(4)<=I2C_SDAT;
				WHEN 231	=>	LED_Z(3)<=I2C_SDAT;
				WHEN 232	=>	LED_Z(2)<=I2C_SDAT;
				WHEN 233	=>	LED_Z(1)<=I2C_SDAT;
				WHEN 234	=>	LED_Z(0)<=I2C_SDAT;
				WHEN 235	=> SDI<='1';--TO Slave ACK		
				
			--STOP
				WHEN 236	=>	SDI<='0'; ---*********************************
				WHEN 237	=>	SCLK<='1';
				WHEN 238	=>	SDI <= '1';
				

--***************************************Z1***********************************************

			--START
				WHEN 239	=>	SDI<='1'; SCLK<='1';
				WHEN 240	=>	SDI<='0';
				WHEN 241	=>	SCLK<='0';
	
			--DIRECCIÓN DEL ESCLAVO - ESCRITURA
				WHEN 242	=>	SDI<='0';
				WHEN 243	=>	SDI<='0';---******************************
				WHEN 244	=>	SDI<='1';
				WHEN 245	=>	SDI<='1';
				WHEN 246	=>	SDI<='1';
				WHEN 247	=>	SDI<='0';
				WHEN 248	=>	SDI<='1';
				WHEN 249	=>	SDI<='0';
				WHEN 250	=>	SDI<='Z';-- FROM Slave ACK
		
			--DIRECCIÓN DEL REGISTRO EN EL ESCLAVO (DIRECCIÓN DONDE VOY A LEER)
				WHEN 251	=>	SDI<='0';
				WHEN 252	=>	SDI<='0';
				WHEN 253	=>	SDI<='1';
				WHEN 254	=>	SDI<='1';
				WHEN 255	=>	SDI<='0';
				WHEN 256	=>	SDI<='1';
				WHEN 257	=>	SDI<='1';
				WHEN 258	=>	SDI<='1';
				WHEN 259	=>	SDI<='Z';-- FROM Slave ACK
				WHEN 260	=>
				
			--START
				WHEN 261	=>	SDI<='1'; SCLK<='1';--------------------*****************
				WHEN 262	=>	SDI<='0';
				WHEN 263	=>	SCLK<='0';
				
			--DIRECCIÓN DEL ESCLAVO - LECTURA
				WHEN 264	=>	SDI<='0';
				WHEN 265	=>	SDI<='0';---*****************************
				WHEN 266	=>	SDI<='1';
				WHEN 267	=>	SDI<='1';
				WHEN 268	=>	SDI<='1';
				WHEN 269	=>	SDI<='0';
				WHEN 270	=>	SDI<='1';
				WHEN 271	=>	SDI<='1';
				WHEN 272	=>	SDI<='Z';--FROM Slave ACK
				
			--DATA
				WHEN 273	=>
				WHEN 274	=>	LED_Z(15)<=I2C_SDAT;
				WHEN 275	=>	LED_Z(14)<=I2C_SDAT;
				WHEN 276	=>	LED_Z(13)<=I2C_SDAT;
				WHEN 277	=>	LED_Z(12)<=I2C_SDAT;
				WHEN 278	=>	LED_Z(11)<=I2C_SDAT;
				WHEN 279	=>	LED_Z(10)<=I2C_SDAT;
				WHEN 280	=>	LED_Z(9)<=I2C_SDAT;
				WHEN 281	=>	LED_Z(8)<=I2C_SDAT;
				WHEN 282	=> SDI<='1';--TO Slave ACK		
				
			--STOP
				WHEN 283	=>	SDI<='0'; ---*********************************
				WHEN 284	=>	SCLK<='1';
				WHEN 285	=>	SDI <= '1';				
				WHEN OTHERS =>	SDI<='1'; SCLK<='1';

			END CASE;
		END IF;
	END PROCESS;
	
	I2C_SCLK<= NOT(COUNT(9)) WHEN ( ((SD_COUNTER >= 4) AND (SD_COUNTER <= 22)) OR ((SD_COUNTER >= 26) AND (SD_COUNTER <= 44))
								OR ((SD_COUNTER >= 52) AND (SD_COUNTER <= 70)) OR ((SD_COUNTER >= 74) AND (SD_COUNTER <= 92))
								OR ((SD_COUNTER >= 100) AND (SD_COUNTER <= 118)) OR ((SD_COUNTER >= 122) AND (SD_COUNTER <= 140))
								OR ((SD_COUNTER >= 148) AND (SD_COUNTER <= 166)) OR ((SD_COUNTER >= 170) AND (SD_COUNTER <= 188))
								OR ((SD_COUNTER >= 196) AND (SD_COUNTER <= 214)) OR ((SD_COUNTER >= 218) AND (SD_COUNTER <= 236))
								OR ((SD_COUNTER >= 243) AND (SD_COUNTER <= 261)) OR ((SD_COUNTER >= 265) AND (SD_COUNTER <= 283))) ELSE SCLK;
	I2C_SDAT<= SDI;
	CS<='1';
END SOLUCION;