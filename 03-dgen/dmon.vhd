library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.std_logic_unsigned.all;


entity dmon is
    PORT (
        SIGNAL rst	: IN STD_LOGIC; 
        SIGNAL clk	: IN STD_LOGIC; 
        SIGNAL stb	: IN STD_LOGIC; 
        SIGNAL dat	: IN STD_LOGIC_VECTOR(7 DOWNTO 0));
end dmon;

architecture dataflow of dmon is
BEGIN
	
	PROCESS(clk)
    TYPE      BinFile                 IS FILE OF CHARACTER;
    FILE      fich_sal    : BinFile    OPEN WRITE_MODE IS "fichero_escrito.txt";
    VARIABLE caract        : CHARACTER; -- variable de lectura
    BEGIN
		IF (rising_edge(clk)) THEN   -- Se emite nuevo dato en flanco de subida
			IF(stb='1')THEN
				caract := CHARACTER'VAL(conv_integer(dat));
				WRITE(fich_sal,caract);
			END IF;
		END IF; 
END PROCESS;

end dataflow;