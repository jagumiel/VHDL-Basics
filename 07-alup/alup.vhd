library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
 
entity alup is
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
end alup;

architecture Behavioral of alup is
    signal data : std_logic_vector(nb downto 0); --dat auxiliar.
    signal aa   : std_logic_vector(nb downto 0);
    signal ba   : std_logic_vector(nb downto 0);
    constant ceros : std_logic_vector(nb downto 0) := (others => '0');
    --Hay que hacer dos vectores auxiliares de nb+1 bits (nb downto 0). Para a y para b. Al hacer las operaciones con esos vectores, el MSB es el Carry.

begin

    aa<='0' & a;
    ba<='0' & b;
    
    WITH fun select
        e <='0' when "0111",
            '1' when OTHERS;
            
    process(fun, aa, ba)
    begin

        case fun is
            when "0000" => data<=aa;
            when "0001" => data<='0' & (not(aa(nb-1 downto 0)));
            when "0010" => data<=aa or ba;
            when "0011" => data<=aa and ba;
            when "0100" => data<=aa xor ba;
            when "0101" => data<=aa+ba;
            when "0110" => data<=aa-ba;
            when "0111" => data<=aa-ba; --Resta extendida. En este caso la salida e vale 0. Va aparte.
            when "1000" => data<=aa+1;
            when "1001" => data<=aa-1;
            when "1010" => data<=a(nb-1) & a(nb-2 downto 0)& a(nb-1);   --rotate_left(a);
            when "1011" => data<=a(0) & a(0)& a(nb-1 downto 1);      --rotate_right(a);
            when others => data<=aa;
        end case;
    end process;
    
    dat<=data(nb-1 downto 0);
    c<=data(nb);
    
    process(data)
    begin
        if data=ceros then
            z<='1';
        else
            z<='0';
        end if;
    end process;

    --Las operaciones las tienes que hacer en nb bits + 1. La llevada, en caso de haberla, sera el bit mas significativo
    --Si todos los bits son 0, significa que el flag de zero se tiene que activar. Comparar con vector=0
    
end Behavioral;
