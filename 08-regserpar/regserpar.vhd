library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity regserpar is
    Port ( clk : in STD_LOGIC;
           d : in STD_LOGIC;
           en : in STD_LOGIC;
           dat : out STD_LOGIC_VECTOR (7 downto 0));
end regserpar;

architecture Behavioral of regserpar is

    signal data : STD_LOGIC_VECTOR (7 downto 0):="00000000";

begin

    process (clk)
    begin
        if(rising_edge(clk))then
            if(en='1')then
                data(6 downto 0)<=data(7 downto 1);
                data(7)<=d;
            end if;
        end if;
    end process;
    dat<=data;

end Behavioral;
