library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;

entity alup is
    GENERIC(nb:integer:=4);
    PORT(
        fun : in std_logic_vector(3 downto 0);
        a   : in std_logic_vector(nb downto 0);
        b   : in std_logic_vector(nb downto 0);
        dat : out std_logic_vector(nb downto 0);
        c   : out std_logic;    --carry
        z   : out std_logic;    --zero
        e   : out std_logic     --extended (resta extendida)
    );
end alup;

architecture Behavioral of alup is
    signal data : std_logic_vector(nb downto 0); --dat auxiliar.

begin
    process(fun, a, b)
    begin
        case fun is
            when "0000" => data<=a;
            when "0001" => data<=not(a);
            when "0010" => data<=a or b;
            when "0011" => data<=a and b;
            when "0100" => data<=a xor b;
            when "0101" => data<=a+b;
            when "0110" => data<=a-b;
            when "0111" => data<=a-b; --RESTA EXTENDIDA, devuelve '1' booleano si es menor.
            when "1000" => data<=a+1;
            when "1001" => data<=a-1;
            when "1010" => data<= --shift_left(a);
            when "1011" => data<=--shift_right(a);
            when others => data<=a;
        end process;
end Behavioral;
