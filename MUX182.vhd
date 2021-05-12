library ieee;
use ieee.std_logic_1164.all;

entity MUX182 is
    port(
        M1 : in std_logic_vector(17 downto 0);
        M2 : in std_logic_vector(17 downto 0);
        Selec: in std_logic;
        Escolha : out std_logic_vector(17 downto 0)
    );
end MUX182;
architecture bt18mx of MUX182 is

begin
    Escolha <= M1 when Selec= '0' else
        M2;
        
end bt18mx;