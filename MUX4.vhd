library ieee;
use ieee.std_logic_1164.all;

entity MUX4 is
    port(
        M1 : in std_logic_vector(17 downto 0);
        M2 : in std_logic_vector(17 downto 0);
        M3 : in std_logic_vector(17 downto 0);
        M4 : in std_logic_vector(17 downto 0);

        Selec : in std_logic_vector(1 downto 0);
        Escolha : out std_logic_vector(17 downto 0)
    );
end MUX4;
architecture mux of MUX4 is
begin

    Escolha <= M1 when Selec = "00" else
        M2 when Selec = "01" else
        M3 when Selec = "10" else
        M4;
      
end mux;
