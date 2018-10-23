library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity simproc is
    GENERIC(
        CONSTANT trst: in  time := 320 ns;
        CONSTANT tclk: in  time := 100 ns);
    port(
        SIGNAL rst : out std_logic;
        SIGNAL clk : out std_logic;
        SIGNAL sta : out std_logic;
        SIGNAL dat : out std_logic_vector(7 downto 0)
    );
end simproc;

architecture dataflow of simproc is
    SIGNAL clka : std_logic:='0';
    SIGNAL rsta : std_logic:='0';
    SIGNAL cont : std_logic_vector(1 downto 0) := "00";
    SIGNAL data : std_logic_vector(7 downto 0); --Dat Aux.
    SIGNAL staa : std_logic:='0';
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
    
    PROCESS --Salida reset. Espera y pone a cero el flanco de reset.
    BEGIN
        rsta<='1';
        rsta<='0' AFTER trst;
        wait;
    END PROCESS;
    rst<=rsta;
    



    PROCESS(clka)
    --Declaración de tipos
    type CmdFile  is file of character;
    file Fich_Cmd : CmdFile   open read_mode is "prueba.txt";
    --Variables
    variable  DataPack  : std_logic_vector(7 downto 0); -- datos hex leídos en línea
    variable  Leyendo   : boolean;                      -- continuación de lectura de línea
    variable  Caract    : character;                    -- variable para leer de fichero
    variable  I    : integer;
    BEGIN
        IF(rising_edge(clka)) THEN
            IF(rsta='0') THEN
                --Leer
                I:=0;
                sta<='0';
                DataPack  :=  (others=>'0');
            
                -- Lectura de cada linea del fichero de texto
                while (I<2) loop 
                    read (Fich_Cmd, Caract);
                    case Caract is
                        when '0' => DataPack := DataPack(3 downto 0) & "0000"; I := I+1;
                        when '1' => DataPack := DataPack(3 downto 0) & "0001"; I := I+1;
                        when '2' => DataPack := DataPack(3 downto 0) & "0010"; I := I+1;
                        when '3' => DataPack := DataPack(3 downto 0) & "0011"; I := I+1;
                        when '4' => DataPack := DataPack(3 downto 0) & "0100"; I := I+1;
                        when '5' => DataPack := DataPack(3 downto 0) & "0101"; I := I+1;
                        when '6' => DataPack := DataPack(3 downto 0) & "0110"; I := I+1;
                        when '7' => DataPack := DataPack(3 downto 0) & "0111"; I := I+1;
                        when '8' => DataPack := DataPack(3 downto 0) & "1000"; I := I+1;
                        when '9' => DataPack := DataPack(3 downto 0) & "1001"; I := I+1;
                        when 'A' => DataPack := DataPack(3 downto 0) & "1010"; I := I+1;
                        when 'B' => DataPack := DataPack(3 downto 0) & "1011"; I := I+1;
                        when 'C' => DataPack := DataPack(3 downto 0) & "1100"; I := I+1;
                        when 'D' => DataPack := DataPack(3 downto 0) & "1101"; I := I+1;
                        when 'E' => DataPack := DataPack(3 downto 0) & "1110"; I := I+1;
                        when 'F' => DataPack := DataPack(3 downto 0) & "1111"; I := I+1;
                        when LF  => sta <='1';
                        when others => 
                    end case;
                end loop;
                data<=DataPack(7 downto 0);
            END IF;
        END IF;
    END PROCESS;
    dat<=data;
    
end dataflow;
