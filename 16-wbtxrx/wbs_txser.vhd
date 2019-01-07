library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
--use IEEE.numeric_std.ALL;


entity wbs_txser is
    Generic(nvt  	: in  integer :=10);
    Port ( rst_i	: in  STD_LOGIC;
           clk_i	: in  STD_LOGIC;
           dat_i	: in  STD_LOGIC_VECTOR (7 downto 0);
		   we_i		: in  STD_LOGIC;
           stb_i	: in  STD_LOGIC;
		   ack_o	: out STD_LOGIC;
           tx   	: out STD_LOGIC);
end wbs_txser;

architecture Behavioral of wbs_txser is

    --Señales de wbs_txser
    TYPE estados is (SBY, STA, B0, B1, B2, B3, B4, B5, B6, B7, STO);
    SIGNAL ep : estados :=SBY;  --Estado Presente
    SIGNAL es : estados;        --Estado Siguiente
    --Otras señales
    SIGNAL m, ld, en, ini, tc : std_logic;
    SIGNAL contador : integer range 0 to nvt;
    SIGNAL dataFF : std_logic_vector(7 downto 0);
    
begin

    --Maquina de estados
    PROCESS(stb_i, ep, tc)
    BEGIN
            CASE ep IS
                WHEN SBY =>
                    IF(stb_i='1')THEN
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
    
    PROCESS(clk_i)
    BEGIN
        IF(rising_edge(clk_i))then
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

-------------------------------------------------------------------------------------------------------
    --Generacion del tc (Terminal Count)
    
    PROCESS (clk_i)
    BEGIN
        --Aqui se hace solo el contador. Hay que separar de las salidas generadas
        --Esto se hace porque queremos que vaya 10 veces mas lento.
        IF(rising_edge(clk_i))THEN
            IF(ini='1')THEN
                contador<=0;
            ELSE
				IF(contador = nvt-1)THEN
					contador <= 0;
					tc <= '1';
				ELSE
					contador <= contador + 1;
					tc <= '0';
				END IF;
			END IF;
        END IF;
    END PROCESS;

------------------------------------------------------------------------------------------------------    
    process (clk_i)--Quiero desplazar por cada flanco de reloj
    begin
        if(rising_edge(clk_i))then
            if(ld='1')then
                dataFF<=dat_i;
            elsif(en='1')then
				if(tc='1')then
					dataFF <= '0' & dataFF(7 DOWNTO 1);
				end if;
            end if;
        end if;
    end process;
    m<=dataFF(0);
	
	process(we_i, stb_i, ep) 
	begin
		ack_o <= '0';
		if(ep=STO)then
			if we_i = '1' then
				if stb_i = '1' then
					ack_o <= '1';
				end if;
			end if;
		end if;
	end process;
	ld <= we_i AND stb_i;

end Behavioral;