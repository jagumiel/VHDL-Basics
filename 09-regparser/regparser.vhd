library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.ALL;

entity regparser is
    Port (
        clk : IN std_logic;
        dat : IN std_logic_vector(7 downto 0);
        en  : IN std_logic;
        ld  : IN std_logic;
        m   : OUT std_logic);
end regparser;

architecture Behavioral of regparser is
    SIGNAL dataFF : std_logic_vector(7 downto 0) :="00000000"; --dataFF. FF para indicar que es un Flip-Flop
    
begin

--OJO! No se pueden modificar dos señales en dos procesos diferentes. CORTOCIRCUITO.

    process (clk)--Quiero desplazar por cada flanco de reloj
    begin
        if(ld='1')then
            dataFF<=dat;
        end if;
        if(en='1')then
            dataFF(6 downto 0)<=dataFF(7 downto 1);
            dataFF(7)<='0';
        end if;
    end process;
    
    m<=dataFF(0);--Quiero sacar siempre la última ocurrencia

end Behavioral;
