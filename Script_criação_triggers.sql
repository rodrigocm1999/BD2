set serveroutput on;
begin
dbms_output.put_line('');dbms_output.put_line('');dbms_output.put_line('Start');dbms_output.put_line('Start');dbms_output.put_line('Start');
end;
/
--Triggers importantes para o funcionamento
-- p)   {
create or replace procedure jogador_equipa_check(id_jogo in number,id_pessoa in number) as
    equipa_A number;
    equipa_B number;
    equipa_pessoa number;
begin
    select id_equipa_casa,id_equipa_visitante into equipa_A,equipa_B
        from jogo
        where id_jogo=jogador_equipa_check.id_jogo;
    select id_equipa into equipa_pessoa
        from pessoa
        where id_pessoa=jogador_equipa_check.id_pessoa;
    if equipa_pessoa!=equipa_A and equipa_pessoa!=equipa_B then
           RAISE_APPLICATION_ERROR (-20001,'Esta Pessoa nao faz parte de nenhuma das equipas do jogo'); 
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
    jogador_equipa_check(:new.id_jogo,:new.id_pessoa);
end;
/
-- }
------------------------------------------
--Triggers pedidos para o trabalho
create or replace trigger golos_marcados -- Ready
    instead of insert on golos for each row
declare
    cursor cur is
        select jogador.id_jogador as id_jogador,count(golo.id_jogo) as quant
        from jogador,golo
        where golo.id_jogador=jogador.id_jogador  
        group by jogador.id_jogador,jogador.nome
        order by count(golo.id_jogo) desc;
    counter number := 0;
begin

    insert into golo values(:new.id_jogador,:new.id_jogo,:new.temp_jogo);

    delete from melhores_goleadores;
    for item in cur loop
        counter := counter + 1;
        if counter>10 then
            exit;
        end if;
        insert into melhores_goleadores values(counter,item.id_jogador,item.quant);    
    end loop;    
end;
/

create or replace trigger n_jogadores_estrangeiros -- Ready
    before insert or update of id_equipa on pessoa for each row
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

create or replace function vermelhos_jogador(id_pes number) return date as -- Ready lacks testing
    dat date;
Begin
    select max(fim) into dat from sancao_disciplinar sandis 
        where id_pessoa=id_pes and fim!=null;
    
    if dat is null then
        return to_date('01','YYYY');
    end if;
    return dat;
End;
/
--select vermelhos_jogador(15) from dual;

-- função vermelhos jogador é necesária para o funcionamento do trigger max_cartoes
create or replace trigger max_cartoes -- Ready lacks testing
    instead of insert on cartoes for each row
declare
    quant number;
begin
    select count(id_pessoa) into quant
        from cartoes
        where id_pessoa= :new.id_pessoa      
            and vermelhos_jogador(:new.id_pessoa)< (select data_ from jogo where jogo.id_jogo=cartoes.id_jogo)
        group by id_pessoa;
        
    if quant = 2 then
        insert into sancao_disciplinar values ((select max(id_sancao)+1  from sancao_disciplinar) ,:new.id_pessoa,:new.id_jogo,sysdate,null);
    else
        insert into cartao values(:new.id_cartao,:new.id_pessoa,:new.id_jogo,:new.tempo_jogo);
    end if;
end;
/

create or replace trigger treinador -- Nao existem nenhumas garantias que está correto
    after insert on Sancao_Disciplinar for each row
declare
    id_adjunto number(6);
    idEquipa number(6);
    tipoP varchar2(250);
begin
    
    select tipo into tipoP from pessoa where pessoa.id_pessoa = :new.id_pessoa;
    
    if tipoP = 'Jogador' then
        return;
    end if;

    update Pessoa set posicao = 'Suspenso' where id_pessoa = :new.id_pessoa;

    select id_equipa into idEquipa
    from treinador
    where id_treinador=:new.id_pessoa;
    
    select id_treinador into id_adjunto
    from treinador 
    where id_equipa=idEquipa and id_treinador!= :new.id_pessoa;
    
    update Pessoa set posicao = 'Principal' where id_pessoa = id_adjunto;
end;
/
--insert into Sancao_Disciplinar values(1,51,8,to_date('2018-11-22','YYYY-MM-DD'), null);

create or replace trigger passaram2jogos -- Nao existem nenhumas garantias que está correto
    instead of insert on Jogos for each row
declare
    idSancao number(6);
    InicioUltimaSancao date;
    FimUltimaSancao date;
    nJogosDesdeInicio number(5);

begin
    insert into Jogo values(:new.id_jogo,:new.id_equipa_casa,:new.id_equipa_visitante,:new.id_liga,:new.n_golos_casa,:new.n_golos_visitante,:new.data_);

    
    for treinador in (select * from treinador) loop
        if treinador.id_equipa in (:new.id_equipa_casa,:new.id_equipa_visitante) then
            
            select id_sancao,inicio,fim into idSancao,InicioUltimaSancao,FimUltimaSancao
                from sancao_disciplinar sandis
                where ROWNUM < 2 and id_pessoa=treinador.id_treinador
                order by sandis.inicio desc;
            
            if FimUltimaSancao is NULL then
                continue; -- Próóóxximo
            end if;
            
            select count(id_jogo) into nJogosDesdeInicio 
            from Jogo
            where treinador.id_equipa in (id_equipa_casa,id_equipa_visitante)
                and data_ > InicioUltimaSancao;
            
            if nJogosDesdeInicio >= 2 then
                update Sancao_disciplinar set fim = :new.data_ where id_sancao=idSancao;
            end if;
         
        end if;
    end loop;
    
    
end;
/








