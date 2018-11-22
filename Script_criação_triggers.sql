

create or replace trigger golo_jogador_equipa_check
    before insert on golo
    for each row
declare 
    equipa_A number;
    equipa_B number;
    equipa_jog number;
begin
    
    select id_equipa_casa,id_equipa_visitante into equipa_A,equipa_B
    from jogo
    where id_jogo=:new.id_jogo;
    
    select id_equipa into equipa_jog
    from jogador
    where id_jogador=:new.id_jogador;
    
    if equipa_jog!=equipa_A and equipa_jog!=equipa_B then
           RAISE_APPLICATION_ERROR (-20001,'Jogador nao faz parte de nenhuma das equipas do jogo'); 
    end if;
    
end;    
/