library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity simdat is
	GENERIC(
        CONSTANT tp     : IN time := 10 ns;
        CONSTANT tclk   : IN time := 100 ns;
        CONSTANT ti1    : IN time := 320 ns;
        CONSTANT tf1    : IN time := 5000 ns;
        CONSTANT ti2    : IN time := 310 ns;
        CONSTANT tf2    : IN time := 1900 ns); 
PORT (
        SIGNAL clk  : OUT STD_LOGIC; 
        SIGNAL adr  : OUT STD_LOGIC_VECTOR(3 DOWNTO 0):="1111"; 
        SIGNAL data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        SIGNAL out1 : OUT STD_LOGIC;
        SIGNAL out2 : OUT STD_LOGIC);
end simdat;

architecture dataflow of simdat is

--Declaración de señales internas
SIGNAL clka : STD_LOGIC;
SIGNAL out1i: STD_LOGIC;
SIGNAL adri : STD_LOGIC_VECTOR(3 DOWNTO 0) :="1111"; 
SIGNAL datai: STD_LOGIC_VECTOR(7 DOWNTO 0);

begin

	PROCESS --Salida clk (Bucle infinito, el reloj no tiene que parar).
    BEGIN
		clka <= '1';
        WHILE TRUE LOOP
			clka <= '0';
			WAIT FOR tclk/2;
			clka <= '1';
			WAIT FOR tclk/2;
        END LOOP;
    END PROCESS;
    clk<=clka;
    
    PROCESS --Salida out1i
    BEGIN
        out1i<='0';
        WAIT FOR (ti1-tclk);
        out1i<='1';
        WAIT FOR (tf1-tclk);
    END PROCESS;
    
    PROCESS(clka)
    BEGIN
        IF(rising_edge(clka) and out1i='1') THEN
            IF(adri<"1111")THEN 
                adri<=adri+'1';
            ELSE
                adri<="0000";
            END IF;
        END IF;
    END PROCESS;
    
    PROCESS(clka)
    --Declaración de tipos
    type CmdFile  is file of character;
    file Fich_Cmd : CmdFile   open read_mode is "prueba.txt";
    --Variables
    variable  DataPack  : std_logic_vector(7 downto 0);-- datos hex leídos en línea
    variable  Leyendo   : boolean;                         -- continuación de lectura de línea
    variable  Caract    : character;                    -- variable para leer de fichero
    BEGIN
        IF(rising_edge(clka)) THEN
            IF(out1i='1') THEN
                --Leer
                Leyendo   :=  true;
                DataPack  :=  (others=>'0');
            
                -- Lectura de cada linea del fichero de texto
                while (Leyendo) loop 
                    read (Fich_Cmd, Caract);
                    case Caract is
                        when '0' => DataPack := DataPack(3 downto 0) & "0000";
                        when '1' => DataPack := DataPack(3 downto 0) & "0001";
                        when '2' => DataPack := DataPack(3 downto 0) & "0010";
                        when '3' => DataPack := DataPack(3 downto 0) & "0011";
                        when '4' => DataPack := DataPack(3 downto 0) & "0100";
                        when '5' => DataPack := DataPack(3 downto 0) & "0101";
                        when '6' => DataPack := DataPack(3 downto 0) & "0110";
                        when '7' => DataPack := DataPack(3 downto 0) & "0111";
                        when '8' => DataPack := DataPack(3 downto 0) & "1000";
                        when '9' => DataPack := DataPack(3 downto 0) & "1001";
                        when 'A' => DataPack := DataPack(3 downto 0) & "1010";
                        when 'B' => DataPack := DataPack(3 downto 0) & "1011";
                        when 'C' => DataPack := DataPack(3 downto 0) & "1100";
                        when 'D' => DataPack := DataPack(3 downto 0) & "1101";
                        when 'E' => DataPack := DataPack(3 downto 0) & "1110";
                        when 'F' => DataPack := DataPack(3 downto 0) & "1111";
                        when LF  => Leyendo := FALSE;
                        when others => 
                    end case;
                    --datai<=DataPack(7 downto 0);
                end loop;
                datai<=DataPack(7 downto 0);
            END IF;
        END IF;
    END PROCESS;
    
    PROCESS --Salida out1
    BEGIN
        out1<='0';
        WAIT FOR ti1;
        out1<='1';
        WAIT FOR tf1;
        out1<='0';
    END PROCESS;
    
    PROCESS --Salida out2
    BEGIN
        out2<='0';
        WAIT FOR ti2;
        out2<='1';
        WAIT FOR tf2;
        out2<='0';
    END PROCESS;
    
    adr<=adri AFTER tp;
    data<=datai AFTER tp;
end dataflow;