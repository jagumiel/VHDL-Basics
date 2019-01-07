library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity wbm_dmon1 is
	GENERIC(
		CONSTANT tp		: IN time := 10 ns);
    PORT (
        SIGNAL rst_i	: IN STD_LOGIC; 
        SIGNAL clk_i	: IN STD_LOGIC;  
        SIGNAL dat_i	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		SIGNAL we_o		: OUT STD_LOGIC;
		SIGNAL stb_o	: OUT STD_LOGIC;
		SIGNAL ack_i	: IN STD_LOGIC;
		SIGNAL rdy_i	: IN STD_LOGIC);
end wbm_dmon1;

architecture dataflow of wbm_dmon1 is
	--Declaro las variables/senales fuera, ya que las voy a usar en dos procesos.
	TYPE BinFile IS FILE OF CHARACTER;
    FILE fich_sal : BinFile;
	SIGNAL we_b : STD_LOGIC;
BEGIN
	
	PROCESS(clk_i)
    
    VARIABLE caract : CHARACTER; -- variable de lectura
    BEGIN
		IF (rising_edge(clk_i)) THEN   -- Se emite nuevo dato en flanco de subida
			IF(rst_i='0')THEN
				IF(rdy_i='1')THEN
					caract := CHARACTER'VAL(conv_integer(dat_i));
					WRITE(fich_sal,caract);
				End if;
			END IF;
		END IF; 
	END PROCESS;

	PROCESS(rst_i)
	BEGIN
		IF FALLING_EDGE(rst_i) THEN
			FILE_OPEN(fich_sal, "fichero_escrito.txt", WRITE_MODE);
		ELSIF RISING_EDGE(rst_i) THEN
			FILE_CLOSE(fich_sal);
		END IF;
	END PROCESS;
	
	we_b <= rdy_i AFTER tp;
	stb_o <= NOT we_b;
	we_o <= we_b;

end dataflow;