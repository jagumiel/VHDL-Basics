library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity waitd is
        Generic (CONSTANT nvt : in  integer := 10);
        Port (
        SIGNAL clk  : in std_logic;
        SIGNAL ini  : in std_logic;
        SIGNAL tc   : out std_logic :='0'); --Inicializo a '0'.
end waitd;

architecture Behavioral of waitd is
    SIGNAL contador : integer :=0;

begin

    PROCESS (clk)
    BEGIN
        --Aqui se hace solo el contador. Hay que separar de las salidas generadas
        IF(rising_edge(clk))THEN
            IF(ini='1')THEN
                contador<=0;
            ELSIF(contador=nvt)THEN
                contador<=0;
            ELSE
                contador<=contador+1;
            END IF;
        END IF;
    END PROCESS;
        
    PROCESS(contador)
    BEGIN
        IF(contador=nvt)THEN
            tc<='1';
        ELSE
            tc<='0';
        END IF;
    END PROCESS;

end Behavioral;
