library ieee;
use ieee.std_logic_1164.all;

entity controlador is port (
clock,reset,enter, end_fpga, end_bonus, end_time, end_round: in std_logic;
r1, e1, e2, e3, e4, e5, e6: out std_logic );
end controlador;

architecture fsmcontrolador of controlador is
    type STATES is (start, setup, play_fpga, play_user, check, result, next_round, wait1);
    signal EAtual, PEstado: STATES;
begin

   
    process(clock,reset)
        begin
            if (reset = '0') then
                Eatual <= start;
            elsif (clock'event AND clock = '1') then 
                EAtual <= PEstado;
            end if;
    end process;


    process(EAtual,PEstado,clock,reset,enter, end_fpga, end_bonus, end_time, end_round)

        begin
            
            case EAtual is 
                -- START
                when start =>
                    r1 <= '1';----- o r1 é o reset principal este só sera 1 no start
                    e1 <= '0';

                    e2 <= '0';
                    e3 <= '0';
                    e4 <= '0';
                    e5 <= '0';
                    e6 <= '0';
                    PEstado <= setup;
                when setup =>
                    -- SETUP
                    r1 <= '0';
                    e1 <= '1';--- controla registrador que vai dar setup de tudo 

                    e2 <= '0';
                    e3 <= '0';
                    e4 <= '0';
                    e5 <= '0';
                    e6 <= '0';
                    
                    if enter = '0' then
                        PEstado <= play_fpga;
                    end if;
                    
                    -- PLAY_FPGA
                when play_fpga =>
                    r1 <= '0';
                    e1 <= '0';--- desativa registrador setup

                    e2 <= '1';--- conta tempo que aparece na tela e também faz aparecer na tela

                    e3 <= '0';--- vai ta 0 pois não vou contar o tempo player
                    e4 <= '0';--- não quero resetar counter level

                    e5 <= '0';--- escrever o jooj 
                    e6 <= '0';----  
                
                    if end_fpga = '1' then --- sinal dado pelo counter level 
                        PEstado <= play_user;
                    end if;

                     -- PLAY_USER

                when play_user =>
                    r1 <= '0';---padrão pois não quero resetar    
                    e1 <= '0';---nem mecher na setup,(REG_SETUP reseta com r1 e ativa com e1)

                    e2 <= '0';--- para de dar counter level 
                    e3 <= '1'; --- conta tempo do player

                    e4 <= '0';--- não vou resetar tempo 

                    e5 <= '0';
                    e6 <= '0';----aparecer user no display 

                    
                    if end_time = '1' then----- end time dado pelo counter time
                        PEstado <= result;
                    elsif enter = '0' then---- ja que o bonus só ativa quando aperta
                        PEstado <= check;   -- enter , então quando tu clica o bonus calcula 
                    end if;                 -- e ja da a resposta do end bonus  pois E3 ja ta ativo
        
                    
                when check =>
                    r1 <= '0';---padrão pois não quero resetar    
                    e1 <= '0';---nem mecher na setup,(REG_SETUP reseta com r1 e ativa com e1)    

                    e2 <= '0';--- e2 é só no turno do fpga
                    
                    e3 <= '0';---- destativa contar tempo

                    e4 <= '1';--- ativa o counter round

                    e5 <= '0';--- mux no check tanto faz acho
                    e6 <= '0';            


                        
                    if end_bonus = '1' then--- dado pelo bonus
                        PEstado <= result;
                    elsif end_round = '1' then--- dado pelo counter rouns
                        PEstado <= result;
                    else 
                        PEstado <= next_round;
                    end if;


                when next_round =>
                    r1 <= '0';---padrão pois não quero resetar    
                    e1 <= '0';---nem mecher na setup,(REG_SETUP reseta com r1 e ativa com e1)

                    e2 <= '0';---- sem fpga
                    e3 <= '0';---- sem user

                    e4 <= '0';-- passa e4 pra zero pq só vou usar uma vez

                    e5 <= '0';-- mux tanto faz
                    e6 <= '0';
                    PEstado <= wait1;
                
            

                when wait1 =>
                    r1 <= '0';---padrão pois não quero resetar    
                    e1 <= '0';---nem mecher na setup,(REG_SETUP reseta com r1 e ativa com e1)        
                    
                    e2 <= '0';--- n vou contar tempo
                    e3 <= '0';        

                    e4 <= '0'; ------- ja foi reseta counter level e e4

                    e5 <= '1';---- mostrar round nos hex
                    e6 <= '0';
                    if enter = '0' then
                        PEstado <= play_fpga;
                    end if;

                when result =>
                    r1 <= '0';---padrão pois não quero resetar    
                    e1 <= '0';---nem mecher na setup,(REG_SETUP reseta com r1 e ativa com e1)    
                    
                    e2 <= '0';
                    e3 <='0';
                    e4 <='0';
                    e5<= '0';

                    e6 <= '1';
                    if enter = '0' then
                        PEstado <= start;
                    end if;
                
            end case;
                
    end process;
 


end fsmcontrolador;               

                
                
                
                
                