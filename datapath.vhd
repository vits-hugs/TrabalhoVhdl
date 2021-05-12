library IEEE;
use IEEE.Std_Logic_1164.all;
use IEEE.std_logic_signed.all;

entity datapath is
port(sw_entra: in std_logic_vector(17 downto 0);
r1, e1,e2,e3,e4,e5, e6, clk1, clk50, key_entra: in std_logic;
h0, h1, h2, h3, h4, h5, h6, h7: out std_logic_vector(6 downto 0);
led_out: out std_logic_vector (17 downto 0);
end_time, end_bonus, end_round, end_FPGA: out std_logic);

end datapath;

architecture arqdata of datapath is
    Signal Tempo,Round1,EscolhaSeq: std_logic_vector(3 downto 0);
    Signal BONUS : std_logic_vector(5 downto 0);
    Signal RoundBCD : std_logic_vector(7 downto 0);
    Signal Setup,Seq_FPGA : std_logic_vector(17 downto 0);
    Signal EroundAux,Eaux : std_logic;
    Signal  dc7s1,dc7s2,dc7s3,dc7s4,dc7s5,dc7s6,dc7s7,dc7s8,dc7s9,dc7s10,dc7s11,dc7s12   : std_logic_vector (6 downto 0);
    Signal PontosFpga: std_logic_vector(11 downto 0);
    Signal PontosUser: std_logic_vector(11 downto 0);

    component REG_setup is
        port(
            R : in std_logic;
            E : in std_logic;
    
            FazSetup : in std_logic_vector(13 downto 0);
            SaiSetup  : out std_logic_vector(13 downto 0);

            CLK_500Hz : in std_logic
        );
    end component;

    component Counter_level is port (
        Data: in std_logic_vector(3 downto 0);
        rst1: in std_logic;
        rst2: in std_logic; 
        E:  in std_logic; 
        CLK_1Hz: in std_logic;
        Tc: out std_logic);
    end component;

    component Counter_time is port (
        rst1: in std_logic;
        rst2: in std_logic;
        E:  in std_logic; 
        CLK_1Hz: in std_logic;
        Tc: out std_logic;
        Temp: out std_logic_vector(3 downto 0));
    end component;

    component Counter_round is port (
        Data: in std_logic_vector(3 downto 0);

        SET: in std_logic;
        E:  in std_logic; 

        CLK_500Hz: in std_logic;

        Tc: out std_logic;
        ROUND1: out std_logic_vector(3 downto 0));
    end component;

    component ChoiceSEQ is
        port(
            Round1 : in std_logic_vector(3 downto 0);
            Setup : in std_logic_vector(1 downto 0);
            Round_BCD : out std_logic_vector(7 downto 0);
            Seq_FPGA  : out std_logic_vector(17 downto 0)
        );
    end component;

    component Counter_bonus is port (

        SET: in std_logic;
        SETUP: in std_logic_vector(3 downto 0);

        enable1:  in std_logic;
        enable2: in std_logic;

        CLK_500Hz: in std_logic;

        SEQ_FPGA: in std_logic_vector(17 downto 0);
        Switches: in std_logic_vector(17 downto 0);

        Tc: out std_logic;
        Bonus: out std_logic_vector(5 downto 0));
    
    end component;

    component MUX182 is port(
        M1 : in std_logic_vector(17 downto 0);
        M2 : in std_logic_vector(17 downto 0);
        Selec: in std_logic;
        Escolha : out std_logic_vector(17 downto 0)
    );
    end component;

    component MUX3M2 is port(
        E5,E6 : in std_logic;
        end_round_aux : in std_logic;
        G0,G1,G2,G3 : in std_logic_vector(6 downto 0);
        Escolha : out std_logic_vector(6 downto 0)
    );
    end component;


    component dec7seg is port(
       entrada : in std_logic_vector(3 downto 0);
       saida : out std_logic_vector(6 downto 0)
    );

    end component;




