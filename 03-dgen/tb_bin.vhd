library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity tb_bin is
--  Port ( );
end tb_bin;

architecture dataflow of tb_bin is

--Declaracion de los dos componentes que voy a usar.
    COMPONENT dgen IS
        GENERIC(
            CONSTANT tp		: IN time := 10 ns;
            CONSTANT trst	: IN time := 320 ns;
            CONSTANT tclk	: IN time := 100 ns;
            CONSTANT npause	: IN integer := 10); 
        PORT (
            SIGNAL rst	: OUT STD_LOGIC; 
            SIGNAL clk	: OUT STD_LOGIC; 
            SIGNAL stb	: OUT STD_LOGIC; 
            SIGNAL dat	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;
    
    COMPONENT dmon is
        PORT (
            SIGNAL rst    : IN STD_LOGIC; 
            SIGNAL clk    : IN STD_LOGIC; 
            SIGNAL stb    : IN STD_LOGIC; 
            SIGNAL dat    : IN STD_LOGIC_VECTOR(7 DOWNTO 0));
    END COMPONENT;

--Declaro las variables intermedias de mi jerarquia tope.
    SIGNAL rst    : STD_LOGIC; 
    SIGNAL clk    : STD_LOGIC; 
    SIGNAL stb    : STD_LOGIC; 
    SIGNAL dat    : STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

--Instancio los componentes
    inst1: dgen
    GENERIC MAP(
        tp => 10 ns,
        trst => 320 ns,
        tclk => 100 ns,
        npause => 10
    )
    PORT MAP(
        rst => rst,
        clk => clk,
        stb => stb,
        dat => dat
    );
    
    inst2: dmon
    PORT MAP(
        rst => rst,
        clk => clk,
        stb => stb,
        dat => dat
    );    

end dataflow;
