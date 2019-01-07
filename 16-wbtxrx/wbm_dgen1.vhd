LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

ENTITY wbm_dgen1 IS
	GENERIC(
		CONSTANT tp		: IN time := 10 ns;
		CONSTANT trst	: IN time := 320 ns;
		CONSTANT tclk	: IN time := 100 ns;
		CONSTANT npause: IN integer := 10);
    PORT (
		SIGNAL rst_o	: OUT STD_LOGIC;
		SIGNAL clk_o	: OUT STD_LOGIC;
		SIGNAL stb_o	: OUT STD_LOGIC;
		SIGNAL we_o		: OUT STD_LOGIC;
		SIGNAL ack_i	: IN  STD_LOGIC;
		SIGNAL dat_o	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END wbm_dgen1;

ARCHITECTURE dataflow OF wbm_dgen1 IS

--Declaracion de Senales Internas
SIGNAL stb_a, stb_b : STD_LOGIC;
SIGNAL clka, rsta   : STD_LOGIC;	--No puedo leer salidas internas. Necesito un auxiliar.
SIGNAL cont : INTEGER RANGE 0 TO npause :=0;
SIGNAl dat_a: STD_LOGIC_VECTOR(7 DOWNTO 0);

BEGIN --Salidas independientes
    PROCESS --Salida rst_o
    BEGIN
        WHILE TRUE LOOP
				rsta <= '1';
            WAIT FOR trst;
			rsta <= '0';
			wait;
        END LOOP;
    END PROCESS;
    rst_o<=rsta;
	
	PROCESS --Salida clk_o (Bucle infinito, el reloj no tiene que parar).
    BEGIN
		clka <= '1';
        WHILE TRUE LOOP
			clka <= '0';
			WAIT FOR tclk/2;
			clka <= '1';
			WAIT FOR tclk/2;
        END LOOP;
    END PROCESS;
    clk_o<=clka;
	
	
	PROCESS(clka) --Contador. clka es la senal de la lista de sensibilidad.
    BEGIN
		IF(rising_edge(clka))THEN
			IF (rsta = '1') THEN
				cont <= 0;
			ELSE
				IF (cont = npause) THEN
					IF ack_i = '1' THEN
						cont <= 0;
					END IF;
				ELSE
					cont <= cont + 1;
				END IF;
			END IF;
		END IF;
    END PROCESS;
	
	--Salida stb_a
	stb_a <= '1' WHEN cont = npause ELSE '0';
    
    PROCESS(stb_a)
        TYPE      BinFile                 IS FILE OF CHARACTER;
        FILE      fich_ent    : BinFile    OPEN READ_MODE IS "fichero.txt";
        VARIABLE caract        : CHARACTER; -- variable de lectura
    BEGIN
        IF (rising_edge(stb_a)) THEN   -- Se emite nuevo dato en flanco de subida
            READ(fich_ent,caract);
            dat_a <= CONV_STD_LOGIC_VECTOR(CHARACTER'POS(caract),8);
        END IF; 
    END PROCESS;
    
    --dat_o<=dat_a WHEN stb_b='1' else "ZZZZZZZZ";
	stb_b <= stb_a AFTER tp WHEN rsta = '0' ELSE '0';
	stb_o <= stb_b;
	we_o <= stb_b;
    dat_o<=dat_a WHEN stb_b='1';
    
END dataflow ;