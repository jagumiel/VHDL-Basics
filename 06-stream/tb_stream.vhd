library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity tb_stream is
    GENERIC(
        CONSTANT trst: in  time := 320 ns;
        CONSTANT tclk: in  time := 100 ns);
    PORT (
        SIGNAL rst      : out std_logic;
        SIGNAL clk      : out std_logic;
        SIGNAL stream   : out std_logic;
        SIGNAL sta      : out std_logic);
end tb_stream;

architecture dataflow of tb_stream is
    
    SIGNAL clka     : std_logic:='0';
    SIGNAL rsta     : std_logic:='0';
    SIGNAL streama  : std_logic:='0';

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
    variable  Leyendo   : boolean;                      -- continuación de lectura de línea
    variable  Caract    : character;                    -- variable para leer de fichero
    variable  i    : integer;

    BEGIN
        IF(rising_edge(clka)) THEN
            IF(rsta='0') THEN
                --Leer
                sta<='0';
                i:=0;
                -- Lectura de cada linea del fichero de texto
                while (i<1) loop 
                    read (Fich_Cmd, Caract);
                    case Caract is
                        when '0' => streama<='0'; i:=i+1;
                        when '1' => streama<='1'; i:=i+1;
                        when LF  => sta <='1';
                        when CR  => sta <='1';
                        when others => streama<='X';
                    end case;
                end loop;
            END IF;
        END IF;
    END PROCESS;
    stream<=streama;

end dataflow;
