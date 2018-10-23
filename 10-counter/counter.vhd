library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.numeric_std.all;


entity counter is
    Generic(
        constant nb : in integer;
        constant nc : in integer);
    Port (
        signal rst  : in std_logic;
        signal clk  : in std_logic;
        signal dat  : out std_logic_vector(nb downto 0));
end counter;

architecture Behavioral of counter is

    signal data : std_logic_vector(nb downto 0):=((others=>'0'));
    signal limite : std_logic_vector(nb downto 0);

begin
    limite <= std_logic_vector(to_unsigned(nc, nb+1));

    process(clk)
    begin
        if(rising_edge(clk))then
            if(data<limite)then
                data<=data+'1';
            else
                data<=((others=>'0'));
            end if;
        end if;
        if (rst='1')then
            data<=((others=>'0'));
        end if;
    end process;
    dat<=data;

end Behavioral;
