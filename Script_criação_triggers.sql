--Triggers importantes para o funcionamento
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
--Triggers pedidos para o trabalho
create or replace trigger golos_marcados
    after insert on golo for each row
declare
    cursor cur is
        select jogador.id_jogador as id_jogador
        from jogador,golo
        where golo.id_jogador=jogador.id_jogador        
        group by jogador.id_jogador,jogador.nome
        order by count(golo.id_jogo) desc;
    counter number := 0;
begin
    delete from melhores_goleadores;
    for item in cur loop
        counter := counter + 1;
        if counter>10 then
            exit;
        end if;
        insert into melhores_goleadores values(counter,item.id_jogador);    
    end loop;    
end;
/
create or replace trigger n_jogadores_estrangeiros
    before insert or update of id_equipa on jogador for each row
declare
    quant number;
begin
    select count(jogador.id_jogador) into quant
    from equipa,jogador
    where equipa.id_equipa=jogador.id_equipa
        and equipa.nacionalidade!=jogador.nacionalidade
        and equipa.id_equipa=:new.id_equipa;
        
    if quant > 5 then
        raise_application_error(-20999,'A equipa ja atingiu o limite de jogadores estrangeiros'); 
    end if;
end;
/
create or replace function vermelhos_jogador(id_jog number) return date as
    dat date;
Begin
    select max(fim) into dat from sancao_disciplinar sandis 
        where tipo like 'Vermelho' and id_jogador=id_jog and fim!=null;
    
    if dat = null then
        return to_date('0000','YYYY');
    end if;
    return dat;
End;
/
create or replace trigger max_cartoes
    after insert on sancao_disciplinar for each row
declare
    quant number;
begin
    select count(id_jogador) into quant
        from sancao_disciplinar
        where tipo like 'Amarelo' and id_jogador= :new.id_jogador
            and inicio>vermelhos_jogador(:new.id_jogador)
        group by id_jogador;
        
    if quant = 2 then
        insert into sancao_disciplinar values ((select max(id_sancao)+1  from sancao_disciplinar)
                                                ,:new.id_jogador,sysdate,null,'Vermelho',:new.id_jogo);
    end if;
end;
/