library ieee;
use ieee.std_logic_1164.all;

entity decBCD is
    port(
       binario:in std_logic_vector(3 downto 0);
       bcd:   out std_logic_vector(7 downto 0)
    );
end decBCD;

architecture bcd of decBCD is
begin
    bcd <= "00000000" when binario = "0000" else
        "00000001" when binario = "0001" else
        "00000010" when binario = "0010" else
        "00000011" when binario = "0011" else
        "00000100" when binario = "0100" else
        "00000101" when binario = "0101" else
        "00000110" when binario = "0110" else
        "00000111" when binario = "0111" else
        "00001000" when binario = "1000" else 
        "00001000" when binario = "1001" else 
        "00010000" when binario = "1010" else
        "00010001" when binario = "1011" else
        "00010010" when binario = "1100" else
        "00010011" when binario = "1101" else
        "00010100" when binario = "1110" else
        "00010101";
end bcd;