library ieee;
use ieee.std_logic_1164.all;

entity REG_setup is
    port(
        R : in std_logic;
        E : in std_logic;

        FazSetup : in std_logic_vector(13 downto 0);
        CLK_500Hz : in std_logic;
        
        SaiSetup  : out std_logic_vector(13 downto 0)
    );
end REG_setup;

architecture principal of REG_setup is
begin
    process(CLK_500Hz,R)
    begin
        if  (R = '1') then
            SaiSetup <= "00000000000000";
        elsif (CLK_500Hz'event AND CLK_500Hz = '1') then
            if (E = '1') then
                SaiSetup <= FazSetup;
            end if;
        end if;
    end process;
end principal;