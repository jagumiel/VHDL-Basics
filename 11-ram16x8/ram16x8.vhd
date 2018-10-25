library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity ram16x8 is
	PORT(
		clk 	: in  std_logic;
		adr 	: in  std_logic_vector(3 downto 0);
		dat_i 	: in  std_logic_vector(7 downto 0);
		stb 	: in  std_logic;
		we 		: in  std_logic;
		dat_o 	: out std_logic_vector(7 downto 0));
end ram16x8;

architecture Behavioral of ram16x8 is


	type ram_type is array (0 to 15) of std_logic_vector (7 downto 0);
	signal ram : ram_type;
	
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			if (we = '1') then
				ram(conv_integer(adr)) <= dat_i;
			end if;
			dat_o <= ram(conv_integer(adr));
		end if;
	end process;
	

end Behavioral;