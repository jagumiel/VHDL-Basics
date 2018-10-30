library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_waitd is
end tb_waitd;

architecture dataflow of tb_waitd is

    COMPONENT waitd IS
        Generic (CONSTANT nvt : in  integer := 10);
        Port (
            SIGNAL clk  : in std_logic;
            SIGNAL ini  : in std_logic;
            SIGNAL tc   : out std_logic);
    END COMPONENT;
    
    COMPONENT rstclk IS
        GENERIC(
            CONSTANT trst    : IN time := 320 ns;
            CONSTANT tpck    : IN time := 30 ns;
            CONSTANT tclk    : IN time := 100 ns;
            CONSTANT ti1    : IN time := 5035 ns;
            CONSTANT tf1    : IN time := 5815 ns;
            CONSTANT ti2    : IN time := 3015 ns;
            CONSTANT tf2    : IN time := 3415 ns); 
        PORT (
            SIGNAL rst    : OUT STD_LOGIC; 
            SIGNAL clk    : OUT STD_LOGIC; 
            SIGNAL out1    : OUT STD_LOGIC; 
            SIGNAL out2    : OUT STD_LOGIC );
    END COMPONENT;
    
    signal clk : std_logic;
    signal reset : std_logic;
    signal salida : std_logic := '0';
    
begin

    inst1: waitd
        GENERIC MAP(nvt => 10)
        PORT MAP (
            clk => clk,
            ini => reset,
            tc => salida);

    inst2: rstclk
        GENERIC MAP(
            trst => 320 ns,
            tpck => 30 ns,
            tclk => 100 ns,
            ti1 => 5035 ns,
            tf1 => 5815 ns,
            ti2 => 3015 ns,
            tf2 => 3415 ns) 
        PORT MAP(
            rst => open, 
            clk => clk,
            out1 => reset,
            out2 => open);

end dataflow;
