library ieee;
use ieee.std_logic_1164.all;

entity tb_stack is
end tb_stack;

architecture dataflow of tb_stack is

    COMPONENT stack IS
        PORT(
            clk     : in   std_logic;
            dat_i   : in   std_logic_vector(7 downto 0);
            we      : in   std_logic;
            stb     : in   std_logic;
            dat_o   : out  std_logic_vector(7 downto 0));
        END COMPONENT;

    COMPONENT simdat IS
        GENERIC(
            CONSTANT tp     : IN time := 10 ns;
            CONSTANT tclk   : IN time := 100 ns;
            CONSTANT ti1    : IN time := 350 ns;
            CONSTANT tf1    : IN time := 1150 ns;
            CONSTANT ti2    : IN time := 350 ns;
            CONSTANT tf2    : IN time := 5000 ns); 
        PORT (
            SIGNAL clk  : OUT STD_LOGIC; 
            SIGNAL adr  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0); 
            SIGNAL data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            SIGNAL out1 : OUT STD_LOGIC;
            SIGNAL out2 : OUT STD_LOGIC);
    END COMPONENT;

   signal clk : std_logic;
   signal dat_i : std_logic_vector(7 downto 0);
   signal we : std_logic;
   signal stb : std_logic;
   signal dat_o : std_logic_vector(7 downto 0);

begin
    inst1 : simdat 
        port map (
            clk => clk,
            adr => open,
            data => dat_i,
            out1 => we,
            out2 => stb);

    inst2: stack 
        port map (
            clk => clk,
            dat_i => dat_i,
            we => we,
            stb => stb,
            dat_o => dat_o);
end dataflow;