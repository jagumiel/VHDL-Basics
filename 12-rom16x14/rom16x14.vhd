library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_unsigned.all;

entity rom16x14 is
	PORT(
		clk 	: in  std_logic;
		adr 	: in  std_logic_vector(3 downto 0);
		stb 	: in  std_logic;
		dat_o 	: out std_logic_vector(13 downto 0));
end rom16x14;

architecture Behavioral of rom16x14 is

	type rom_type is array (0 to 15) of std_logic_vector (13 downto 0);
	signal rom : rom_type:=
		(
		"11101011110010", "10101110111101", "10101000110110", "10010110011011", 
		"10101101010010", "01011100110010", "11011000001101", "01000010010011", 
		"00000010111010", "10110111101100", "11100111001111", "00110110000011", 
		"11100100010010", "01000011011010", "11101111100011", "11011101100100"
		);
	attribute rom_style: string;
	attribute rom_style of rom: signal is "block";
	
begin
	process (clk)
	begin
		if (rising_edge(clk)) then
			if(stb='1')then
				dat_o <= rom(conv_integer(adr));
			end if;
		end if;
	end process;

end Behavioral;