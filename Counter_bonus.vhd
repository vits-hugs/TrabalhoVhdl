library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity Counter_bonus is port (

   SET: in std_logic;
   SETUP: in std_logic_vector(3 downto 0);

   enable1:  in std_logic;
   enable2: in std_logic;

   CLK_500Hz: in std_logic;

   SEQ_FPGA: in std_logic_vector(17 downto 0);
   Switches: in std_logic_vector(17 downto 0);

   Tc: out std_logic;
   Bonus: out std_logic_vector(5 downto 0));
   
end Counter_bonus;

architecture bonus of Counter_bonus is
   signal E: std_logic;
   signal Acertos: std_logic_vector(17 downto 0);

   signal Data: std_logic_vector(5 downto 0);
   signal Data2: std_logic_vector(5 downto 0);
   signal QtdBonus: std_logic_vector(5 downto 0);

   component sum is port 
    (f: in std_logic_vector(17 downto 0);
    q: out std_logic_vector(5 downto 0));
    end component;

begin
    Acertos <= SEQ_FPGA xor Switches;
    Soma: sum port map(f => Acertos, q => data);
    
    Data2 <= "00" & SETUP;
    E <= enable1 and not(enable2);

    Bonus <= QtdBonus;
    
    Tc <= '1' when (QtdBonus > "1111" ) else '0';
    
	REG: process(CLK_500Hz,SET)
	begin
	    if (SET = '1') then
			QtdBonus <= Data2;
        elsif (CLK_500Hz'event AND CLK_500Hz = '1' and E = '1') then 
         	QtdBonus <= QtdBonus - Data;
	    end if;
	end process;
    
end bonus;
