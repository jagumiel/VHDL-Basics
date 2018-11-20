library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;


entity txser is
    Generic(nvt  : in  integer :=10);
    Port ( rst  : in  STD_LOGIC;
           clk  : in  STD_LOGIC;
           dat  : in  STD_LOGIC_VECTOR (7 downto 0);
           stb  : in  STD_LOGIC;
           tx   : out STD_LOGIC);
end txser;

architecture Behavioral of txser is

    --Señales de txser
    TYPE estados is (SBY, STA, B0, B1, B2, B3, B4, B5, B6, B7, STO);
    SIGNAL ep : estados :=SBY;  --Estado Presente
    SIGNAL es : estados;        --Estado Siguiente
    SIGNAL cont : integer:=0;
    SIGNAL clka : std_logic;
    
    --Señales de ctrl
    SIGNAL m, ld, en, ini : std_logic;
    --Señales de waitd
    SIGNAL tc : std_logic;
    SIGNAL contador : integer range 0 to nvt;
    --Señales de regparser
    SIGNAL dataFF : std_logic_vector(7 downto 0);
    
begin

    --Maquina de estados
    PROCESS(stb, ep, tc)
    BEGIN
            CASE ep IS
                WHEN SBY =>
                    IF(stb='1')THEN
                        es<=STA;
                    ELSE
                        es<=SBY;
                    END IF;
                WHEN STA =>
                    IF(tc='1')then
                        es<=B0;
                    ELSE
                        es<=STA;
                    END IF;
                WHEN B0 =>
                    IF(tc='1')then
                        es<=B1;
                    ELSE
                        es<=B0;
                    END IF;
                WHEN B1 =>
                    IF(tc='1')then
                        es<=B2;
                    ELSE
                        es<=B1;
                    END IF;
                WHEN B2 =>
                    IF(tc='1')then
                        es<=B3;
                    ELSE
                        es<=B2;
                    END IF;
                WHEN B3 =>
                    IF(tc='1')then
                        es<=B4;
                    ELSE
                        es<=B3;
                    END IF;
                WHEN B4 =>
                    IF(tc='1')then
                        es<=B5;
                    ELSE
                        es<=B4;
                    END IF;
                WHEN B5 =>
                    IF(tc='1')then
                        es<=B6;
                    ELSE
                        es<=B5;
                    END IF;
                WHEN B6 =>
                    IF(tc='1')then
                        es<=B7;
                    ELSE
                        es<=B6;
                    END IF;
                WHEN B7 =>
                    IF(tc='1')then
                        es<=STO;
                    ELSE
                        es<=B7;
                    END IF;
                WHEN STO =>
                    IF(tc='1')then
                        es<=SBY;
                    ELSE
                        es<=STO;
                    END IF;
            END CASE;
    END PROCESS;
    
    PROCESS(clk)
    BEGIN
        IF(rising_edge(clk))then
            ep<=es;
        end if;
    END PROCESS;
    
    --Salidas de la Unidad de Control:
    WITH ep SELECT
        tx <= '0' WHEN STA,
              '1' WHEN SBY | STO,
               m  WHEN OTHERS;
   WITH ep SELECT
        ld <= '1' WHEN SBY,
              '0' WHEN OTHERS;
   WITH ep SELECT
        en <= tc WHEN B0 | B1 | B2 | B3 | B4 | B5 | B6,
              '0' WHEN OTHERS;
   WITH ep SELECT
        ini <= '1' WHEN SBY,
               '0' WHEN OTHERS;
    
    
--    tx<='1'  WHEN ep=SBY OR ep=STO ELSE '0' WHEN ep=STA ELSE m;
--    ld<='1'  WHEN ep=SBY ELSE '0';
--    en<='1'  WHEN ep=B0 OR ep=B1 OR ep=B2 OR ep=B3 OR ep=B4 OR ep=B5 OR ep=B6 ELSE '0';
--    ini<='1' WHEN ep=SBY ELSE '0';
-------------------------------------------------------------------------------------------------------
    --Generacion del tc (Terminal Count)
    
    PROCESS (clk)
    BEGIN
        --Aqui se hace solo el contador. Hay que separar de las salidas generadas
        --Esto se hace porque queremos que vaya 10 veces mas lento.
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
------------------------------------------------------------------------------------------------------    
    process (clk)--Quiero desplazar por cada flanco de reloj
    begin
        if(rising_edge(clk))then
            if(ld='1')then
                dataFF<=dat;
            end if;
            if(en='1')then
                dataFF(6 downto 0)<=dataFF(7 downto 1);
                dataFF(7)<='0';
            end if;
        end if;
    end process;
    m<=dataFF(0);

end Behavioral;
