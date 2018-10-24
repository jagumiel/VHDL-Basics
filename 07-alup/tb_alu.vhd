library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_alu is
--  Port ( );
end tb_alu;

architecture structural of tb_alu is

    COMPONENT simdat IS
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
    END COMPONENT;
    
    COMPONENT alup IS
        GENERIC(nb:integer:=4);
        PORT(
            fun : in std_logic_vector(3 downto 0);
            a   : in std_logic_vector(nb-1 downto 0);
            b   : in std_logic_vector(nb-1 downto 0);
            dat : out std_logic_vector(nb-1 downto 0);
            c   : out std_logic;    --carry
            z   : out std_logic;    --zero
            e   : out std_logic     --extended (resta extendida)
        );
    END COMPONENT;

    SIGNAL clk  :  STD_LOGIC; 
    SIGNAL adr  :  STD_LOGIC_VECTOR(3 DOWNTO 0):="1111"; 
    SIGNAL data :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL out1 :  STD_LOGIC:='X';
    SIGNAL out2 :  STD_LOGIC:='X';

    SIGNAL nb   : integer :=4;
    SIGNAL fun  :  std_logic_vector(3 downto 0);
    SIGNAL dat  :  std_logic_vector(nb-1 downto 0);
    SIGNAL c    :  std_logic;    --carry
    SIGNAL z    :  std_logic;    --zero
    SIGNAL e    :  std_logic;

begin

    inst1: simdat 
        GENERIC MAP(
            tp => 10 ns,
            tclk => 100ns,
            ti1 => 320 ns,
            tf1 => 5000 ns,
            ti2 => 310 ns,
            tf2 => 1900 ns)
    PORT MAP(
            clk => open,
            adr => fun,
            data => data,
            out1 => open,
            out2 => open);
            
    inst2: alup
        GENERIC MAP(nb =>4 )
        PORT MAP(
            fun => fun,
            a => data(7 downto 4),
            b => data(3 downto 0),
            dat => dat,
            c => c,
            z => z,
            e => e);

end structural;
