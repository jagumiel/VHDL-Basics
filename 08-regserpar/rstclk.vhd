LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY rstclk IS
	GENERIC(
		CONSTANT trst	: IN time := 320 ns;
		CONSTANT tpck	: IN time := 30 ns;
		CONSTANT tclk	: IN time := 100 ns;
		CONSTANT ti1	: IN time := 1050 ns;
		CONSTANT tf1	: IN time := 1950 ns;
		CONSTANT ti2	: IN time := 850 ns;
		CONSTANT tf2	: IN time := 1850 ns); 
    PORT (
		SIGNAL rst	: OUT STD_LOGIC; 
		SIGNAL clk	: OUT STD_LOGIC; 
		SIGNAL out1	: OUT STD_LOGIC; 
        SIGNAL out2	: OUT STD_LOGIC );
END rstclk;

ARCHITECTURE dataflow OF rstclk IS
BEGIN --Salidas independientes
    PROCESS --Salida rst
    BEGIN
        WHILE TRUE LOOP
            rst <= '1';
            WAIT FOR trst;
			rst <= '0';
			wait;
        END LOOP;
    END PROCESS;
	
	PROCESS --Salida clk
    BEGIN
		clk <= '1';
		WAIT FOR tpck;
        WHILE TRUE LOOP
			clk <= '0';
			WAIT FOR tclk/2;
			clk <= '1';
			WAIT FOR tclk/2;
        END LOOP;
    END PROCESS;
	
	PROCESS --Salida out1
    BEGIN
        WHILE TRUE LOOP
			out1 <= '0';
			WAIT FOR ti1;
			out1 <= '1';
			WAIT FOR tf1-ti1;
        END LOOP;
    END PROCESS;
	
	PROCESS --Salida out2
    BEGIN
        WHILE TRUE LOOP
			out2 <= '0';
			WAIT FOR ti2;
			out2 <= '1';
			WAIT FOR tf2-ti2;
        END LOOP;
    END PROCESS;
END dataflow ;