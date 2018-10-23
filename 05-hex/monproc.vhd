library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity monproc is
    PORT(
        SIGNAL rst : IN std_logic;
        SIGNAL clk : IN std_logic;
        SIGNAL sta : IN std_logic;
        SIGNAL dat : IN std_logic_vector(7 downto 0)
    );
end monproc;

architecture dataflow of monproc is
	type      CmdFile  is file of character;
	file      Fich_Cmd : CmdFile   open write_mode is "prueba_salida.txt";
begin

    process (clk)
        variable  DataPack  : std_logic_vector(7 downto 0); -- pack de datos y direcciones
        variable  N_Nibb    : integer range 1 downto 0; -- Número de nibble a extraer
        variable  Nibb      : std_logic_vector(3 downto 0); -- Nibble a extraer
        variable  Caract    : character; -- variable para leer caracteres de fichero
    
    begin
        if (falling_edge(clk) and rst='0')then   -- Se ejecuta monitoreo en flanco de subida
            DataPack := dat; -- Todos los bits en un paquete
            
            if(sta='1')then
                write(Fich_Cmd,CR);
                write(Fich_Cmd,LF);
            end if;
            
            for N_Nibb in 1 downto 0 loop
                Nibb := DataPack(N_Nibb*4+3 downto N_Nibb*4);
                case Nibb is
                    when "0000" => Caract :='0';
                    when "0001" => Caract :='1';
                    when "0010" => Caract :='2';
                    when "0011" => Caract :='3';
                    when "0100" => Caract :='4';
                    when "0101" => Caract :='5';
                    when "0110" => Caract :='6';
                    when "0111" => Caract :='7';
                    when "1000" => Caract :='8';
                    when "1001" => Caract :='9';
                    when "1010" => Caract :='A';
                    when "1011" => Caract :='B';
                    when "1100" => Caract :='C';
                    when "1101" => Caract :='D';
                    when "1110" => Caract :='E';
                    when "1111" => Caract :='F';
--                    when "ZZZZ" => Caract :='Z';
                    when others => Caract :='X';
                end case;
                write(Fich_Cmd,Caract);
            end loop;
        end if;
    end process;

end dataflow;
