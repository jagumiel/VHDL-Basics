library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity rxser is
    Generic(nvt  : in  integer :=10);
    Port(   rst  : in  STD_LOGIC;
            clk  : in  STD_LOGIC;
            rx   : in  STD_LOGIC;
            rdy  : out STD_LOGIC;
            dat  : out STD_LOGIC_VECTOR(7 downto 0));
end rxser;

architecture Behavioral of rxser is

    --Señales de rxser
    TYPE estados is (SBY, STA0, STA1, B00, B01, B10,B11, B20, B21, B30, B31, B40, B41, B50, B51, B60, B61, B70, B71, STO, SRD);
    SIGNAL ep : estados :=SBY;  --Estado Presente
    SIGNAL es : estados;        --Estado Siguiente
    SIGNAL clka : std_logic;
    signal rdya : std_logic;
    
    --Señales de waitd
    SIGNAL tc : std_logic;
    SIGNAL contador : integer range 0 to nvt;
    
    --Señales de ctrl
    SIGNAL ini : std_logic;
    SIGNAL en : std_logic;
    
    --señales de regserpar
    SIGNAL data : STD_LOGIC_VECTOR(7 downto 0);


begin

    --Maquina de estados
    PROCESS(tc, rx, ep)--COMPROBAR SI ES EL TC.
    BEGIN
        CASE ep IS
            WHEN SBY =>
                IF(rx='1')THEN
                    es<=SBY;
                ELSE
                    es<=STA0;
                END IF;
            WHEN STA0 =>
                IF(tc='0')THEN
                    es<=STA0;
                ELSE
                    es<=STA1;
                END IF;
            WHEN STA1 =>
                IF(tc='0')THEN
                    es<=STA1;
                ELSE
                    es<=B00;
                END IF;
            WHEN B00 =>
                IF(tc='0')THEN
                    es<=B00;
                ELSE
                    es<=B01;
                END IF;
            WHEN B01 =>
                IF(tc='0')THEN
                    es<=B01;
                ELSE
                    es<=B10;
                END IF;
            WHEN B10 =>
                IF(tc='0')THEN
                    es<=B10;
                ELSE
                    es<=B11;
                END IF;
            WHEN B11 =>
                IF(tc='1')THEN
                    es<=B20;
                ELSE
                    es<=B11;
                END IF;
            WHEN B20 =>
                IF(tc='1')THEN
                    es<=B21;
                ELSE
                    es<=B20;
                END IF;                    
            WHEN B21 =>
                IF(tc='1')THEN
                    es<=B30;
                ELSE
                    es<=B21;
                END IF;
            WHEN B30 =>
                IF(tc='1')THEN
                    es<=B31;
                ELSE
                    es<=B30;
                END IF;                    
            WHEN B31 =>
                IF(tc='1')THEN
                    es<=B40;
                ELSE
                    es<=B31;
                END IF;
            WHEN B40 =>
                IF(tc='1')THEN
                    es<=B41;
                ELSE
                    es<=B40;
                END IF;
            WHEN B41 =>
                IF(tc='1')THEN
                    es<=B50;
                ELSE
                    es<=B41;
                END IF;                    
            WHEN B50 =>
                IF(tc='1')THEN
                    es<=B51;
                ELSE
                    es<=B50;
                END IF;                    
            WHEN B51 =>
                IF(tc='1')THEN
                    es<=B60;
                ELSE
                    es<=B51;
                END IF;
            WHEN B60 =>
                IF(tc='1')THEN
                    es<=B61;
                ELSE
                    es<=B60;
                END IF;                      
            WHEN B61 =>
                IF(tc='0')THEN
                    es<=B61;
                ELSE
                    es<=B70;
                END IF;
            WHEN B70 =>
                IF(tc='0')THEN
                    es<=B70;
                ELSE
                    es<=B71;
                END IF;
            WHEN B71 =>
                IF(tc='0')THEN
                    es<=B71;
                ELSE
                    es<=STO;
                END IF;
            WHEN STO =>
                IF(tc='0')THEN
                    es<=STO;
                ELSE
                    es<=SRD;
                END IF;
            WHEN SRD =>
                es<=SBY;
        END CASE;
    END PROCESS;

    --Salidas de la Unidad de Control:
    WITH ep SELECT
        ini <= '1' WHEN SBY,
               '0' WHEN OTHERS;
   WITH ep SELECT
        rdya <= '1' WHEN SRD,
              '0' WHEN OTHERS;
   WITH ep SELECT
        en <= tc WHEN B00 | B10 | B20 | B30 | B40 | B50 | B60 | B70,
              '0' WHEN OTHERS;

    PROCESS(clk)
    BEGIN
        IF(rising_edge(clk))then
            ep<=es;
        end if;
    END PROCESS;

--    ini <='1' WHEN ep=SBY ELSE '0';
--    rdya<='1' WHEN ep=SRD ELSE '0';
--    en  <= tc WHEN ep=B00 OR ep=B10 OR ep=B20 OR ep=B30 OR ep=B40 OR ep=B50 OR ep=B60 OR ep=B70 ELSE '0';
    rdy<=rdya;   

----------------------------------------------------------------------------------------------
    --Generacion del tc (Terminal Count)
    PROCESS (clk)
    BEGIN
        IF(rising_edge(clk))THEN
            IF(ini='1')THEN
                contador<=0;
            ELSIF(contador=(nvt/2))THEN
                contador<=0;
            ELSE
                contador<=contador+1;
            END IF;
        END IF;
    END PROCESS;
        
    PROCESS(contador)
    BEGIN
        IF(contador=(nvt/2))THEN
            tc<='1';
        ELSE
            tc<='0';
        END IF;
    END PROCESS;
----------------------------------------------------------------------------------------------

    
    process (clk)
    begin
        if(rising_edge(clk))then
            if(en='1')then
                data(6 downto 0)<=data(7 downto 1);
                data(7)<=rx;
            end if;
        end if;
    end process;
    dat<=data;
    

end Behavioral;
