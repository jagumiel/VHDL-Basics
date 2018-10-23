library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_regps is
end tb_regps;

architecture Behavioral of tb_regps is

COMPONENT rstclk IS
	GENERIC(
		CONSTANT trst	: IN time := 320 ns;
		CONSTANT tpck	: IN time := 30 ns;
		CONSTANT tclk	: IN time := 100 ns;
		CONSTANT ti1	: IN time := 790 ns;
		CONSTANT tf1	: IN time := 1740 ns;
		CONSTANT ti2	: IN time := 540 ns;
		CONSTANT tf2	: IN time := 690 ns); 
    PORT (
		SIGNAL rst	: OUT STD_LOGIC; 
		SIGNAL clk	: OUT STD_LOGIC; 
		SIGNAL out1	: OUT STD_LOGIC; 
        SIGNAL out2	: OUT STD_LOGIC );
END COMPONENT;

COMPONENT regparser IS
    Port (
        clk : IN std_logic;
        dat : IN std_logic_vector(7 downto 0);
        en  : IN std_logic;
        ld  : IN std_logic;
        m   : OUT std_logic);
END COMPONENT;

    signal clk, lda, enable : std_logic;
    signal salida : std_logic;
    signal entrada: std_logic_vector(7 downto 0) :="10100101";

begin

    inst1: rstclk
        GENERIC MAP(
            trst    => 320 ns,
            tpck	=> 30 ns,
            tclk	=> 100 ns,
            ti1	    => 790 ns,
            tf1     => 1740 ns,
            ti2	    => 540 ns,
            tf2     => 690 ns)
        PORT MAP(
            rst	=> open, 
            clk	=> clk,
            out1=> enable, 
            out2=> lda);

    inst2: regparser
        Port Map(
            clk	=> clk,
            dat	=> entrada,
            en	=> enable,
            ld	=> lda,
            m	=> salida);


end Behavioral;
