library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter_round is port (
   Data: in std_logic_vector(3 downto 0);

   SET: in std_logic;
   E:  in std_logic; 

   CLK_500Hz: in std_logic;

   Tc: out std_logic;
   ROUND1: out std_logic_vector(3 downto 0));
end Counter_round;

architecture Counter of Counter_round is
   signal Count: std_logic_vector(3 downto 0);
begin

    ROUND1 <= Count;
    Tc <= '1' when (Count = "0000" ) else '0';
    
	REG: process(CLK_500Hz,SET)
	begin
	    if (SET = '1') then
			Count <= Data;
			
        elsif (CLK_500Hz'event AND CLK_500Hz = '1' and E = '1') then 
            if (Count= "0000") then
                Count <= "0000";
            else
         	    Count <= Count - 1;
         	end if;
	    end if;
	end process;

end Counter;
