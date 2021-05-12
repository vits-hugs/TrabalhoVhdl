library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter_time is port (
   rst1: in std_logic;
   rst2: in std_logic;
   E:  in std_logic; 
   CLK_1Hz: in std_logic;
   Tc: out std_logic;
   Temp: out std_logic_vector(3 downto 0));
end Counter_time;

architecture Counter of Counter_time is
   signal Count: std_logic_vector(3 downto 0);
   signal Reset: std_logic;
begin

    Temp <= Count;
    Reset <= rst1 or rst2;
    Tc <= '1' when (Count = "1010" ) else '0';
    
	ContaTempo: process(CLK_1Hz,Reset)
	begin
	    if (Reset = '1') then
			Count <= "0000";
        elsif (CLK_1Hz'event AND CLK_1Hz = '1' and E = '1') then 
         	Count <= Count + 1;
	    end if;
	end process;

end Counter;
