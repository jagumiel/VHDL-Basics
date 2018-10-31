library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ctrl is
    Port ( rst  : in STD_LOGIC;
           clk  : in STD_LOGIC;
           stb  : in STD_LOGIC;
           m    : in STD_LOGIC;
           tx   : out STD_LOGIC;
           ld   : out STD_LOGIC;
           en   : out STD_LOGIC;
           ini  : out STD_LOGIC);
end ctrl;

architecture Behavioral of ctrl is
    TYPE estados is (SBY, STA, B0, B1, B2, B3, B4, B5, B6, B7, STO);
    SIGNAL ep : estados :=SBY; --Estado Presente
    SIGNAL es : estados;         --Estado Siguiente
begin
    
    --Maquina de estados
    PROCESS (clk)
    BEGIN
        IF(rising_edge(clk))THEN
            CASE ep IS
                WHEN SBY =>
                    IF(stb='1')THEN
                        es<=STA;
                    ELSE
                        es<=SBY;
                    END IF;
                WHEN STA =>
                    es<=B0;
                WHEN B0 =>
                    es<=B1;
                WHEN B1 =>
                    es<=B2;
                WHEN B2 =>
                    es<=B3;
                WHEN B3 =>
                    es<=B4;
                WHEN B4 =>
                    es<=B5;
                WHEN B5 =>
                    es<=B6;
                WHEN B6 =>
                    es<=B7;
                WHEN B7 =>
                    es<=STO;
                WHEN STO =>
                    es<=SBY;
            END CASE;
        END IF;
        ep<=es;
    END PROCESS;
    
    --Salidas de la Unidad de Control:
    tx<='1'  WHEN ep=SBY OR ep=STO ELSE '0' WHEN ep=STA ELSE m;
    ld<='1'  WHEN ep=SBY ELSE '0';
    en<='1'  WHEN ep=B0 OR ep=B1 OR ep=B2 OR ep=B3 OR ep=B4 OR ep=B5 OR ep=B6 ELSE '0';
    ini<='1' WHEN ep=SBY ELSE '0';
        
                      
end Behavioral;