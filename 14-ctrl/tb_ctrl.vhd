library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ctrl is
end tb_ctrl;

architecture dataflow of tb_ctrl is

    COMPONENT rstclk IS
        GENERIC(
            CONSTANT trst	: IN time := 320 ns;
            CONSTANT tpck	: IN time := 30 ns;
            CONSTANT tclk	: IN time := 100 ns;
            CONSTANT ti1	: IN time := 1040 ns;
            CONSTANT tf1	: IN time := 1100 ns;
            CONSTANT ti2	: IN time := 1400 ns;
            CONSTANT tf2	: IN time := 1900 ns); 
        PORT (
            SIGNAL rst	: OUT STD_LOGIC; 
            SIGNAL clk	: OUT STD_LOGIC; 
            SIGNAL out1	: OUT STD_LOGIC; 
            SIGNAL out2	: OUT STD_LOGIC );
    END COMPONENT;
    
    COMPONENT ctrl IS
        PORT ( rst  : in  STD_LOGIC;
               clk  : in  STD_LOGIC;
               stb  : in  STD_LOGIC;
               m    : in  STD_LOGIC;
               tx   : out STD_LOGIC;
               ld   : out STD_LOGIC;
               en   : out STD_LOGIC;
               ini  : out STD_LOGIC);
    END COMPONENT;
    
    signal rst, clk, stba, ma : std_logic;
    signal tx, ld, en, ini : std_logic;

    
begin

    inst1: rstclk
        GENERIC MAP(
            trst => 320 ns,
            tpck => 30 ns,
            tclk => 100 ns,
            ti1 => 1040 ns,
            tf1 => 1100 ns,
            ti2 => 1400 ns,
            tf2 => 1900 ns) 
        PORT MAP(
            rst => rst,
            clk => clk,
            out1 => stba,
            out2 => ma);

    inst2: ctrl
        PORT MAP ( 
                rst  => rst,
                clk  => clk,
                stb  => stba,
                m    => ma,
                tx   => tx,
                ld   => ld,
                en   => en,
                ini  => ini);

end dataflow;
