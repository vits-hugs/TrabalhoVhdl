library ieee;
use ieee.std_logic_1164.all;

entity MUX2 is
    port(
        M1 : in std_logic_vector(6 downto 0);
        M2 : in std_logic_vector(6 downto 0);
        Selec : in std_logic;
        Escolha : out std_logic_vector(6 downto 0)
    );
end MUX2;
architecture mx7bt of MUX2 is

begin
    Escolha <= M1 when Selec = '0' else
        M2;
        
end mx7bt;