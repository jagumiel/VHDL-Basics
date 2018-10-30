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
    TYPE estados is (count, reset, send);
    --count: Sigue contando hasta nvp
    --reset: La señal init está activa. La cuenta vuelve a 0 y permanece en 0 mientras dure. Se reinicia el contador.
    --send: La cuenta ha llegado a nvp, envío el dato.
    SIGNAL ep : estados :=count; --Estado Presente
    SIGNAL es : estados;         --Estado Siguiente
    SIGNAL sum : integer :=0;

begin

    PROCESS (clk)
    BEGIN
        ep<=es;
        IF(rising_edge(clk))THEN
            CASE ep IS
                WHEN count =>
                    tc<='0';
                    sum<=sum+1;
                    IF(ini='0')THEN
                        IF(sum<nvt-1)THEN
                            es<=count;
                        ELSE
                            tc<='1';
                            es<=send;
                        END IF;
                    ELSE
                        sum<=0;
                        es<=reset;
                    END IF;
                WHEN reset =>
                    sum<=0;
                    tc<='0';
                    IF(ini='0')THEN
                        es<=count;
                    ELSE
                        es<=reset;
                    END IF;
                WHEN send =>
                    tc<='0';
                    sum<=0;
                    es<=count;
                END CASE;
            END IF;
        END PROCESS;
        

end Behavioral;
