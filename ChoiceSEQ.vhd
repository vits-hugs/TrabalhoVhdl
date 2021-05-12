library ieee;
use ieee.std_logic_1164.all;

entity ChoiceSEQ is
    port(
        Round1 : in std_logic_vector(3 downto 0);
        Setup : in std_logic_vector(1 downto 0);
        Round_BCD : out std_logic_vector(7 downto 0);
        Seq_FPGA  : out std_logic_vector(17 downto 0)
    );
end ChoiceSEQ;

architecture ChSeq of ChoiceSEQ is


    -- COMPONENTES
    component SEQ1 is
        port ( address : in std_logic_vector(3 downto 0);
               data : out std_logic_vector(17 downto 0) );
    end component;

    component SEQ2 is
        port ( address : in std_logic_vector(3 downto 0);
               data : out std_logic_vector(17 downto 0) );
    end component;

    component SEQ3 is
        port ( address : in std_logic_vector(3 downto 0);
               data : out std_logic_vector(17 downto 0) );
    end component;

    component SEQ4 is
        port ( address : in std_logic_vector(3 downto 0);
               data : out std_logic_vector(17 downto 0) );
    end component;

    component decBCD is
       port(binario : in std_logic_vector(3 downto 0);
            bcd : out std_logic_vector(7 downto 0));
    end component;
    


    component MUX4 is
        port(
            M1 : in std_logic_vector(17 downto 0);
            M2 : in std_logic_vector(17 downto 0);
            M3 : in std_logic_vector(17 downto 0);
            M4 : in std_logic_vector(17 downto 0);

            Selec : in std_logic_vector(1 downto 0);
            Escolha : out std_logic_vector(17 downto 0)
        );
    end component;

    Signal sq1,sq2,sq3,sq4 : std_logic_vector(17 downto 0);
    


begin

    decifradorbcd : decBCD port map(
        binario => Round1,
        bcd => Round_BCD
    );
    
    sequ1 : SEQ1 port map(
        address => Round1,
        data => sq1
    );

    sequ2 : SEQ2 port map(
        address => Round1,
        data => sq2
    );  

    sequ3 : SEQ3 port map(
        address => Round1,
        data => sq3
    );

    sequ4 : SEQ4 port map(
        address => Round1,
        data => sq4
    );

    selecionador : MUX4 port map(
        M1 => sq1,
        M2 => sq2,
        M3 => sq3,
        M4 => sq4,
        Selec => Setup,
        Escolha => Seq_FPGA

    );


end ChSeq;