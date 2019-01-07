library ieee;
use ieee.std_logic_1164.all;

entity tb_wbtxrx is
end tb_wbtxrx;

architecture behavioral of tb_wbtxrx is

	component wbm_dgen1 is
		generic (
			constant tp :in time := 10 ns;
			constant trst :in time := 320 ns;
			constant tclk :in time := 100 ns;
			constant npause :in integer := 10);
		port (
			signal rst_o	: out std_logic;
			signal clk_o	: out std_logic;
			signal we_o		: out std_logic;
			signal stb_o	: out std_logic;
			signal ack_i	: in std_logic;
			signal dat_o	: out std_logic_vector(7 downto 0));
	end component;

	component wbm_dmon1 IS
		generic (constant tp :in time := 10 ns);
		port (
			signal clk_i 	: in std_logic;
			signal rst_i	: in std_logic;
			signal ack_i	: in std_logic;
			signal rdy_i	: in std_logic;
			signal we_o 	: out std_logic;
			signal stb_o 	: out std_logic;
			signal dat_i 	: in std_logic_vector(7 downto 0));
		end component;

	component wbs_rxser is
	generic (constant nvt :in integer := 10);
    port (
		signal rst_i	: in std_logic;
		signal clk_i	: in std_logic;
		signal stb_i	: in std_logic;
		signal we_i		: in std_logic;
		signal rx		: in std_logic;
		signal rdy_o	: out std_logic;
		signal ack_o	: out std_logic;
		signal dat_o	: out std_logic_vector(7 downto 0));
	end component;

  component wbs_txser IS
    generic (constant nvt :in integer := 10);
    port (
		signal rst_i 	: in std_logic;
		signal clk_i 	: in std_logic;
		signal stb_i 	: in std_logic;
		signal we_i 	: in std_logic;
		signal dat_i 	: in std_logic_vector(7 downto 0);
		signal tx		: out std_logic;
		signal ack_o	: out std_logic);
  end component;

  signal dat1, dat2 : std_logic_vector(7 downto 0);
  signal clk, rst, txrx : std_logic;
  signal we1, stb1, ack1, rdy1 : std_logic;
  signal we2, stb2, ack2, rdy2 : std_logic;

begin
	inst1 : wbm_dgen1
	port map (
		rst_o => rst,
		clk_o => clk,
		dat_o => dat1,
		we_o => we1,
		stb_o => stb1,
		ack_i => ack1
	);

	inst2 : wbs_txser
	port map (
		rst_i => rst,
		clk_i => clk,
		dat_i => dat1,
		we_i => we1,
		stb_i => stb1,
		ack_o => ack1,
		tx => txrx
	);

	inst3 : wbs_rxser
	port map (
		rst_i => rst,
		clk_i => clk,
		dat_o => dat2,
		we_i => we2,
		stb_i => stb2,
		ack_o => ack2,
		rdy_o => rdy2,
		rx => txrx
	);

	inst4 : wbm_dmon1
    port map (
		rst_i => rst,
		clk_i => clk,
		dat_i => dat2,
		we_o => we2,
		stb_o => stb2,
		ack_i => ack2,
		rdy_i => rdy2
    );
end behavioral;