library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_regsp is
--  Port ( );
end tb_regsp;

architecture Behavioral of tb_regsp is

    COMPONENT rstclk IS
        GENERIC(
            CONSTANT trst	: IN time := 320 ns;
            CONSTANT tpck   : IN time := 30 ns;
            CONSTANT tclk   : IN time := 100 ns;
            CONSTANT ti1    : IN time := 1050 ns;
            CONSTANT tf1    : IN time := 1950 ns;
            CONSTANT ti2    : IN time := 850 ns;
            CONSTANT tf2    : IN time := 1850 ns); 
        PORT (
            SIGNAL rst	: OUT STD_LOGIC; 
            SIGNAL clk	: OUT STD_LOGIC; 
            SIGNAL out1	: OUT STD_LOGIC; 
            SIGNAL out2	: OUT STD_LOGIC );
    END COMPONENT;
    
    COMPONENT regserpar IS
        Port ( clk  : IN  STD_LOGIC;
               d    : IN  STD_LOGIC;
               en   : IN  STD_LOGIC;
               dat  : OUT STD_LOGIC_VECTOR (7 downto 0));
    END COMPONENT;

    signal clk, data, enable : std_logic;
    signal salida : std_logic_vector(7 downto 0);

begin

    inst1: rstclk
        GENERIC MAP(
            trst => 320 ns,
            tpck => 30 ns,
            tclk => 100 ns,
            ti1 => 1050 ns,
            tf1 => 1950 ns,
            ti2 => 850 ns,
            tf2 => 1850 ns)
        PORT MAP(
            rst => open, 
            clk => clk,
            out1 => data,
            out2 => enable);
            
    inst2: regserpar 
        PORT MAP( 
            clk => clk,
            d => data,
            en => enable,
            dat => salida );

end Behavioral;
