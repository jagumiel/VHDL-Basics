library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_counter is
end tb_counter;

architecture Behavioral of tb_counter is

    COMPONENT rstclk IS
        GENERIC(
            CONSTANT trst	: IN time := 320 ns;
            CONSTANT tpck   : IN time := 30 ns;
            CONSTANT tclk   : IN time := 100 ns;
            CONSTANT ti1    : IN time := 5035 ns;
            CONSTANT tf1    : IN time := 5815 ns;
            CONSTANT ti2    : IN time := 3015 ns;
            CONSTANT tf2    : IN time := 3415 ns); 
        PORT (
            SIGNAL rst	: OUT STD_LOGIC; 
            SIGNAL clk	: OUT STD_LOGIC; 
            SIGNAL out1	: OUT STD_LOGIC; 
            SIGNAL out2	: OUT STD_LOGIC );
    END COMPONENT;
    
    COMPONENT counter IS
        Generic(
            constant nb : in integer;
            constant nc : in integer);
        Port (
            signal rst  : in std_logic;
            signal clk  : in std_logic;
            signal dat  : out std_logic_vector(nb downto 0));
    END COMPONENT;

    constant nba    :integer :=8;
    constant nca    :integer:=129;
    signal clk, reset : std_logic;
    signal salida : std_logic_vector(nba downto 0);

begin

    inst1: rstclk
        GENERIC MAP(
            trst => 320 ns,
            tpck => 30 ns,
            tclk => 100 ns,
            ti1 => 5035 ns,
            tf1 => 5815 ns,
            ti2 => 3015 ns,
            tf2 => 3415 ns)
        PORT MAP(
            rst => reset, 
            clk => clk,
            out1 => open,
            out2 => open);
            
    inst2: counter 
        GENERIC MAP( 
            nb => nba,
            nc => nca)
        PORT MAP( 
            rst => reset,
            clk => clk,
            dat => salida );

end Behavioral;