begin

    --- Registrador seta o setup
    Config: REG_setup  port map(
            R =>r1,
            E =>e1,

            FazSetup => sw_entra(13 downto 0),
            SaiSetup => Setup(13 downto 0),---- Gera signal setup
            
            CLK_500Hz => clk50
        );

    -- Counter Level
    CLevel:Counter_level port map(
        Data => Setup(9 downto 6), -- Setup que sai do registri
        rst1 => r1,
        rst2 =>e4,
        E => e2,
        CLK_1Hz  => clk1,
        Tc => end_FPGA
    );

    --- Counter Time
    CTime: Counter_time port map(
        rst1 => r1,
        rst2 =>e4,
        E => e3,
        CLK_1Hz  => clk1,
        Tc => end_time,
        Temp => Tempo ---
    );
    ---- Counter Round
    CRound: Counter_round port map(
        Data => Setup(3 downto 0),

        SET => e1,
        E => e4,

        CLK_500Hz => clk50,

        Tc => EroundAux, ---- e depois pro end round aux ver 
        ROUND1 => Round1

    );
    
    end_round <= EroundAux;
  
    
    


    --- Seleciona a sequencia
    SeSequencia: ChoiceSEQ port map(
            Round1 => Round1,
            Setup => Setup(5 downto 4),

            Round_BCD =>  RoundBCD, --- sair no mux
            Seq_FPGA  => Seq_FPGA ---- signal é a sequencia pra ser comparada no bonus
        );

    Cbonus: Counter_bonus port map(
        SET => e1,
        SETUP => Setup(13 downto 10), --- signal setup

        enable1 => e3,
        enable2 => key_entra ,----- BTN1-------------------------------------------------------

        CLK_500Hz => clk50,

        SEQ_FPGA => Seq_FPGA,
        Switches => sw_entra,

        Tc => end_bonus,
        Bonus => BONUS
    );


    ------ MUX ---------


    SeqMux: MUX182 port map(
        M1 => "000000000000000000",
        M2 => Seq_FPGA,
        Selec => e2,
        Escolha =>led_out

    );

    ------ HEX 7 ---------

    MUXHEX7: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => EroundAux,
        G0   => "1000111",--L
        G1   => "0101111",--R
        G2   => "0001110",--F
        G3   => "1000001",--U
        Escolha =>  h7
    );




    -------  HEX6 -----------
    Hex6dec:dec7seg  port map(
       entrada => Setup(9 downto 6),
       saida => dc7s1
    );



      MUXHEX6: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => EroundAux,
        G0  => dc7s1,
        G1  => "0100011",-- O
        G2  => "0001100",-- P
        G3  => "0010010",-- S
        Escolha =>  h6
    );


    -------- HEX5 ------------
    MUXHEX5: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => EroundAux,
        G0  => "1100001",-- J
        G1  => "1000001",-- U
        G2  => "0010000",-- G
        G3  => "0000110",-- E
        Escolha =>  h5
    );


    EscolhaSeq <= "00" & Setup(5 downto 4);
    -------- HEX4 --------
    Hex4dec:dec7seg  port map(
       entrada => EscolhaSeq,
       saida => dc7s2
    );

    MUXHEX4: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => EroundAux,
        G0  => dc7s2,
        G1  => "0101011",--N
        G2  => "0001000", -- A
        G3  => "0101111", -- R
        Escolha =>  h4
    );


    -------- HEX3 ----------

    MUXHEX3: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => eaux,
        G0  =>"0000111",  --T
        G1  =>"1100001", -- D
        G2  =>"0110111", -- =
        G3  =>"0110111", -- =
        Escolha => h3
    );

    PontosFpga <= "00" & Round1 & not(BONUS);
    PontosUser <= "00" & not(Round1) & BONUS;
    ------- HEX2 -----------

    Hex2dec1:dec7seg  port map(
       entrada => Tempo,
       saida => dc7s3
    );

    Hex2dec2:dec7seg  port map(
       entrada => PontosFpga(11 downto 8),
       saida => dc7s4
    );

    Hex2dec3:dec7seg  port map(
       entrada => PontosUser(11 downto 8),
       saida => dc7s5
    );

    


    MUXHEX2: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => EroundAux ,
        G0  => dc7s3,
        G1  => "0110111",--=
        G2  => dc7s4,
        G3  => dc7s5,
        Escolha =>  h2
    );


    ------------ HEX 1 --------

    Hex1dec1:dec7seg  port map(
       entrada => RoundBCD(7 downto 4),
       saida => dc7s6
    );

    Hex1dec2:dec7seg  port map(
       entrada =>PontosFpga(7 downto 4),
       saida => dc7s7
    );

    Hex1dec3:dec7seg  port map(
       entrada => PontosUser(7 downto 4),
       saida => dc7s8
    );

    

    MUXHEX1: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => eaux,
        G0  => "0000011",--B
        G1  => dc7s6,
        G2  => dc7s7,
        G3  => dc7s8,
        Escolha =>  h1
    );

    ----- HEX0 --------

    Hex0dec1:dec7seg  port map(
       entrada => BONUS(3 downto 0),
       saida => dc7s9
    );

    Hex0dec2:dec7seg  port map(
       entrada => RoundBCD(3 downto 0),
       saida => dc7s10
    );

    Hex0dec3:dec7seg  port map(
       entrada => PontosFpga(3 downto 0),
       saida => dc7s11
    );

    Hex0dec4:dec7seg  port map(
       entrada => PontosUser(3 downto 0), 
       saida => dc7s12
    );


    MUXHEX0: MUX3M2 port map(
        E5 => e5,
        E6 => e6,
        end_round_aux => eaux,
        G0  => dc7s9,
        G1  => dc7s10,
        G2  => dc7s11,
        G3  => dc7s12,
        Escolha =>  h0
    );









end arqdata;




