LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY clktyp IS
    PORT (
        SIGNAL clk :OUT STD_LOGIC );
END clktyp;

ARCHITECTURE dataflow OF clktyp IS
BEGIN
    PROCESS
    BEGIN
        clk <= '1';
        WAIT FOR 2 ns;
        WHILE TRUE LOOP
            clk <= '0';
            WAIT FOR 5 ns;
            clk <= '1';
            WAIT FOR 5 ns;
        END LOOP;
    END PROCESS;
END dataflow ;