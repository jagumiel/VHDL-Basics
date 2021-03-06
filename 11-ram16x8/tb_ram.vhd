library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_ram is
end tb_ram;

architecture dataflow of tb_ram is

component simdat is
	GENERIC(
        CONSTANT tp     : IN time := 10 ns;
        CONSTANT tclk   : IN time := 100 ns;
        CONSTANT ti1    : IN time := 320 ns;
        CONSTANT tf1    : IN time := 5000 ns;
        CONSTANT ti2    : IN time := 310 ns;
        CONSTANT tf2    : IN time := 1900 ns); 
PORT (
        SIGNAL clk  : OUT STD_LOGIC; 
        SIGNAL adr  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0):="1111"; 
        SIGNAL data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        SIGNAL out1 : OUT STD_LOGIC;
        SIGNAL out2 : OUT STD_LOGIC);
end component;

component ram16x8 is
	PORT(
		clk 	: in  std_logic;
		adr 	: in  std_logic_vector(3 downto 0);
		dat_i 	: in  std_logic_vector(7 downto 0);
		stb 	: in  std_logic;
		we 		: in  std_logic;
		dat_o 	: out std_logic_vector(7 downto 0));
end component;

--Senales
signal clk, stb, we : std_logic;
signal adr_a : std_logic_vector (3 downto 0);
signal data_a, salida : std_logic_vector(7 downto 0);
begin

	inst1: simdat
		GENERIC MAP(
			tp => 10 ns,
			tclk => 100 ns,
			ti1 => 320 ns,
			tf1 => 5000 ns,
			ti2 => 310 ns,
			tf2 => 1900 ns)
		PORT MAP(
			clk => clk,
			adr => adr_a,
			data => data_a,
			out1 => stb,
			out2 => we);

	inst2: ram16x8
	PORT MAP(
		clk => clk,
		adr => adr_a,
		dat_i => data_a,
		stb => stb,
		we => we,
		dat_o => salida);
			
end dataflow;