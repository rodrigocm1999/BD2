create or replace procedure jogador_equipa_check(id_jogo in number,id_jogador in number) as
    equipa_A number;
    equipa_B number;
    equipa_jog number;
begin
    select id_equipa_casa,id_equipa_visitante into equipa_A,equipa_B
        from jogo
        where id_jogo=jogador_equipa_check.id_jogo;
    select id_equipa into equipa_jog
        from jogador
        where id_jogador=jogador_equipa_check.id_jogador;
    if equipa_jog!=equipa_A and equipa_jog!=equipa_B then
           RAISE_APPLICATION_ERROR (-20001,'Jogador nao faz parte de nenhuma das equipas do jogo'); 
    end if;
end;
/
create or replace trigger golo_jogador_equipa_check
    before insert on Golo for each row
begin
    jogador_equipa_check(:new.id_jogo,:new.id_jogador);
end;    
/
create or replace trigger jogo_jogador_sancao
    before insert on Sancao_Disciplinar for each row   
begin
    jogador_equipa_check(:new.id_jogo,:new.id_jogador);
end;
/
