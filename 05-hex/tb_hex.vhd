library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_hex is
--  Port ( );
end tb_hex;

architecture dataflow of tb_hex is

    component simproc is
        GENERIC(
            CONSTANT trst: in  time := 320 ns;
            CONSTANT tclk: in  time := 100 ns);
        port(
            SIGNAL rst : out std_logic;
            SIGNAL clk : out std_logic;
            SIGNAL sta : out std_logic;
            SIGNAL dat : out std_logic_vector(7 downto 0)
        );
    end component;
    
    component monproc is
        PORT(
            SIGNAL rst : IN std_logic;
            SIGNAL clk : IN std_logic;
            SIGNAL sta : IN std_logic;
            SIGNAL dat : IN std_logic_vector(7 downto 0)
        );
    end component;
    
    --Declaro las variables intermedias de mi jerarquia tope.
    SIGNAL rsta : std_logic;
    SIGNAL clka : std_logic;
    SIGNAL staa : std_logic;
    SIGNAL data : std_logic_vector(7 downto 0);

begin

    inst1: simproc
        generic map(
            trst=>320ns,
            tclk=>100ns)
        port map(
            rst=>rsta,
            clk=>clka,
            sta=>staa,
            dat=>data
        );
        
    inst2: monproc
        port map(
            rst=>rsta,
            clk=>clka,
            sta=>staa,
            dat=>data
        );

end dataflow;
