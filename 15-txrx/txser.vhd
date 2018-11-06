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
    SIGNAL contador : integer :=0;
    --Señales de regparser
    SIGNAL dataFF : std_logic_vector(7 downto 0);
    
begin

    --Reloj (10 veces más lento)
    process (clk)
    Begin
        IF(rising_edge(clk))THEN
            cont<=cont+1;
            IF(cont=10)THEN
                clka<='1';
                cont<=0;
            ELSE
                clka<='0';
            END IF;
        END IF;
    End process;

    --Maquina de estados
    PROCESS (clka)
    BEGIN
        IF(rising_edge(clka))THEN
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
    
    
    PROCESS (clka)
    BEGIN
        --Aqui se hace solo el contador. Hay que separar de las salidas generadas
        IF(rising_edge(clka))THEN
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
    
    process (clka)--Quiero desplazar por cada flanco de reloj
    begin
        if(ld='1')then
            dataFF<=dat;
        end if;
        if(en='1')then
            dataFF(6 downto 0)<=dataFF(7 downto 1);
            dataFF(7)<='0';
        end if;
    end process;
    m<=dataFF(0);

end Behavioral;
