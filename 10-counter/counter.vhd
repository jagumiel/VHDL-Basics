library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE IEEE.STD_LOGIC_ARITH.ALL;

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
    
	signal data : UNSIGNED(nb downto 0):=((others=>'0'));

begin

    process(clk)
    begin
        if(rising_edge(clk))then
			if (rst='1')then
				data<=((others=>'0'));
            elsif(data<(UNSIGNED(CONV_STD_LOGIC_VECTOR(nc, nb+1))))then
                data<=data+'1';
            else
                data<=((others=>'0'));
            end if;
        end if;
    end process;
    dat<=std_logic_vector(data);

end Behavioral;
