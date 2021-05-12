library ieee;
use ieee.std_logic_1164.all;

entity MUX3M2 is
    port(
        E5,E6 : in std_logic;
        end_round_aux : in std_logic;
        G0,G1,G2,G3 : in std_logic_vector(6 downto 0);
        Escolha : out std_logic_vector(6 downto 0)
    );
end MUX3M2;
architecture mx of MUX3M2 is
    -- Componentes

    component MUX2 is
        port(
            M1 : in std_logic_vector(6 downto 0);
            M2 : in std_logic_vector(6 downto 0);
            Selec : in std_logic;
            Escolha : out std_logic_vector(6 downto 0)
        );
    end component;
    signal primeiro,segundo: std_logic_vector(6 downto 0);

begin

   Mux2_1 : MUX2 port map(
      M1 => G0,
      M2 => G1,
      Selec => E5,
      Escolha => primeiro
   );

   Mux2_2: MUX2 port map(
      M1 => G2,
      M2 => G3,
      Selec => end_round_aux,
      Escolha => segundo
   );

   Mux_Final : MUX2 port map(
      M1 => primeiro,
      M2 => segundo,
      Selec => E6,
      Escolha => Escolha
   );

end mx;