library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity stack is
    port ( 	clk 	: in  std_logic;
			dat_i 	: in  std_logic_vector (7 downto 0);
			we 		: in  std_logic;
			stb 	: in  std_logic;
			dat_o 	: out  std_logic_vector (7 downto 0));
end stack;

architecture behavioral of stack is
	type Ram_8x8 is array (7 downto 0) of std_logic_vector(7 downto 0); --Memoria
	signal bufmem : Ram_8x8;
	signal pos : integer range -1 to 8 := -1;
	--Uso el push y el pop para apilar o desapilar.
	--Si la pila esta llena no acepto nuevos datos, y si esta vacia no saco nada.
	signal pop, push : std_logic;

begin
	
	process(clk)
	begin
        if(rising_edge(clk))then
            if(stb='1') then
                if(we='1')then
                    if(push='1' and pos<8)then
                        bufmem(conv_integer(pos))<=dat_i;
                    end if;
                else
                    if(pop='1')then
                        dat_o <= bufmem(conv_integer(pos));
                    else
                        dat_o <= (others=>'X');
                    end if;
                end if;
            else
                dat_o <= (others=>'X');
            end if;
        end if;
    end process;

    process(clk)
    begin
        if (rising_edge(clk)) then
            if(we='1')then
                pop<='0';
                if(pos=8)then
                    push<='0';
                else
                    push<='1';
                    pos<=pos+1;
                end if;
            else
                push<='0';
                if(pos<=0)then
                    pop<='0';
                else
                    pop<='1';
                    pos<=pos-1;
                end if;
            end if;
        end if;
    end process;
end behavioral;