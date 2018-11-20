library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_txrx is
end tb_txrx;

architecture dataflow of tb_txrx is

COMPONENT dgen IS
	GENERIC(
		CONSTANT tp		: IN time := 10 ns;
		CONSTANT trst	: IN time := 320 ns;
		CONSTANT tclk	: IN time := 100 ns;
		CONSTANT npause	: IN integer := 350); 
    PORT (
		SIGNAL rst	: OUT STD_LOGIC; 
		SIGNAL clk	: OUT STD_LOGIC; 
		SIGNAL stb	: OUT STD_LOGIC; 
        SIGNAL dat	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

COMPONENT txser IS
    Generic(nvt  : in  integer :=20);
    Port ( rst  : in  STD_LOGIC;
           clk  : in  STD_LOGIC;
           dat  : in  STD_LOGIC_VECTOR (7 downto 0);
           stb  : in  STD_LOGIC;
           tx   : out STD_LOGIC);
END COMPONENT;

COMPONENT rxser IS
    Generic(nvt  : in  integer :=20);
    Port(   rst  : in  STD_LOGIC;
            clk  : in  STD_LOGIC;
            rx   : in  STD_LOGIC;
            rdy  : out STD_LOGIC;
            dat  : out STD_LOGIC_VECTOR(7 downto 0));
END COMPONENT;

COMPONENT dmon IS
    PORT (
        SIGNAL rst	: IN STD_LOGIC; 
        SIGNAL clk	: IN STD_LOGIC; 
        SIGNAL stb	: IN STD_LOGIC; 
        SIGNAL dat	: IN STD_LOGIC_VECTOR(7 DOWNTO 0));
END COMPONENT;

    --Señales globales.
    SIGNAL rsta, clka : std_logic;
    --Señales entre dgen y txser
    SIGNAL stba : std_logic;
    SIGNAL txdat : std_logic_vector(7 downto 0);
    --Señales entre txser y rxser
    SIGNAL outin : std_logic; --outin, significa que la salida de una es la entrada de la otra.
    --Señales entre rxser y dmon
    SIGNAL rdya : std_logic;
    SIGNAL rxdat : std_logic_vector(7 downto 0);

begin

    inst1: dgen
    	GENERIC MAP(
            tp => 10 ns,
            trst => 320 ns,
            tclk => 100 ns,
            npause => 350)
        PORT map (
            rst => rsta,
            clk => clka, 
            stb => stba,
            dat => txdat);
            
    inst2: txser
        GENERIC MAP(nvt => 20) --(10-1)
        PORT MAP ( 
            rst => rsta,
            clk => clka,
            dat => txdat,
            stb => stba,
            tx => outin);
            
    inst3: rxser
        GENERIC MAP (nvt => 20)  --(10/2)-1     Antes el valor original de nvt en todas partes era 10
        PORT MAP(   
            rst => rsta,
            clk => clka,
            rx => outin,
            rdy =>rdya,
            dat =>rxdat);
            
    inst4: dmon
        PORT MAP(
            rst => rsta,
            clk => clka,
            stb => rdya,
            dat => rxdat);
            
end dataflow;
